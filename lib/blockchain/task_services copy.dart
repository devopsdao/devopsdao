import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import 'abi/account_facet.g.dart';
import 'abi/axelar_facet.g.dart';
import 'abi/hyperlane_facet.g.dart';
import 'abi/ierc1155.g.dart';
import 'abi/ierc20.g.dart';
import 'abi/ierc721.g.dart';
import 'abi/layerzero_facet.g.dart';
import 'abi/task_contract.g.dart';
import 'abi/task_create_facet.g.dart';
import 'abi/task_data_facet.g.dart';
import 'abi/token_data_facet.g.dart';
import 'abi/token_facet.g.dart';
import 'abi/witnet_facet.g.dart';
import 'abi/wormhole_facet.g.dart';
import 'chain_presets/get_addresses.dart';
import 'models/account.dart';
import 'models/nft_collection.dart';
import 'models/task.dart';
import 'models/token_item.dart';
import 'services/task_update_service.dart';
import 'services/wallet_service.dart';
import 'utils/constants.dart';
import 'utils/debouncer.dart';
import 'utils/extensions.dart';

final _log = Logger('TaskService');

class TaskService {
  late final Web3Client _client;
  late final WalletService _walletService;
  late final TaskUpdateService _taskUpdateService;
  late final GetAddresses _getAddresses;
  late final Debouncer _debouncer;

  late final TaskCreateFacet _taskCreateFacet;
  late final TaskDataFacet _taskDataFacet;
  late final AccountFacet _accountFacet;
  late final TokenFacet _tokenFacet;
  late final TokenDataFacet _tokenDataFacet;
  late final AxelarFacet _axelarFacet;
  late final HyperlaneFacet _hyperlaneFacet;
  late final LayerzeroFacet _layerzeroFacet;
  late final WormholeFacet _wormholeFacet;
  late final WitnetFacet _witnetFacet;

  late final EthereumAddress _contractAddress;
  late final EthereumAddress _axelarContractAddress;
  late final EthereumAddress _hyperlaneContractAddress;
  late final EthereumAddress _layerzeroContractAddress;
  late final EthereumAddress _wormholeContractAddress;

  late final Map<String, NftCollection> _nftCollections;
  late final Map<EthereumAddress, Task> _tasks;
  late final Map<EthereumAddress, bool> _monitoredTasks;
  late final Map<String, Account> _accounts;

  TaskService({
    required Web3Client client,
    required WalletService walletService,
    required TaskUpdateService taskUpdateService,
    required GetAddresses getAddresses,
  })  : _client = client,
        _walletService = walletService,
        _taskUpdateService = taskUpdateService,
        _getAddresses = getAddresses,
        _debouncer = Debouncer(duration: const Duration(seconds: 1)),
        _nftCollections = {},
        _tasks = {},
        _monitoredTasks = {},
        _accounts = {};

  Future<void> init() async {
    _contractAddress = await _getAddresses.requestContractAddress(WalletService.chainId);
    _axelarContractAddress = await _getAddresses.requestAxelarAddress();
    _hyperlaneContractAddress = await _getAddresses.requestHyperlaneAddress();
    _layerzeroContractAddress = await _getAddresses.requestLayerzeroAddress();
    _wormholeContractAddress = await _getAddresses.requestWormholeAddress();

    _taskCreateFacet = TaskCreateFacet(address: _contractAddress, client: _client);
    _taskDataFacet = TaskDataFacet(address: _contractAddress, client: _client);
    _accountFacet = AccountFacet(address: _contractAddress, client: _client);
    _tokenFacet = TokenFacet(address: _contractAddress, client: _client);
    _tokenDataFacet = TokenDataFacet(address: _contractAddress, client: _client);
    _axelarFacet = AxelarFacet(address: _axelarContractAddress, client: _client);
    _hyperlaneFacet = HyperlaneFacet(address: _hyperlaneContractAddress, client: _client);
    _layerzeroFacet = LayerzeroFacet(address: _layerzeroContractAddress, client: _client);
    _wormholeFacet = WormholeFacet(address: _wormholeContractAddress, client: _client);
    _witnetFacet = WitnetFacet(address: _contractAddress, client: _client);

    await _subscribeToEvents();
    await _fetchNftCollections();
    await _fetchAccounts();
    await _fetchTasks();
  }

  Future<void> _subscribeToEvents() async {
    _tokenFacet.transferBatchEvents().listen((event) async {
      if (event.from == _walletService.publicAddress || event.to == _walletService.publicAddress) {
        await _fetchNftCollections();
      }
    });

    _taskCreateFacet.taskCreatedEvents().listen((event) async {
      await _monitorTask(event.taskAddress);
      await _updateTask(event.taskAddress);
    });
  }

  Future<void> _fetchNftCollections() async {
    final tokenNames = await _tokenDataFacet.getCreatedTokenNames();
    final nftCollections = <String, NftCollection>{};

    for (final tokenName in tokenNames) {
      final tokenIds = await _tokenDataFacet.getTokenIds(_walletService.publicAddress!);
      final balances = await _tokenFacet.balanceOfBatch(
        List.filled(tokenIds.length, _walletService.publicAddress!),
        tokenIds,
      );

      final tokenItems = <BigInt, TokenItem>{};
      for (var i = 0; i < tokenIds.length; i++) {
        if (balances[i] > BigInt.zero) {
          tokenItems[tokenIds[i]] = TokenItem(
            name: tokenName,
            id: tokenIds[i],
            collection: true,
            nft: true,
          );
        }
      }

      nftCollections[tokenName] = NftCollection(
        name: tokenName,
        tokenItems: tokenItems,
        selected: false,
      );
    }

    _nftCollections
      ..clear()
      ..addAll(nftCollections);
  }

  Future<void> _fetchAccounts() async {
    final accountAddresses = await _accountFacet.getAccountsList();
    final accountsData = await _accountFacet.getAccountsData(accountAddresses);
    final accounts = <String, Account>{};

    for (final accountData in accountsData) {
      accounts[accountData.walletAddress.hex] = Account.fromContractData(accountData);
    }

    _accounts
      ..clear()
      ..addAll(accounts);
  }

  Future<void> _fetchTasks() async {
    final taskAddresses = await _taskDataFacet.getTaskContracts();
    final tasks = await _getTasks(taskAddresses.reversed);

    _tasks
      ..clear()
      ..addAll(tasks);

    for (final task in tasks.values) {
      await _refreshTask(task);
    }
  }

  Future<Map<EthereumAddress, Task>> _getTasks(Iterable<EthereumAddress> taskAddresses) async {
    final taskDataList = await _taskDataFacet.getTasksData(taskAddresses);
    final tasks = <EthereumAddress, Task>{};

    for (var i = 0; i < taskDataList.length; i++) {
      final taskData = taskDataList[i];
      final taskAddress = taskAddresses.elementAt(i);
      final task = Task.fromContractData(taskData, taskAddress);
      tasks[taskAddress] = task;
    }

    return tasks;
  }

  Future<void> _monitorTask(EthereumAddress taskAddress) async {
    if (!_monitoredTasks.containsKey(taskAddress)) {
      _monitoredTasks[taskAddress] = true;

      final taskContract = TaskContract(address: taskAddress, client: _client);
      taskContract.taskUpdatedEvents().listen((event) {
        _debouncer.debounce(() async {
          await _updateTask(event.taskAddress);
          await _taskUpdateService.checkOpenedTask(event.taskAddress);
        });
      });
    }
  }

  Future<void> _updateTask(EthereumAddress taskAddress) async {
    final taskDataList = await _taskDataFacet.getTasksData([taskAddress]);
    final taskData = taskDataList.first;
    final task = Task.fromContractData(taskData, taskAddress);

    _tasks[taskAddress] = task;
    await _refreshTask(task);
  }

  Future<void> _refreshTask(Task task) async {
    // Refresh task logic goes here
    if (task.performer == _walletService.publicAddress) {
      // Performer-specific task refresh logic
    }

    if (task.taskState == 'agreed' || task.taskState == 'progress' || task.taskState == 'review' || task.taskState == 'audit') {
      if (task.contractOwner == _walletService.publicAddress) {
        // Customer-specific task refresh logic for in-progress tasks
      } else if (task.performer == _walletService.publicAddress) {
        // Performer-specific task refresh logic for in-progress tasks
      }
    }

    // Add more task refresh logic based on task state, roles, etc.
  }

  Future<String> createTask(Task task) async {
    final credentials = await _walletService.getCredentials();
    final taskData = task.toContractData();
    final transactionHash = await _taskCreateFacet.createTaskContract(
      taskData.senderAddress,
      taskData.toJson(),
      credentials: credentials,
    );
    return transactionHash;
  }

  // Implement remaining task-related methods
}

extension on TaskCreateFacet {
  Future<String> createTaskContract(
    EthereumAddress senderAddress,
    Map<String, dynamic> taskData, {
    required Credentials credentials,
    Transaction? transaction,
  }) async {
    final tx = transaction ?? Transaction(from: senderAddress);
    final txHash = await createTaskContract(
      senderAddress,
      taskData,
      credentials: credentials,
      transaction: tx,
    );
    return txHash;
  }
}

extension on TaskDataFacet {
  Future<List<EthereumAddress>> getTaskContracts() async {
    final taskCount = await getTaskContractsCount();
    final taskAddresses = <EthereumAddress>[];

    for (var i = 0; i < taskCount.toInt(); i++) {
      final taskAddress = await getTaskContractByIndex(BigInt.from(i));
      taskAddresses.add(taskAddress);
    }

    return taskAddresses;
  }

  Future<List<Task>> getTasksData(Iterable<EthereumAddress> taskAddresses) async {
    final tasksData = await getTasksData(taskAddresses.toList());
    final tasks = tasksData.map((taskData) => Task.fromContractData(taskData, taskAddresses.elementAt(tasksData.indexOf(taskData)))).toList();
    return tasks;
  }
}

extension on AccountFacet {
  Future<List<EthereumAddress>> getAccountsList() async {
    final accountCount = await getAccountsCount();
    final accountAddresses = <EthereumAddress>[];

    for (var i = 0; i < accountCount.toInt(); i++) {
      final accountAddress = await getAccountByIndex(BigInt.from(i));
      accountAddresses.add(accountAddress);
    }

    return accountAddresses;
  }

  Future<List<Account>> getAccountsData(List<EthereumAddress> accountAddresses) async {
    final accountsData = await getAccountsData(accountAddresses);
    final accounts = accountsData.map((accountData) => Account.fromContractData(accountData)).toList();
    return accounts;
  }
}

extension on TokenDataFacet {
  Future<List<String>> getCreatedTokenNames() async {
    final tokenCount = await getCreatedTokenCount();
    final tokenNames = <String>[];

    for (var i = 0; i < tokenCount.toInt(); i++) {
      final tokenName = await getCreatedTokenNameByIndex(BigInt.from(i));
      tokenNames.add(tokenName);
    }

    return tokenNames;
  }

  Future<List<BigInt>> getTokenIds(EthereumAddress accountAddress) async {
    final tokenCount = await getTokenCount(accountAddress);
    final tokenIds = <BigInt>[];

    for (var i = 0; i < tokenCount.toInt(); i++) {
      final tokenId = await getTokenIdByIndex(accountAddress, BigInt.from(i));
      tokenIds.add(tokenId);
    }

    return tokenIds;
  }
}

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  void debounce(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class Account {
  final EthereumAddress walletAddress;
  final String? nickName;
  final String? about;
  final List<EthereumAddress> customerTasks;
  final List<EthereumAddress> participantTasks;
  final List<EthereumAddress> auditParticipantTasks;
  final List<BigInt> customerRating;
  final List<BigInt> performerRating;
  final List<EthereumAddress> agreedTasks;
  final List<EthereumAddress> auditAgreed;
  final List<EthereumAddress> completedTasks;

  Account({
    required this.walletAddress,
    this.nickName,
    this.about,
    required this.customerTasks,
    required this.participantTasks,
    required this.auditParticipantTasks,
    required this.customerRating,
    required this.performerRating,
    required this.agreedTasks,
    required this.auditAgreed,
    required this.completedTasks,
  });

  factory Account.fromContractData(List<dynamic> data) {
    return Account(
      walletAddress: data[0] as EthereumAddress,
      nickName: data[1] as String?,
      about: data[2] as String?,
      customerTasks: (data[3] as List).cast<EthereumAddress>(),
      participantTasks: (data[4] as List).cast<EthereumAddress>(),
      auditParticipantTasks: (data[5] as List).cast<EthereumAddress>(),
      customerRating: (data[6] as List).cast<BigInt>(),
      performerRating: (data[7] as List).cast<BigInt>(),
      agreedTasks: (data[8] as List).cast<EthereumAddress>(),
      auditAgreed: (data[9] as List).cast<EthereumAddress>(),
      completedTasks: (data[10] as List).cast<EthereumAddress>(),
    );
  }
}

class NftCollection {
  final String name;
  final Map<BigInt, TokenItem> tokenItems;
  final bool selected;

  NftCollection({
    required this.name,
    required this.tokenItems,
    required this.selected,
  });
}

class TokenItem {
  final String name;
  final BigInt id;
  final bool collection;
  final bool nft;

  TokenItem({
    required this.name,
    required this.id,
    required this.collection,
    required this.nft,
  });
}

class Task {
  final String nanoId;
  final DateTime createTime;
  final String taskType;
  final String title;
  final String description;
  final String repository;
  final List<String> tags;
  final List<String> tagsNFT;
  final List<List<String>> tokenNames;
  final List<EthereumAddress> tokenContracts;
  final List<List<BigInt>> tokenIds;
  final List<List<BigInt>> tokenAmounts;
  final String taskState;
  final String auditState;
  final int performerRating;
  final int customerRating;
  final EthereumAddress contractOwner;
  final EthereumAddress performer;
  final EthereumAddress auditInitiator;
  final EthereumAddress auditor;
  final List<EthereumAddress> participants;
  final List<EthereumAddress> funders;
  final List<EthereumAddress> auditors;
  final List<dynamic> messages;
  final EthereumAddress taskAddress;
  final bool loadingIndicator;
  final List<double> tokenBalances;
  final String transport;

  Task({
    required this.nanoId,
    required this.createTime,
    required this.taskType,
    required this.title,
    required this.description,
    required this.repository,
    required this.tags,
    required this.tagsNFT,
    required this.tokenNames,
    required this.tokenContracts,
    required this.tokenIds,
    required this.tokenAmounts,
    required this.taskState,
    required this.auditState,
    required this.performerRating,
    required this.customerRating,
    required this.contractOwner,
    required this.performer,
    required this.auditInitiator,
    required this.auditor,
    required this.participants,
    required this.funders,
    required this.auditors,
    required this.messages,
    required this.taskAddress,
    required this.loadingIndicator,
    required this.tokenBalances,
    required this.transport,
  });

  factory Task.fromContractData(List<dynamic> data, EthereumAddress taskAddress) {
    return Task(
      nanoId: data[0][0].toString(),
      createTime: DateTime.fromMillisecondsSinceEpoch(data[0][1].toInt() * 1000),
      taskType: data[0][2] as String,
      title: data[0][3] as String,
      description: data[0][4] as String,
      repository: data[0][5] as String,
      tags: (data[0][6] as List).cast<String>(),
      tagsNFT: (data[0][7] as List).cast<String>(),
      tokenNames: (data[1] as List).map((names) => names.cast<String>()).toList(),
      tokenContracts: (data[0][8] as List).cast<EthereumAddress>(),
      tokenIds: (data[0][9] as List).map((ids) => ids.cast<BigInt>()).toList(),
      tokenAmounts: (data[0][10] as List).map((amounts) => amounts.cast<BigInt>()).toList(),
      taskState: data[0][11] as String,
      auditState: data[0][12] as String,
      performerRating: data[0][13].toInt(),
      customerRating: data[0][14].toInt(),
      contractOwner: data[0][15] as EthereumAddress,
      performer: data[0][16] as EthereumAddress,
      auditInitiator: data[0][17] as EthereumAddress,
      auditor: data[0][18] as EthereumAddress,
      participants: (data[0][19] as List).cast<EthereumAddress>(),
      funders: (data[0][20] as List).cast<EthereumAddress>(),
      auditors: (data[0][21] as List).cast<EthereumAddress>(),
      messages: data[0][22] as List<dynamic>,
      taskAddress: taskAddress,
      loadingIndicator: false,
      tokenBalances: (data[2] as List).map((balance) => balance.toDouble()).toList(),
      transport: data[0][9] as String? ?? '',
    );
  }

  Map<String, dynamic> toContractData() {
    return {
      'nanoId': nanoId,
      'taskType': taskType,
      'title': title,
      'description': description,
      'repository': repository,
      'tags': tags,
      'tokenContracts': tokenContracts,
      'tokenIds': tokenIds,
      'tokenAmounts': tokenAmounts,
    };
  }
}

class WalletService {
  static const allowedChainIds = {
    'Dodao Tanssi Appchain': 855456,
    'Moonbase Alpha': 1287,
    'Fantom testnet': 4002,
    'zkSync Era testnet': 280,
    'Polygon Mumbai': 80001,
  };

  static const chainTickers = {1287: 'DEV', 4002: 'FTM', 280: 'ETH', 855456: 'DODAO', 80001: 'MATIC'};

  static int chainId = 855456;
  static EthereumAddress? walletAddress;

  Future<void> init() async {
    // Wallet initialization logic
    // ...
  }

  Future<Credentials> getCredentials() async {
    // Credentials retrieval logic
    // ...
    throw UnimplementedError();
  }

  bool checkAllowedChainId() {
    return allowedChainIds.values.contains(chainId);
  }

  Future<void> writeChainId(int newChainId) async {
    chainId = newChainId;
    // Chain ID persistence logic
    // ...
  }

  Future<void> writeDefaultChainId() async {
    chainId = 855456;
    // Chain ID persistence logic
    // ...
  }
}

class TaskUpdateService {
  Future<void> checkOpenedTask(EthereumAddress taskAddress) async {
    // Opened task checking logic
    // ...
  }
}

class GetAddresses {
  Future<EthereumAddress> requestContractAddress(int chainId) async {
    // Contract address retrieval logic based on chain ID
    // ...
    throw UnimplementedError();
  }

  Future<EthereumAddress> requestAxelarAddress() async {
    // Axelar contract address retrieval logic
    // ...
    throw UnimplementedError();
  }

  Future<EthereumAddress> requestHyperlaneAddress() async {
    // Hyperlane contract address retrieval logic
    // ...
    throw UnimplementedError();
  }

  Future<EthereumAddress> requestLayerzeroAddress() async {
    // Layerzero contract address retrieval logic
    // ...
    throw UnimplementedError();
  }

  Future<EthereumAddress> requestWormholeAddress() async {
    // Wormhole contract address retrieval logic
    // ...
    throw UnimplementedError();
  }
}

extension StringExtension on String {
  Uint8List toUint8List() {
    return Uint8List.fromList(codeUnits);
  }
}

extension Uint8ListExtension on Uint8List {
  String toHexString() {
    return '0x${hex.encode(this)}';
  }
}

extension ListExtension<T> on List<T> {
  Iterable<List<T>> batch(int size) sync* {
    for (var i = 0; i < length; i += size) {
      yield sublist(i, i + size > length ? length : i + size);
    }
  }
}
