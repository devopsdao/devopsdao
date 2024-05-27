import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'dart:io';
import 'dart:math';
import 'package:logging/logging.dart';
import 'package:collection/collection.dart';

import 'package:js/js.dart' if (dart.library.io) 'package:webthree/src/browser/js_stub.dart' if (dart.library.js) 'package:js/js.dart';
import 'package:js/js_util.dart' if (dart.library.io) 'package:webthree/src/browser/js_util_stub.dart' if (dart.library.js) 'package:js/js_util.dart';
import 'package:webthree/webthree.dart';

import 'package:week_of_year/week_of_year.dart';

import 'package:dodao/config/utils/util.dart';
import 'package:throttling/throttling.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

import '../task_dialog/services/task_update_service.dart';
import '../wallet/services/wallet_service.dart';
import 'chain_presets/get_addresses.dart';
import 'abi/TaskCreateFacet.g.dart';
import 'abi/TaskDataFacet.g.dart';
import 'abi/AccountFacet.g.dart';
import 'abi/TokenFacet.g.dart';
import 'abi/TokenDataFacet.g.dart';
import 'abi/TaskContract.g.dart';
import 'abi/AxelarFacet.g.dart';
import 'abi/HyperlaneFacet.g.dart';
import 'abi/LayerzeroFacet.g.dart';
import 'abi/WormholeFacet.g.dart';
import 'abi/WitnetFacet.g.dart';
import 'abi/IERC165.g.dart';
import 'abi/IERC1155.g.dart';
import 'abi/IERC721.g.dart';
import 'abi/IERC20.g.dart';
import 'accounts.dart';
import 'classes.dart';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'package:package_info_plus/package_info_plus.dart';

final log = Logger('TaskServices');

// Helper function to map a Map to a JavaScript object
Object mapToJsObject(Map map) {
  var object = newObject();
  map.forEach((k, v) {
    if (v is Map) {
      setProperty(object, k, mapToJsObject(v));
    } else {
      setProperty(object, k, v);
    }
  });
  return object;
}

// Helper function to convert a JavaScript object to a Map
Map jsObjectToMap(dynamic jsObject) {
  Map result = {};
  List keys = _objectKeys(jsObject);
  for (dynamic key in keys) {
    dynamic value = getProperty(jsObject, key);
    List nestedKeys = [];
    if (value is List) {
      nestedKeys = objectKeys(value);
    }
    if ((nestedKeys).isNotEmpty) {
      // Nested property
      result[key] = jsObjectToMap(value);
    } else {
      result[key] = value;
    }
  }
  return result;
}

// Helper function to get the keys of a JavaScript object
List<String> objectKeys(dynamic jsObject) {
  return _objectKeys(jsObject);
}

@JS('Object.keys')
external List<String> _objectKeys(jsObject);

@JS()
@anonymous
class JSrawRequestSwitchChainParams {
  external String get chainId;

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestSwitchChainParams({String chainId});
}

@JS('JSON.stringify')
external String stringify(Object obj);

class GetTaskException implements Exception {
  String getTaskExceptionMsg() => 'Oops! something went wrong';
}

class TasksServices extends ChangeNotifier {
  final _walletService = WalletService();
  final _getAddresses = GetAddresses();
  bool hardhatDebug = false;
  bool hardhatLive = false;
  int liveAccount = 0; // Choose hardhat account (wallet) to use

  // Maps to store tasks
  Map<EthereumAddress, Task> tasks = {};
  Map<EthereumAddress, Task> filterResults = {};
  Map<EthereumAddress, Task> tasksNew = {};
  Map<EthereumAddress, Task> tasksAuditPending = {};
  Map<EthereumAddress, Task> tasksAuditApplied = {};
  Map<EthereumAddress, Task> tasksAuditWorkingOn = {};
  Map<EthereumAddress, Task> tasksAuditComplete = {};
  Map<EthereumAddress, Task> tasksPerformerParticipate = {};
  Map<EthereumAddress, Task> tasksPerformerProgress = {};
  Map<EthereumAddress, Task> tasksPerformerComplete = {};
  Map<EthereumAddress, Task> tasksCustomerSelection = {};
  Map<EthereumAddress, Task> tasksCustomerProgress = {};
  Map<EthereumAddress, Task> tasksCustomerComplete = {};
  Map<EthereumAddress, bool> monitoredTasks = {};

  // Maps to store task statistics
  Map<String, int> statsCreateTimeListCounts = {};
  Map<String, int> statsTaskTypeListCounts = {};
  Map<String, int> statsTagsListCounts = {};
  Map<String, int> statsTagsNFTListCounts = {};
  Map<String, int> statsTaskStateListCounts = {};
  Map<String, int> statsAuditStateListCounts = {};
  Map<String, int> statsRatingListCounts = {};
  Map<String, int> statsContractOwnerListCounts = {};
  Map<String, int> statsPerformerListCounts = {};
  Map<String, int> statsParticipantsListCounts = {};
  Map<String, int> statsFundersListCounts = {};
  Map<String, int> statsAuditorListCounts = {};
  Map<String, int> statsAuditorsListCounts = {};
  Map<String, int> statsTokenNamesListCounts = {};
  Map<String, int> statsTokenValuesListCounts = {};

  Map<String, Map<String, Map<String, dynamic>>> transactionStatuses = {};

  bool transportEnabled = true;
  String transportUsed = '';
  String interchainSelected = 'axelar';
  EthereumAddress transportAxelarAdr = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
  EthereumAddress transportHyperlaneAdr = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

  var credentials;

  EthereumAddress? publicAddress = WalletService.walletAddress;
  double ethBalance = 0;
  double ethBalanceToken = 0;
  double pendingBalance = 0;
  double pendingBalanceToken = 0;

  late Map<String, dynamic> roleNfts = {'auditor': 0, 'governor': 0};

  String platform = 'mobile';

  String version = '';
  String buildNumber = '';
  late String _rpcUrl;
  late String _wsUrl;

  late int chainId;
  late String chainTicker = 'ETH';

  int chainIdAxelar = 80001;
  int chainIdHyperlane = 80001;
  int chainIdLayerzero = 80001;
  int chainIdWormhole = 80001;

  bool isLoading = true;
  bool isLoadingBackground = false;

  late Web3Client web3client;
  late Web3Client web3clientAxelar;
  late Web3Client web3clientHyperlane;
  late Web3Client web3clientLayerzero;
  late Web3Client web3clientWormhole;

  bool isDeviceConnected = false;

  late IERC20 ierc20;

  TasksServices() {
    Logger.root.level = Level.ALL; // Set logging level to ALL
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    try {
      // Detect platform
      if (Platform.isAndroid || Platform.isIOS) {
        platform = 'mobile';
      } else if (Platform.isLinux) {
        platform = 'linux';
      }
    } catch (e) {
      platform = 'web';
    }

    log.fine("platform: $platform");

    init();
  }

  Future<void> init() async {
    // Initialize RPC URL and WebSocket URL based on the chain ID
    if (hardhatDebug == true || hardhatLive == true) {
      _walletService.writeChainId(31337);
      chainTicker = 'ETH';
      _rpcUrl = 'http://localhost:8545';
      _wsUrl = 'ws://localhost:8545';
    } else {
      _walletService.writeDefaultChainId();
    }

    // Check for internet connectivity
    isDeviceConnected = await InternetConnection().hasInternetAccess;

    // Listen for connectivity changes (if not on the web platform)
    if (platform != 'web') {
      final StreamSubscription subscription =
          Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          isDeviceConnected = await InternetConnection().hasInternetAccess;
        }
      });
    }

    // Connect to RPC and initialize services
    await connectRPC(WalletService.chainId);
    await startup();
    await myBalance();

    // Hardhat-specific initialization
    if (hardhatDebug == true || hardhatLive == true) {
      String hardhatAccountsFile = await rootBundle.loadString('lib/blockchain/accounts/hardhat.json');
      hardhatAccounts = jsonDecode(hardhatAccountsFile);
      credentials = EthPrivateKey.fromHex(hardhatAccounts[liveAccount]["key"]);
      publicAddress = EthereumAddress.fromHex(hardhatAccounts[liveAccount]["address"]);
    }

    await connectContracts();
  }

  Future<void> connectRPC(int chainId) async {
    this.chainId = chainId;

    if (chainId == 31337 || hardhatDebug == true || hardhatLive == true) {
      chainTicker = 'ETH';
      _rpcUrl = 'http://localhost:8545';
      _wsUrl = 'ws://localhost:8545';
    } else if (chainId == 1287) {
      chainTicker = 'DEV';
      _rpcUrl = 'https://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    } else if (chainId == 4002) {
      chainTicker = 'FTM';
      _rpcUrl = 'https://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    } else if (chainId == 64165) {
      chainTicker = 'FTM';
      _rpcUrl = 'https://rpc.sonic.fantom.network';
      _wsUrl = 'wss://rpc.sonic.fantom.network';
    } else if (chainId == 80001) {
      chainTicker = 'MATIC';
      _rpcUrl = 'https://polygon-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://polygon-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    } else if (chainId == 1442) {
      chainTicker = 'MATIC';
      _rpcUrl = 'https://polygon-zkevm-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://ws.public.zkevm-test.net';
    } else if (chainId == 280) {
      chainTicker = 'ETH';
      _rpcUrl = 'https://zksync-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://zksync-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    } else if (chainId == 855456) {
      chainTicker = 'DODAO';
      _rpcUrl = 'https://fraa-flashbox-2804-rpc.a.stagenet.tanssi.network';
      _wsUrl = 'wss://fraa-flashbox-2804-rpc.a.stagenet.tanssi.network';
    } else if (chainId == 168587773) {
      chainTicker = 'ETH';
      _rpcUrl = 'https://sepolia.blast.io';
      _wsUrl = 'wss://sepolia.blast.io';
    } else if (chainId == 534351) {
      chainTicker = 'ETH';
      _rpcUrl = 'https://scroll-sepolia.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
      _wsUrl = 'wss://scroll-sepolia.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f';
    } else if (chainId == 3441005) {
      chainTicker = 'MANTA';
      _rpcUrl = 'https://pacific-rpc.testnet.manta.network/http';
      _wsUrl = 'wss://pacific-rpc.testnet.manta.network/ws';
    } else if (chainId == 11155111) {
      chainTicker = 'ETH';
      _rpcUrl = 'https://rpc2.sepolia.org/';
      _wsUrl = 'wss://rpc2.sepolia.dev';
    } else if (chainId == 3110) {
      chainTicker = 'ETH';
      _rpcUrl = 'https://test-rpc-node-http.svmscan.io';
      _wsUrl = 'wss://test-rpc-node-http.svmscan.io';} else if (chainId == 1029) {
     chainTicker = 'BTT';
     _rpcUrl = 'https://pre-rpc.bt.io';
     _wsUrl = 'wss://pre-rpc.bt.io';
   }

   if (hardhatLive == false) {
     web3clientAxelar = Web3Client(
       _rpcUrl,
       http.Client(),
       socketConnector: () {
         if (platform == 'web') {
           final uri = Uri.parse(_wsUrl);
           return WebSocketChannel.connect(uri).cast<String>();
         } else {
           return IOWebSocketChannel.connect(_wsUrl).cast<String>();
         }
       },
     );
     web3clientHyperlane = Web3Client(
       _rpcUrl,
       http.Client(),
       socketConnector: () {
         if (platform == 'web') {
           final uri = Uri.parse(_wsUrl);
           return WebSocketChannel.connect(uri).cast<String>();
         } else {
           return IOWebSocketChannel.connect(_wsUrl).cast<String>();
         }
       },
     );
     web3clientLayerzero = Web3Client(
       _rpcUrl,
       http.Client(),
       socketConnector: () {
         if (platform == 'web') {
           final uri = Uri.parse(_wsUrl);
           return WebSocketChannel.connect(uri).cast<String>();
         } else {
           return IOWebSocketChannel.connect(_wsUrl).cast<String>();
         }
       },
     );
     web3clientWormhole = Web3Client(
       _rpcUrl,
       http.Client(),
       socketConnector: () {
         if (platform == 'web') {
           final uri = Uri.parse(_wsUrl);
           return WebSocketChannel.connect(uri).cast<String>();
         } else {
           return IOWebSocketChannel.connect(_wsUrl).cast<String>();
         }
       },
     );
   }

   web3client = Web3Client(
     _rpcUrl,
     http.Client(),
     socketConnector: () {
       if (platform == 'web') {
         final uri = Uri.parse(_wsUrl);
         return WebSocketChannel.connect(uri).cast<String>();
       } else {
         return IOWebSocketChannel.connect(_wsUrl).cast<String>();
       }
     },
   );
 }

 Future<void> startup() async {
   // Clear collection and NFT maps on startup
   resultInitialCollectionMap = {};
   resultNftsMap = {};

   isLoadingBackground = true;
   WidgetsFlutterBinding.ensureInitialized();

   PackageInfo packageInfo = await PackageInfo.fromPlatform();
   version = packageInfo.version;
   buildNumber = packageInfo.buildNumber;

   _contractAddress = await _getAddresses.requestContractAddress(WalletService.chainId);

   if (hardhatLive == false) {
     _contractAddressAxelar = await _getAddresses.requestAxelarAddress();
     _contractAddressHyperlane = await _getAddresses.requestHyperlaneAddress();
     _contractAddressLayerzero = await _getAddresses.requestLayerzeroAddress();
     _contractAddressWormhole = await _getAddresses.requestWormholeAddress();
   }

   log.fine("Contracts initialized: $contractsInitialized");

   thr = Debouncing(duration: const Duration(seconds: 1));

   isLoadingBackground = false;
 }

 Future<void> connectContracts() async {
   EthereumAddress tokenContractAddress =
       EthereumAddress.fromHex('0xD1633F7Fb3d716643125d6415d4177bC36b7186b');

   ierc20 = IERC20(address: tokenContractAddress, client: web3client, chainId: WalletService.chainId);
   taskCreateFacet = TaskCreateFacet(address: _contractAddress, client: web3client, chainId: WalletService.chainId);
   taskDataFacet = TaskDataFacet(address: _contractAddress, client: web3client, chainId: WalletService.chainId);
   accountFacet = AccountFacet(address: _contractAddress, client: web3client, chainId: WalletService.chainId);
   tokenFacet = TokenFacet(address: _contractAddress, client: web3client, chainId: WalletService.chainId);
   tokenDataFacet = TokenDataFacet(address: _contractAddress, client: web3client, chainId: WalletService.chainId);

   if (hardhatLive == false) {
     axelarFacet =
         AxelarFacet(address: _contractAddressAxelar, client: web3clientAxelar, chainId: chainIdAxelar);
     hyperlaneFacet =
         HyperlaneFacet(address: _contractAddressHyperlane, client: web3clientHyperlane, chainId: chainIdHyperlane);
     layerzeroFacet =
         LayerzeroFacet(address: _contractAddressLayerzero, client: web3clientLayerzero, chainId: chainIdLayerzero);
     wormholeFacet =
         WormholeFacet(address: _contractAddressWormhole, client: web3clientWormhole, chainId: chainIdWormhole);
     witnetFacet = WitnetFacet(address: _contractAddress, client: web3client, chainId: WalletService.chainId);
   }

   contractsInitialized = true;
 }

 Future<void> myBalance() async {
   if (publicAddress != null) {
     final EtherAmount balance = await web3GetBalance(publicAddress!);
     final BigInt weiBalance = balance.getInWei;
     final ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
     ethBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();

     late BigInt weiBalanceToken = BigInt.from(0);
     if (hardhatDebug == false && hardhatLive == false) {
       weiBalanceToken = await web3GetBalanceToken(publicAddress!, 'USDC');
     }

     final ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 6);
     ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

     final List<EthereumAddress> shared = List.filled(roleNfts.keys.toList().length, publicAddress!);
     final List roleNftsBalance = await balanceOfBatchName(shared, roleNfts.keys.toList());

     int keyId = 0;
     roleNfts = roleNfts.map((key, value) {
       int newBalance = roleNftsBalance[keyId].toInt();
       MapEntry<String, int> mapEnt = MapEntry(key, newBalance);
       keyId++;
       return mapEnt;
     });
   }
   notifyListeners();
 }

 late Map<String, NftCollection> resultInitialCollectionMap = {};
 late Map<String, NftCollection> resultNftsMap = {};

 Future<void> collectMyTokens() async {
   var ierc1155 = IERC1155(address: _contractAddress, client: web3client, chainId: WalletService.chainId);
   final List<String> names = await getCreatedTokenNames();

   for (var e in names) {
     resultInitialCollectionMap[e] = NftCollection(bunch: {BigInt.from(0): TokenItem(name: e, collection: true)}, selected: false, name: e);
   }

   if (publicAddress != null) {
     final List<String> tokenNames = [];
     final List<BigInt> tokenIds = [];
     final List<String> rawTokenNames = await getTokenNames(publicAddress!);
     final List<BigInt> rawTokenIds = await getTokenIds(publicAddress!);
     final List<EthereumAddress> filledAddressesList = List<EthereumAddress>.filled(rawTokenIds.length, publicAddress!);
     final balanceOf = await ierc1155.balanceOfBatch(filledAddressesList, rawTokenIds);

     for (int i = 0; i < rawTokenNames.length; i++) {
       final BigInt num = balanceOf[i];
       if (num != BigInt.from(0)) {
         tokenNames.add(rawTokenNames[i]);
         tokenIds.add(rawTokenIds[i]);
       }
     }

     final Map<BigInt, String> combinedTokenMap = Map.fromIterables(tokenIds, tokenNames);
     final Map<String, List<BigInt>> result = combinedTokenMap.entries.fold(
       {},
       (Map<String, List<BigInt>> acc, entry) {
         final key = entry.value;
         final value = entry.key;
         acc.putIfAbsent(key, () => []).add(value);
         return acc;
       },
     );
     resultNftsMap.clear();

     for (var e in result.entries) {
       if (e.value.isNotEmpty) {
         Map<BigInt, TokenItem> bunch = {};
         for (int i = 0; i < e.value.length; i++) {
           bunch[e.value[i]] = TokenItem(name: e.key, collection: true, nft: true, id: e.value[i]);
         }
         resultNftsMap[e.key] = NftCollection(bunch: bunch, selected: false, name: e.key);
       }
     }
   }
 }

 Future<void> monitorEvents() async {
   final subscription = taskCreateFacet.taskCreatedEvents().listen((event) async {
     log.fine('monitorEvents received event for contract ${event.contractAdr} message: ${event.message} timestamp: ${event.timestamp}');
     try {
       await monitorTaskEvents(event.contractAdr);
     } on GetTaskException {
       log.warning('could not get task ${event.contractAdr} from blockchain');
     } catch (e) {
       log.severe(e);
     }
   });

   tokenFacet.transferBatchEvents().listen((event) async {
     log.fine(
         'received event approvalEvents from: ${event.from} operator: ${event.operator} to: ${event.to} ids: ${event.ids} values: ${event.values}');
     if (event.from == publicAddress || event.to == publicAddress) {
       await collectMyTokens();
     }
   });

   tokenFacet.approvalForAllEvents().listen((event) async {
     log.fine('received event approvalEvents account: ${event.account} operator: ${event.operator} approved: ${event.approved}');
     if (event.account == publicAddress) {}
   });

   final subscription3 = ierc20.approvalEvents().listen((event) async {
     log.fine('received event approvalEvents ${event.owner} spender ${event.spender} value ${event.value}');
     if (event.owner == publicAddress) {
       log.fine(event.owner);
     }
   });
 }

 final _taskUpdateService = TaskUpdateService();
 Debouncing mainDebounce = Debouncing(duration: const Duration(seconds: 1));

 Future<void> monitorTaskEvents(EthereumAddress taskAddress) async {
   TaskContract taskContract = TaskContract(address: taskAddress, client: web3client, chainId: WalletService.chainId);
   final subscription = taskContract.taskUpdatedEvents().listen((event) async {
     log.fine('monitorTaskEvents received event for contract ${event.contractAdr} message: ${event.message} timestamp: ${event.timestamp}');
     try {
       final Map<EthereumAddress, Task> tasksTemp = await getTasksData([event.contractAdr]);
       tasks[event.contractAdr] = tasksTemp[event.contractAdr]!;
       await refreshTask(tasks[event.contractAdr]!);
       log.fine('refreshed task: ${tasks[event.contractAdr]!.title}');
       await myBalance();

       mainDebounce.debounce(() {
         _taskUpdateService.initCheckingOpenedTask(event.contractAdr);
       });

       notifyListeners();
     } on GetTaskException {
       log.severe('could not get task ${event.contractAdr} from blockchain');
     } catch (e) {
       log.severe(e);
     }
   });
 }

 Future tellMeHasItMined(String hash, String taskAction, String nanoId, [String messageNanoId = '']) async {
   if (hash.length == 66) {
     TransactionReceipt? transactionReceipt = await web3GetTransactionReceipt(hash);
     while (transactionReceipt == null) {
       transactionReceipt = await web3GetTransactionReceipt(hash);
       if (transactionReceipt == null) {
         await Future.delayed(const Duration(milliseconds: 1000));
       }
     }
     if (messageNanoId != '') {
       taskAction = '${taskAction}_$messageNanoId';
     }

     if (transactionReceipt.status == true) {
       transactionStatuses[nanoId]![taskAction]!['status'] = 'minted';
       transactionStatuses[nanoId]![taskAction]!['txn'] = hash;
     }

     isLoadingBackground = false;
     notifyListeners();
   }
 }

 Future<void> runFilter(
     {required Map<EthereumAddress, Task> taskList, required String enteredKeyword, required Map<String, NftCollection> tagsMap}) async {
   final List<String> tagsList = tagsMap.entries.map((e) => e.value.name).toList();

   filterResults.clear();

   if (true) {
     final filterResultsTitle = Map.from(taskList)
       ..removeWhere((taskAddress, task) => !task.title.toLowerCase().contains(enteredKeyword.toLowerCase()));
     final filterResultsDescription = Map.from(taskList)
       ..removeWhere((taskAddress, task) => !task.description.toLowerCase().contains(enteredKeyword.toLowerCase()));
     late Map<EthereumAddress, Task> filterResultsTaskAddress = {};
     late Map<EthereumAddress, Task> filterResultsContractOwner = {};
     late Map<EthereumAddress, Task> filterResultsPerformer = {};
     late Map<EthereumAddress, Task> filterResultsAuditor = {};
     if (enteredKeyword.length > 41 && enteredKeyword.length <= 43) {
       filterResultsTaskAddress = Map.from(taskList)..removeWhere((taskAddress, task) => !task.taskAddress.toString().contains(enteredKeyword!));
       filterResultsContractOwner = Map.from(taskList)..removeWhere((taskAddress, task) => !task.contractOwner.toString().contains(enteredKeyword!));
       filterResultsPerformer = Map.from(taskList)..removeWhere((taskAddress, task) => !task.performer.toString().contains(enteredKeyword!));
       filterResultsAuditor = Map.from(taskList)..removeWhere((taskAddress, task) => !task.auditor.toString().contains(enteredKeyword!));
     }
     Map<EthereumAddress, Task> filterResultsSearch = {
       ...filterResultsTitle,
       ...filterResultsDescription,
       ...filterResultsTaskAddress,
       ...filterResultsContractOwner,
       ...filterResultsPerformer,
       ...filterResultsAuditor,
     };

     if (tagsList.isNotEmpty) {
       late Map<EthereumAddress, Task> filteredWithTags;
       late Map<EthereumAddress, Task> filteredWithNfts;
       Map<EthereumAddress, Task> filterResultsTags = filterResultsSearch;
       for (var tag in tagsList) {
         filteredWithTags = Map.from(filterResultsTags)..removeWhere((key, value) => !value.tags.contains(tag));
         filteredWithNfts = Map.from(filterResultsTags)
           ..removeWhere((key, value) {
             bool result = false;
             for (var nftNameList in value.tokenNames) {
               for (var nftName in nftNameList) {
                 if (nftName == tag) {
                   result = true;
                 }
               }
             }
             return !result;
           });
       }
       filterResults = {...filteredWithTags, ...filteredWithNfts};
     } else {
       filterResults = Map.from(filterResultsSearch);
     }
   }

   final sortedFilterResultsList = filterResults.values.toList().map((task) => (task)).toList()
     ..sort((a, b) => b.createTime.compareTo(a.createTime));

   Map<EthereumAddress, Task> sortedFilterResults = {};
   for (Task task in sortedFilterResultsList) {
     sortedFilterResults[task.taskAddress] = task;
   }

   filterResults = sortedFilterResults;

   notifyListeners();
 }

 Future<void> resetFilter({required Map<EthereumAddress, Task> taskList, required Map<String, NftCollection> tagsMap}) async {
   final List<String> tagsList = tagsMap.entries.map((e) => e.value.name).toList();

   filterResults.clear();

   if (tagsList.isNotEmpty) {
     late Map<EthereumAddress, Task> filteredWithTags;
     late Map<EthereumAddress, Task> filteredWithNfts;
     Map<EthereumAddress, Task> filterResultsTags = taskList;
     for (var tag in tagsList) {
       if (tag != '#') {
         filteredWithTags = Map.from(filterResultsTags)..removeWhere((key, value) => !value.tags.contains(tag));
         filteredWithNfts = Map.from(filterResultsTags)..removeWhere((key, value) => !value.tokenNames.last.contains(tag));
       }
     }
     filterResults = {...filteredWithTags, ...filteredWithNfts};
   } else {
     filterResults = Map.from(taskList);
   }

   final sortedFilterResultsList = filterResults.values.toList().map((task) => (task)).toList()
     ..sort((a, b) => b.createTime.compareTo(a.createTime));

   Map<EthereumAddress, Task> sortedFilterResults = {};
   for (Task task in sortedFilterResultsList) {
     sortedFilterResults[task.taskAddress] = task;
   }

   filterResults = sortedFilterResults;
 }

 Future<Task> getTaskData(taskAddress) async {
   TaskContract taskContract = TaskContract(address: taskAddress, client: web3client, chainId: WalletService.chainId);
   var task = await taskContract.getTaskData();
   if (task != null) {
     final double ethBalancePrecise = 0;
     BigInt weiBalanceToken = BigInt.from(0);
     if (hardhatDebug == false && hardhatLive == false) {
       weiBalanceToken = await web3GetBalanceToken(taskAddress, 'USDC');
     }
     final double ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 18);
     final double ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

     var taskObject = Task(
       nanoId: task[0].toString(),
       createTime: DateTime.fromMillisecondsSinceEpoch(task[1].toInt() * 1000),
       taskType: task[2],
       title: task[3],
       description: task[4],
       repository: task[5],
       tags: task[6],
       tagsNFT: task[7],
       tokenContracts: task[0][9],
       tokenIds: task[0][10],
       tokenAmounts: task[0][11],
       taskState: task[10],
       auditState: task[11],
       performerRating: task[12].toInt(),
       customerRating: task[13].toInt(),
       contractOwner: task[14],
       performer: task[15],
       auditInitiator: task[16],
       auditor: task[17],
       participants: task[18],
       funders: task[19],
       auditors: task[20],
       messages: task[21],
       taskAddress: taskAddress,
       loadingIndicator: false,
       tokenNames: task[0][8],
       tokenBalances: [ethBalanceToken],
       transport: (task[9] == transportAxelarAdr || task[9] == transportHyperlaneAdr) ? task[9] : '',
     );
     return taskObject;
   }
   throw (GetTaskException);
 }

 Future<Map<EthereumAddress, Task>> getTasksData(List<EthereumAddress> taskAddresses) async {
   Map<EthereumAddress, Task> tasks = {};
   final rawTasksList = await taskDataFacet.getTasksData(taskAddresses);
   late int i = 0;
   for (final task in rawTasksList) {
     List<double> tokenValues = [];
     for (final tokenBalances in task[2]) {
       for (final tokenValueRaw in tokenBalances) {
         final double ethBalancePreciseToken = tokenValueRaw.toDouble() / pow(10, 18);
         final double ethBalanceToken = (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();
         tokenValues.add(ethBalancePreciseToken);
       }
     }

     var taskObject = Task(
       nanoId: task[0][0].toString(),
       createTime: DateTime.fromMillisecondsSinceEpoch(task[0][1].toInt() * 1000),
       taskType: task[0][2],
       title: task[0][3],
       description: task[0][4],
       repository: task[0][5],
       tags: task[0][6],
       tagsNFT: task[0][7],
       tokenContracts: task[0][8],
       tokenIds: task[0][9],
       tokenAmounts: task[0][10],
       taskState: task[0][11],
       auditState: task[0][12],
       performerRating: task[0][13].toInt(),
       customerRating: task[0][14].toInt(),
       contractOwner: task[0][15],
       performer: task[0][16],
       auditInitiator: task[0][17],
       auditor: task[0][18],
       participants: task[0][19],
       funders: task[0][20],
       auditors: task[0][21],
       messages: task[0][22],
       taskAddress: taskAddresses[i],
       loadingIndicator: false,
       tokenNames: task[1],
       tokenBalances: tokenValues,
       transport: (task[0][9] == transportAxelarAdr || task[0][9] == transportHyperlaneAdr) ? task[9] : '',
     );
     tasks[taskAddresses[i]] = taskObject;
     i++;
   }

   return tasks;
 }

 Future<Map<String, Map<EthereumAddress, Task>>> getTasksDateMap(Map<EthereumAddress, Task> tasks) async {
   late Map<String, Map<EthereumAddress, Task>> tasksDateMap = {};

   for (final taskContract in tasks.keys) {
     String taskDate = DateFormat('yyyy-MM-dd').format(tasks[taskContract]!.createTime);
     if (tasksDateMap[taskDate] == null) {
       tasksDateMap[taskDate] = {};
     }
     tasksDateMap[taskDate]![taskContract] = tasks[taskContract]!;
   }

   return tasksDateMap;
 }

 Future<Map<String, Map<EthereumAddress, Task>>> getTasksWeekMap(Map<EthereumAddress, Task> tasks) async {
   late Map<String, Map<EthereumAddress, Task>> tasksDateMap = {};

   for (final taskContract in tasks.keys) {
     String taskDateWeek = tasks[taskContract]!.createTime.weekOfYear.toString();
     if (tasksDateMap[taskDateWeek] == null) {
       tasksDateMap[taskDateWeek] = {};
     }
     tasksDateMap[taskDateWeek]![taskContract] = tasks[taskContract]!;
   }

   return tasksDateMap;
 }

 Future<Map<String, Map<EthereumAddress, Task>>> getTasksMonthMap(Map<EthereumAddress, Task> tasks) async {
   late Map<String, Map<EthereumAddress, Task>> tasksDateMap = {};

   for (final taskContract in tasks.keys) {
     String taskDateMonth = DateFormat('yyyy-MM').format(tasks[taskContract]!.createTime);
     if (tasksDateMap[taskDateMonth] == null) {
       tasksDateMap[taskDateMonth] = {};
     }
     tasksDateMap[taskDateMonth]![taskContract] = tasks[taskContract]!;
   }

   return tasksDateMap;
 }

 Future<Map<String, Map<String, int>>> getTasksStats(Map<EthereumAddress, Task> tasks) async {
   List createTimeList = [];
   List taskTypeList = [];
   List tagsList = [];
   List tagsNFTList = [];
   List taskStateList = [];
   List auditStateList = [];
   List performerRatingList = [];
   List customerRatingList = [];
   List contractOwnerList = [];
   List performerList = [];
   List participantsList = [];
   List fundersList = [];
   List auditorList = [];
   List auditorsList = [];
   List tokenNamesList = [];
   List tokenValuesList = [];

   for (final task in tasks.values) {
     String taskDate = DateFormat('yyyy-MM-dd').format(task.createTime);
     createTimeList.add(taskDate);
     taskTypeList.add(task.taskType);
     tagsList.addAll(task.tags);
     tagsNFTList.addAll(task.tagsNFT);
     taskStateList.add(task.taskState);
     auditStateList.add(task.auditState);
     performerRatingList.add(task.performerRating);
     customerRatingList.add(task.customerRating);
     contractOwnerList.add(task.contractOwner);
     performerList.add(task.performer);
     participantsList.addAll(task.participants);
     fundersList.addAll(task.funders);
     auditorList.add(task.auditor);
     auditorsList.addAll(task.auditors);
     tokenValuesList.add(task.tokenBalances);
   }

   Map<String, Map<String, int>> stats = {};

   stats['statsCreateTimeListCounts'] = countOccurences(createTimeList);
   stats['statsTaskTypeListCounts'] = countOccurences(taskTypeList);
   stats['statsTagsListCounts'] = countOccurences(tagsList);
   stats['statsTagsNFTListCounts'] = countOccurences(tagsNFTList);
   stats['statsTaskStateListCounts'] = countOccurences(taskStateList);
   stats['statsAuditStateListCounts'] = countOccurences(auditStateList);
   stats['statsPerformerRatingListCounts'] = countOccurences(performerRatingList);
   stats['statsCustomerRatingListCounts'] = countOccurences(customerRatingList);
   stats['statsContractOwnerListCounts'] = countOccurences(contractOwnerList);
   stats['statsPerformerListCounts'] = countOccurences(performerList);
   stats['statsParticipantsListCounts'] = countOccurences(participantsList);
   stats['statsFundersListCounts'] = countOccurences(fundersList);
   stats['statsAuditorListCounts'] = countOccurences(auditorList);
   stats['statsAuditorsListCounts'] = countOccurences(auditorsList);
   stats['statsTokenNamesListCounts'] = countOccurences(tokenNamesList);
   stats['statsTokenValuesListCounts'] = countOccurences(tokenValuesList);
   return stats;
 }

 countOccurences(list) {
   Map<String, int> map = {};
   for (var i in list) {
     if (!map.containsKey(i.toString())) {
       map[i.toString()] = 1;
     } else {
       map[i.toString()] = map[i.toString()]! + 1;
     }
   }
   return map;
 }

 countOccurencesDate(List<DateTime> list) {
   Map<String, int> map = {};
   for (var i in list) {
     final String date = DateFormat('yyyy-MM-dd').format(i);
     if (!map.containsKey(i)) {
       map[date.toString()] = 1;
     } else {
       map[date] = map[date]! + 1;
     }
   }
   return map;
 }

 Future<Task> loadOneTask(taskAddress) async {
   if (tasks.containsKey(taskAddress)) {
     return tasks[taskAddress]!;
   } else {
     await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 500)).then((_) =>
         !contractsInitialized));

     final Map<EthereumAddress, Task> tasksTemp = await getTasksData([taskAddress]);
     tasks[taskAddress] = tasksTemp[taskAddress]!;
     refreshTask(tasks[taskAddress]!);

     return tasks[taskAddress]!;
   }
 }

 Future<void> refreshTask(Task task) async {
   if (task.performer == publicAddress) {
     if (task.performerRating != 0) {
       score = score + task.performerRating;
       scoredTaskCount++;
     }
   }

   tasksNew.remove(task.taskAddress);
   filterResults.remove(task.taskAddress);
   tasksAuditPending.remove(task.taskAddress);
   tasksAuditApplied.remove(task.taskAddress);
   tasksAuditWorkingOn.remove(task.taskAddress);
   tasksAuditComplete.remove(task.taskAddress);

   tasksCustomerSelection.remove(task.taskAddress);
   tasksCustomerProgress.remove(task.taskAddress);
   tasksCustomerComplete.remove(task.taskAddress);

   tasksPerformerParticipate.remove(task.taskAddress);
   tasksPerformerProgress.remove(task.taskAddress);
   tasksPerformerComplete.remove(task.taskAddress);

   if (task.taskState != "" &&
       (task.taskState == "agreed" || task.taskState == "progress" || task.taskState == "review" || task.taskState == "audit")) {
     if (task.contractOwner == publicAddress) {
       tasksCustomerProgress[task.taskAddress] = task;
     } else if (task.performer == publicAddress) {
       tasksPerformerProgress[task.taskAddress] = task;
     }
     if (hardhatDebug == true) {
       tasksPerformerProgress[task.taskAddress] = task;
     }
   }

   if (task.taskState != "" && task.taskState == "new") {
     if (hardhatDebug == true) {
       tasksNew[task.taskAddress] = task;
       filterResults[task.taskAddress] = task;
     }
     if (task.contractOwner == publicAddress) {
       tasksCustomerSelection[task.taskAddress] = task;} else if (task.participants.isNotEmpty) {
       var taskExist = false;
       for (var p = 0; p < task.participants.length; p++) {
         if (task.participants[p] == publicAddress) {
           taskExist = true;
         }
       }
       if (taskExist) {
         tasksPerformerParticipate[task.taskAddress] = task;
       } else {
         tasksNew[task.taskAddress] = task;
         filterResults[task.taskAddress] = task;
       }
     } else {
       tasksNew[task.taskAddress] = task;
       filterResults[task.taskAddress] = task;
     }
   }

   if (task.taskState != "" && (task.taskState == "completed" || task.taskState == "canceled")) {
     if (task.contractOwner == publicAddress) {
       tasksCustomerComplete[task.taskAddress] = task;
     } else if (task.performer == publicAddress) {
       tasksPerformerComplete[task.taskAddress] = task;
     }
     if (hardhatDebug == true) {
       tasksPerformerComplete[task.taskAddress] = task;
     }
   }

   if (task.taskState == "audit" || task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')) {
     if (task.auditState == "requested") {
       if (task.auditors.isNotEmpty) {
         var contrExist = false;
         for (var p = 0; p < task.auditors.length; p++) {
           if (task.auditors[p] == publicAddress) {
             contrExist = true;
           }
         }
         if (contrExist) {
           tasksAuditApplied[task.taskAddress] = task;
         } else {
           tasksAuditPending[task.taskAddress] = task;
         }
       } else {
         tasksAuditPending[task.taskAddress] = task;
       }
     }

     if (task.auditor == publicAddress) {
       if (task.auditState == "performing") {
         tasksAuditWorkingOn[task.taskAddress] = task;
       } else if (task.auditState == "complete" || task.auditState == "finished") {
         tasksAuditComplete[task.taskAddress] = task;
       }
     }

     if (hardhatDebug == true) {
       tasksAuditApplied[task.taskAddress] = task;
     }
   }
 }

 Future<void> refreshTasksForAccount(EthereumAddress address, String refresh) async {
   if (refresh == 'new') {
     await fetchTasksByState('new');
   } else {
     await fetchTasksCustomer(address);
     await fetchTasksPerformer(address);
     await fetchTasksByState('new');
   }
 }

 Future<void> getTaskListFullThenFetchIt() async {
   List<EthereumAddress> taskList = await getTaskListFull();
   fetchTasksBatch(taskList);
 }

 Future<void> fetchTasksBatch(List<EthereumAddress> taskList) async {
   isLoadingBackground = true;
   tasks.clear();

   filterResults.clear();
   tasksNew.clear();

   tasksAuditPending.clear();
   tasksAuditApplied.clear();
   tasksAuditWorkingOn.clear();
   tasksAuditComplete.clear();

   tasksCustomerSelection.clear();
   tasksCustomerProgress.clear();
   tasksCustomerComplete.clear();

   tasksPerformerParticipate.clear();
   tasksPerformerProgress.clear();
   tasksPerformerComplete.clear();

   pendingBalance = 0;
   pendingBalanceToken = 0;
   score = 0;
   scoredTaskCount = 0;

   tasks = await getTasksBatch(taskList.reversed.toList());

   for (Task task in tasks.values) {
     await refreshTask(task);
   }

   Map<String, Map<String, int>> totalStats = await getTasksStats(tasks);
   log.info(statsTagsListCounts);

   Map<String, Map<EthereumAddress, Task>> tasksDateMap = await getTasksDateMap(tasks);
   Map<String, Map<EthereumAddress, Task>> tasksWeekMap = await getTasksWeekMap(tasks);
   Map<String, Map<EthereumAddress, Task>> tasksMonthMap = await getTasksMonthMap(tasks);

   Map<String, Map<String, Map<String, int>>> dailyStats = {};
   for (String taskDate in tasksDateMap.keys) {
     dailyStats[taskDate] = await getTasksStats(tasksDateMap[taskDate]!);
   }

   Map<String, Map<String, Map<String, int>>> weeklyStats = {};
   for (String taskDateWeek in tasksWeekMap.keys) {
     weeklyStats[taskDateWeek] = await getTasksStats(tasksWeekMap[taskDateWeek]!);
   }

   Map<String, Map<String, Map<String, int>>> monthlyStats = {};
   for (String taskDateMonth in tasksMonthMap.keys) {
     monthlyStats[taskDateMonth] = await getTasksStats(tasksMonthMap[taskDateMonth]!);
   }

   if (score != 0) {
     myScore = score / scoredTaskCount;
   }

   isLoading = false;
   isLoadingBackground = false;
   await Future.delayed(const Duration(milliseconds: 200));
   await myBalance();
   notifyListeners();
 }

 Future<List<EthereumAddress>> getTaskContractsByState(String state) async {
   int taskCount = (await taskDataFacet.getTaskContractsCount()).toInt();
   print('Total task count: $taskCount');

   const int batchSize = 100;
   const int maxSimultaneousRequests = 10;

   List<EthereumAddress> taskContractAddresses = [];
   int offset = 0;

   while (offset < taskCount) {
     int limit = min(batchSize, taskCount - offset);
     print('Fetching tasks from offset $offset with limit $limit');

     List<Future<List<EthereumAddress>>> futures = [];
     int remainingTasks = taskCount - offset;

     for (int i = 0; i < maxSimultaneousRequests && remainingTasks > 0; i++) {
       int currentLimit = min(limit, remainingTasks);
       futures.add(taskDataFacet.getTaskContractsByStateLimit(state, BigInt.from(offset), BigInt.from(currentLimit)));
       remainingTasks -= currentLimit;
       offset += currentLimit;
     }

     List<List<EthereumAddress>> results = await Future.wait(futures);
     int retrievedCount = results.fold<int>(0, (sum, result) => sum + result.length);
     print('Retrieved $retrievedCount task contract addresses');

     taskContractAddresses.addAll(results.expand((result) => result));
     print('Total task contract addresses so far: ${taskContractAddresses.length}');
   }

   print('Finished retrieving task contract addresses. Total count: ${taskContractAddresses.length}');

   taskContractAddresses = taskContractAddresses.toSet().toList();

   return taskContractAddresses;
 }

 Future<void> fetchTasksByState(String state) async {
   isLoadingBackground = true;

   List<EthereumAddress> taskList = await getTaskContractsByState(state);

   filterResults.clear();

   if (state == "new") {
     tasksNew.clear();
     tasksCustomerSelection.clear();
     tasksPerformerParticipate.clear();
   } else if (state == "agreed" || state == "progress" || state == "review") {
     tasksCustomerProgress.clear();
     tasksPerformerProgress.clear();
   } else if (state == 'audit') {
     tasksAuditPending.clear();
     tasksAuditApplied.clear();
     tasksAuditWorkingOn.clear();
     tasksAuditComplete.clear();
   } else if (state == "completed" || state == "canceled") {
     tasksCustomerComplete.clear();
     tasksPerformerComplete.clear();
   }

   Map<EthereumAddress, Task> tasks = await getTasksBatch(taskList.reversed.toList());

   for (Task task in tasks.values) {
     await refreshTask(task);
   }

   await monitorTasks(taskList);

   isLoading = false;
   isLoadingBackground = false;
 }

 Future<void> fetchTasksCustomer(EthereumAddress publicAddress) async {
   isLoadingBackground = true;
   List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);

   filterResults.clear();

   tasksAuditPending.clear();
   tasksAuditApplied.clear();
   tasksAuditWorkingOn.clear();
   tasksAuditComplete.clear();

   tasksCustomerSelection.clear();
   tasksCustomerProgress.clear();
   tasksCustomerComplete.clear();

   Map<EthereumAddress, Task> tasks = await getTasksBatch(taskList.reversed.toList());

   for (Task task in tasks.values) {
     await refreshTask(task);
   }

   await monitorTasks(taskList);

   isLoading = false;
   isLoadingBackground = false;
   await myBalance();
   notifyListeners();
 }

 Future<void> fetchTasksPerformer(EthereumAddress publicAddress) async {
   isLoadingBackground = true;
   List<EthereumAddress> taskList = await taskDataFacet.getTaskContractsPerformer(publicAddress);

   filterResults.clear();

   tasksAuditPending.clear();
   tasksAuditApplied.clear();
   tasksAuditWorkingOn.clear();
   tasksAuditComplete.clear();

   tasksPerformerParticipate.clear();
   tasksPerformerProgress.clear();
   tasksPerformerComplete.clear();

   Map<EthereumAddress, Task> tasks = await getTasksBatch(taskList.reversed.toList());

   for (Task task in tasks.values) {
     await refreshTask(task);
   }

   await monitorTasks(taskList);

   isLoading = false;
   isLoadingBackground = false;
   await myBalance();
   notifyListeners();
 }

 Future<String> addAccountToBlacklist(EthereumAddress accountAddress) async {
   transactionStatuses['addAccountToBlacklist'] = {
     'addAccountToBlacklist': {'status': 'pending', 'txn': 'initial'}
   };
   var creds;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[liveAccount]["key"]);
   } else {
     creds = credentials;
   }
   String txn = await accountFacet.addAccountToBlacklist(accountAddress, credentials: creds);
   transactionStatuses['addAccountToBlacklist']!['addAccountToBlacklist']!['status'] = 'confirmed';
   transactionStatuses['addAccountToBlacklist']!['addAccountToBlacklist']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'addAccountToBlacklist', 'addAccountToBlacklist');
   return txn;
 }

 Future<String> removeAccountFromBlacklist(EthereumAddress accountAddress) async {
   transactionStatuses['removeAccountFromBlacklist'] = {
     'removeAccountFromBlacklist': {'status': 'pending', 'txn': 'initial'}
   };
   var creds;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[liveAccount]["key"]);
   } else {
     creds = credentials;
   }
   String txn = await accountFacet.removeAccountFromBlacklist(accountAddress, credentials: creds);
   transactionStatuses['removeAccountFromBlacklist']!['removeAccountFromBlacklist']!['status'] = 'confirmed';
   transactionStatuses['removeAccountFromBlacklist']!['removeAccountFromBlacklist']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'removeAccountFromBlacklist', 'removeAccountFromBlacklist');
   return txn;
 }

 Future<Map<String, Account>> getAccountsData({required List<EthereumAddress> requestedAccountsList, String defaultListType = ''}) async {
   final List<EthereumAddress> accountsList;
   final List accountsDataList;
   if (defaultListType == 'regular_list') {
     accountsList = await accountFacet.getAccountsList();
   } else if (defaultListType == 'black_list') {
     accountsList = await accountFacet.getAccountsBlacklist();
   } else if (defaultListType == 'raw_list') {
     accountsList = await accountFacet.getRawAccountsList();
   } else {
     accountsList = requestedAccountsList;
   }

   accountsDataList = await accountFacet.getAccountsData(accountsList);

   late Map<String, Account> myAccountsData = {};
   for (final accountData in accountsDataList) {
     myAccountsData[accountData[0].toString()] = Account(
       walletAddress: accountData[0],
       nickName: accountData[1].toString(),
       about: accountData[2].toString(),
       customerTasks: accountData[3].cast<EthereumAddress>(),
       participantTasks: accountData[4].cast<EthereumAddress>(),
       auditParticipantTasks: accountData[5].cast<EthereumAddress>(),
       customerRating: accountData[6].cast<BigInt>(),
       performerRating: accountData[7].cast<BigInt>(),
       agreedTasks: accountData[3].cast<EthereumAddress>(),
       auditAgreed: accountData[3].cast<EthereumAddress>(),
       completedTasks: accountData[3].cast<EthereumAddress>(),
     );
   }
   notifyListeners();
   return myAccountsData;
 }

 Future<List<EthereumAddress>> getTaskListFull() async {
   isLoadingBackground = true;
   List<EthereumAddress> taskList = await taskDataFacet.getTaskContracts();
   List<EthereumAddress> taskListReversed = List.from(taskList.reversed);
   isLoadingBackground = false;
   return taskListReversed;
 }

 Future<List> getTaskListCustomers(List<EthereumAddress> publicAddresses) async {
   isLoadingBackground = true;
   List taskList = await taskDataFacet.getTaskContractsCustomers(publicAddresses);
   List taskListReversed = List.from(taskList.reversed);
   isLoadingBackground = false;
   return taskListReversed;
 }

 Future<List> getTaskListPerformers(List<EthereumAddress> publicAddresses) async {
   isLoadingBackground = true;
   List taskList = await taskDataFacet.getTaskContractsPerformers(publicAddresses);
   List taskListReversed = List.from(taskList.reversed);
   isLoadingBackground = false;
   return taskListReversed;
 }

 Future<List> getTaskListCustomer(EthereumAddress publicAddress) async {
   isLoadingBackground = true;
   List taskList = await taskDataFacet.getTaskContractsCustomer(publicAddress);
   List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListPerformer(EthereumAddress publicAddress) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsPerformer(publicAddress);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<List> getTaskListByState(String state) async {
    isLoadingBackground = true;
    List taskList = await taskDataFacet.getTaskContractsByState(state);
    List taskListReversed = List.from(taskList.reversed);
    isLoadingBackground = false;
    return taskListReversed;
  }

  Future<void> approveSpend(
      EthereumAddress contractAddress, EthereumAddress publicAddress, BigInt amount, String nanoId, bool initial, String operationName) async {
    log.info('approveSpend');
    var creds;
    var senderAddress;
    if (initial) {
      transactionStatuses[nanoId] = {
        operationName: {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'}
      };
    }
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );
    late String result;
    try {
      result = await ierc20.approve(contractAddress, amount, credentials: creds, transaction: transaction);
    } on JsonRpcError catch (e) {
      errorCase(operationName, nanoId, contractAddress, e.code!);
    } on EthereumUserRejected catch (e) {
      errorCase(operationName, nanoId, contractAddress, e.code);
    } catch (e) {
      log.severe(e);
    }
    if (result.length == 66) {
      transactionStatuses[nanoId]![operationName]!['tokenApproved'] = 'approved';
    }
    log.info('result of approveSpend: $result');
    notifyListeners();
    await tellMeHasItMined(result, operationName, nanoId);
  }

  late bool isRequestApproved = false;

  Future<void> isApproved() async {
    log.info('isApproved');
    isLoadingBackground = true;
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );

    List<EthereumAddress> tokenContracts = [_contractAddress];

    for (var i = 0; i < tokenContracts.length; i++) {
      var ierc165 = IERC165(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
      Uint8List interfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
      var supportsInterface = await ierc165.supportsInterface(interfaceID);
      if (await ierc165.supportsInterface(Uint8List.fromList(interfaceID)) == true) {
        var ierc1155 = IERC1155(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
        if (await ierc1155.isApprovedForAll(senderAddress, _contractAddress) == false) {
          isRequestApproved = true;
          await ierc1155.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
          notifyListeners();
        }
      }
    }
    isLoadingBackground = false;
  }

  Future<Map<EthereumAddress, bool>> isTokenApproved(tokenContracts, amounts) async {
    isLoadingBackground = true;
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );

    Map<EthereumAddress, bool> tokenContractsApproved = {};

    for (var i = 0; i < tokenContracts.length; i++) {
      var ierc165 = IERC165(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
      Uint8List erc1155InterfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
      Uint8List erc20InterfaceID = Uint8List.fromList(hex.decode('36372b07'));
      Uint8List erc721InterfaceID = Uint8List.fromList(hex.decode('80ac58cd'));
      if (await ierc165.supportsInterface(Uint8List.fromList(erc1155InterfaceID)) == true) {
        var ierc1155 = IERC1155(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
        if (await ierc1155.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
          tokenContractsApproved[tokenContracts[i]] = false;
        } else {
          tokenContractsApproved[tokenContracts[i]] = true;
        }
      } else if (await ierc165.supportsInterface(Uint8List.fromList(erc20InterfaceID)) == true) {
        var ierc20 = IERC20(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
        if (await ierc20.allowance(senderAddress, tokenContracts[i]) >= amounts[i]) {
          tokenContractsApproved[tokenContracts[i]] = false;
        } else {
          tokenContractsApproved[tokenContracts[i]] = true;
        }
      } else if (await ierc165.supportsInterface(Uint8List.fromList(erc721InterfaceID)) == true) {
        var ierc721 = IERC721(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
        if (await ierc721.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
          tokenContractsApproved[tokenContracts[i]] = false;
        } else {
          tokenContractsApproved[tokenContracts[i]] = true;
        }
      }
    }
    isLoadingBackground = false;
    return tokenContractsApproved;
  }

  Future<void> setApprovalForAll(tokenContracts, amounts) async {
    log.info('setApprovalForAll');
    var creds;
    var senderAddress;

    transactionStatuses['setApprovalForAll'] = {
      'setApprovalForAll': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn = '';

    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }
    final transaction = Transaction(
      from: senderAddress,
    );

    Map<EthereumAddress, bool> tokenContractsApproved = {};

    try {
      for (var i = 0; i < tokenContracts.length; i++) {
        IERC165 ierc165 = IERC165(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
        Uint8List erc1555interfaceID = Uint8List.fromList(hex.decode('d9b67a26'));
        Uint8List erc20InterfaceID = Uint8List.fromList(hex.decode('36372b07'));
        Uint8List erc721InterfaceID = Uint8List.fromList(hex.decode('80ac58cd'));
        final bool supportsInterface = await ierc165.supportsInterface(erc1555interfaceID);
        if (supportsInterface == true) {
          var ierc1155 = IERC1155(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
          if (await ierc1155.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
            txn = await ierc1155.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
          }
        } else if (await ierc165.supportsInterface(erc20InterfaceID) == true) {
          var ierc20 = IERC20(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
          if (await ierc20.allowance(senderAddress, tokenContracts[i]) < amounts[i]) {
            txn = await ierc20.approve(_contractAddress, amounts[i], credentials: creds, transaction: transaction);
          }
        } else if (await ierc165.supportsInterface(erc721InterfaceID) == true) {
          var ierc721 = IERC721(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
          if (await ierc721.isApprovedForAll(senderAddress, tokenContracts[i]) == false) {
            txn = await ierc721.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
          }
        } else {
          print('interface not supported');
        }
      }
    } on JsonRpcError catch (e) {
      errorCase('setApprovalForAll', 'setApprovalForAll', contractAddress, e.code!);
    } on EthereumUserRejected catch (e) {
      errorCase('setApprovalForAll', 'setApprovalForAll', contractAddress, e.code);
    } catch (e) {
      log.severe(e);
    }
    if (txn.length == 66) {
      transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['status'] = 'confirmed';
      transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['tokenApproved'] = 'complete';
    }
    transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['txn'] = txn;
    notifyListeners();
    await tellMeHasItMined(txn, 'setApprovalForAll', 'setApprovalForAll');
  }

  String taskTokenSymbol = 'ETH';
  Future<void> createTaskContract(String title, String description, String repository, double price, String nanoId, List<String> tags,
      List<List<BigInt>> tokenIds, List<List<BigInt>> tokenAmounts, List<EthereumAddress> tokenContracts) async {
    if (taskTokenSymbol != '') {
      transactionStatuses[nanoId] = {
        'createTaskContract': {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'}
      };
      late int priceInGwei = (price * 1000000000).toInt();
      final BigInt priceInBigInt = BigInt.from(price * 1e6);
      late String txn = '';
      String taskType = 'private';

      var creds;
      var senderAddress;
      if (hardhatDebug == true) {
        creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
        senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
      } else {
        creds = credentials;
        senderAddress = publicAddress;
      }
      int historicalBlocks = 10;
      if (hardhatDebug || hardhatLive) {
        historicalBlocks = 1;
      }

      for (var i = 0; i < tokenContracts.length; i++) {
        if (tokenContracts[i] != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000')) {
          var ierc165 = IERC165(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
          Uint8List interfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
          var supportsInterface = await ierc165.supportsInterface(interfaceID);
          if (await ierc165.supportsInterface(Uint8List.fromList(interfaceID)) == true) {
            var ierc1155 = IERC1155(address: tokenContracts[i], client: web3client, chainId: WalletService.chainId);
            if (await ierc1155.isApprovedForAll(senderAddress, _contractAddress) == false) {
              final transaction = Transaction(
                from: senderAddress,
              );
              isRequestApproved = true;
              await ierc1155.setApprovalForAll(_contractAddress, true, credentials: creds, transaction: transaction);
            }
          }
        }
      }

      Map<String, dynamic> taskData = {
        "nanoId": nanoId,
        "taskType": taskType,
        "title": title,
        "description": description,
        "repository": repository,
        "tags": tags,
        "tokenContracts": tokenContracts,
        "tokenIds": tokenIds,
        "tokenAmounts": tokenAmounts
      };

      late Transaction transaction;

      if (taskTokenSymbol == 'ETH') {
        transaction = Transaction(
          from: senderAddress,
          value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );

        try {
          if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'axelar') {
            txn = await axelarFacet.createTaskContractAxelar(senderAddress, taskData, credentials: credentials, transaction: transaction);
          } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'hyperlane') {
            txn = await hyperlaneFacet.createTaskContractHyperlane(senderAddress, taskData, credentials: credentials, transaction: transaction);
          } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'layerzero') {
            txn = await layerzeroFacet.createTaskContractLayerzero(senderAddress, taskData, credentials: credentials, transaction: transaction);
       } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'wormhole') {
         txn = await wormholeFacet.createTaskContractWormhole(senderAddress, taskData, credentials: credentials, transaction: transaction);
       } else {
         txn = await taskCreateFacet.createTaskContract(senderAddress, taskData, credentials: creds, transaction: transaction);
       }
     } on JsonRpcError catch (e) {
       errorCase('createTaskContract', nanoId, contractAddress, e.code!);
     } on EthereumUserRejected catch (e) {
       errorCase('createTaskContract', nanoId, contractAddress, e.code);
     } catch (e) {
       log.severe(e);
     }
     if (txn.length == 66) {
       transactionStatuses[nanoId]!['createTaskContract']!['status'] = 'confirmed';
     }

     isLoading = false;
     transactionStatuses[nanoId]!['createTaskContract']!['tokenApproved'] = 'complete';
     transactionStatuses[nanoId]!['createTaskContract']!['txn'] = txn;
     notifyListeners();
     tellMeHasItMined(txn, 'createTaskContract', nanoId);
   }
 }

 Future<void> addTaskToBlackList(
   EthereumAddress taskAddress,
   String nanoId,
 ) async {
   if (taskTokenSymbol != '') {
     transactionStatuses[nanoId] = {
       'addTaskToBlackList': {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'}
     };
     late String txn = '';

     var creds;
     var senderAddress;
     if (hardhatDebug == true) {
       creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
       senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
     } else {
       creds = credentials;
       senderAddress = publicAddress;
     }

     try {
       txn = await taskDataFacet.addTaskToBlacklist(taskAddress, credentials: creds);
     } on JsonRpcError catch (e) {
       errorCase('addTaskToBlackList', nanoId, contractAddress, e.code!);
     } on EthereumUserRejected catch (e) {
       errorCase('addTaskToBlackList', nanoId, contractAddress, e.code);
     } catch (e) {
       log.severe(e);
     }
     if (txn.length == 66) {
       transactionStatuses[nanoId]!['addTaskToBlackList']!['status'] = 'confirmed';
     }

     isLoading = false;
     transactionStatuses[nanoId]!['addTaskToBlackList']!['tokenApproved'] = 'complete';
     transactionStatuses[nanoId]!['addTaskToBlackList']!['txn'] = txn;
     notifyListeners();
     tellMeHasItMined(txn, 'addTaskToBlackList', nanoId);
   }
 }

 Future<void> addTokens(EthereumAddress addressToSend, double price, String nanoId, {String? message}) async {
   transactionStatuses[nanoId] = {
     'addTokens': {'status': 'pending', 'tokenApproved': 'initial', 'txn': 'initial'}
   };
   message ??= 'Added $price $taskTokenSymbol to contract';
   late int priceInGwei = (price * 1000000000).toInt();
   final BigInt priceInBigInt = BigInt.from(price * 1e6);
   late String txn = '';

   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );

   if (taskTokenSymbol == 'ETH') {
     final transaction = Transaction(
       from: senderAddress,
       to: addressToSend,
       value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
     );

     txn = await web3Transaction(credentials, transaction, chainId: WalletService.chainId);
     log.info(txn);
   } else if (taskTokenSymbol == 'USDC') {
     final transaction = Transaction(
       from: senderAddress,
     );

     txn = await ierc20.transfer(addressToSend, priceInBigInt, credentials: creds, transaction: transaction);
   }
   isLoading = false;
   transactionStatuses[nanoId]!['addTokens']!['status'] = 'confirmed';
   transactionStatuses[nanoId]!['addTokens']!['tokenApproved'] = 'complete';
   transactionStatuses[nanoId]!['addTokens']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'addTokens', nanoId);
 }

 Future<void> taskParticipate(EthereumAddress contractAddress, String nanoId, {String? message, BigInt? replyTo}) async {
   transactionStatuses[nanoId] = {
     'taskParticipate': {'status': 'pending', 'txn': 'initial'}
   };
   late String txn = '';
   message ??= 'Taking this task';
   replyTo ??= BigInt.from(0);
   TaskContract taskContract = TaskContract(address: contractAddress, client: web3client, chainId: WalletService.chainId);
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );
   try {
     if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'axelar') {
       txn = await axelarFacet.taskParticipateAxelar(senderAddress, contractAddress, message, replyTo, credentials: creds, transaction: transaction);
     } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'hyperlane') {
       txn = await hyperlaneFacet.taskParticipateHyperlane(senderAddress, contractAddress, message, replyTo,
           credentials: creds, transaction: transaction);
     } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'layerzero') {
       txn = await layerzeroFacet.taskParticipateLayerzero(senderAddress, contractAddress, message, replyTo,
           credentials: creds, transaction: transaction);
     } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'wormhole') {
       txn = await wormholeFacet.taskParticipateWormhole(senderAddress, contractAddress, message, replyTo,
           credentials: creds, transaction: transaction);
     } else {
       txn = await taskContract.taskParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
     }
   } on JsonRpcError catch (e) {
     errorCase('taskParticipate', nanoId, contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('taskParticipate', nanoId, contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }
   if (txn.length == 66) {
     transactionStatuses[nanoId]!['taskParticipate']!['status'] = 'confirmed';
   }
   transactionStatuses[nanoId]!['taskParticipate']!['txn'] = txn;
   isLoading = false;
   notifyListeners();
   tellMeHasItMined(txn, 'taskParticipate', nanoId);
 }

 Future<void> taskAuditParticipate(EthereumAddress contractAddress, String nanoId, {String? message, BigInt? replyTo}) async {
   transactionStatuses[nanoId] = {
     'taskAuditParticipate': {'status': 'pending', 'txn': 'initial'}
   };
   late String txn = '';
   message ??= 'Taking task for audit';
   replyTo ??= BigInt.from(0);
   TaskContract taskContract = TaskContract(address: contractAddress, client: web3client, chainId: WalletService.chainId);
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[2]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[2]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }

   final transaction = Transaction(
     from: senderAddress,
   );

   try {
     txn = await taskContract.taskAuditParticipate(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('taskAuditParticipate', nanoId, contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('taskAuditParticipate', nanoId, contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }
   if (txn.length == 66) {
     transactionStatuses[nanoId]!['taskAuditParticipate']!['status'] = 'confirmed';
   }
   transactionStatuses[nanoId]!['taskAuditParticipate']!['txn'] = txn;
   isLoading = false;
   notifyListeners();
   tellMeHasItMined(txn, 'taskAuditParticipate', nanoId);
 }

 Future<void> taskStateChange(EthereumAddress contractAddress, EthereumAddress participantAddress, String state, String nanoId,
     {String? message, BigInt? score, BigInt? replyTo}) async {
   transactionStatuses[nanoId] = {
     'taskStateChange': {'status': 'pending', 'txn': 'initial'}
   };
   late String txn = '';
   message ??= 'Changing task status to $state';
   replyTo ??= BigInt.from(0);
   score ??= BigInt.from(5);
   TaskContract taskContract = TaskContract(address: contractAddress, client: web3client, chainId: WalletService.chainId);
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     if (state == 'agreed' || state == 'audit' || state == 'completed' || state == 'canceled') {
       creds = credentials;
       senderAddress = publicAddress;
     } else if (state == 'progress' || state == 'review') {
       creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
       senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
     } else {
       creds = credentials;
       senderAddress = publicAddress;
     }
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );

   try {
     txn = await taskContract.taskStateChange(senderAddress, participantAddress, state, message, replyTo, score,
         credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('taskStateChange', nanoId, contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('taskStateChange', nanoId, contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }

   if (txn.length == 66) {
     transactionStatuses[nanoId]!['taskStateChange']!['status'] = 'confirmed';
   }
   transactionStatuses[nanoId]!['taskStateChange']!['txn'] = txn;
   isLoading = false;
   notifyListeners();
   tellMeHasItMined(txn, 'taskStateChange', nanoId);
 }

 Future<void> taskAuditDecision(EthereumAddress contractAddress, String favour, String nanoId,
     {String? message, BigInt? score, BigInt? replyTo}) async {
   transactionStatuses[nanoId] = {
     'taskAuditDecision': {'status': 'pending', 'txn': 'initial'}
   };
   late String txn = '';
   message ??= 'Auditor decision';
   replyTo ??= BigInt.from(0);
   score ??= BigInt.from(5);
   TaskContract taskContract = TaskContract(address: contractAddress, client: web3client, chainId: WalletService.chainId);
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );

   try {
     txn = await taskContract.taskAuditDecision(senderAddress, favour, message, replyTo, score, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('taskAuditDecision', nanoId, contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('taskAuditDecision', nanoId, contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }

   if (txn.length == 66) {
     transactionStatuses[nanoId]!['taskAuditDecision']!['status'] = 'confirmed';
   }
   isLoading = false;
   transactionStatuses[nanoId]!['taskAuditDecision']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'taskAuditDecision', nanoId);
 }

 Future<void> sendChatMessage(EthereumAddress contractAddress, String nanoId, String message, String messageNanoID, {BigInt? replyTo}) async {
   transactionStatuses[nanoId] = {
     'sendChatMessage_$messageNanoID': {'status': 'pending', 'txn': 'initial'}
   };
   late String txn = '';
   replyTo ??= BigInt.from(0);
   TaskContract taskContract = TaskContract(address: contractAddress, client: web3client, chainId: WalletService.chainId);
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );

   try {
     txn = await taskContract.sendMessage(senderAddress, message, replyTo, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('sendChatMessage_$messageNanoID', nanoId, contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('sendChatMessage_$messageNanoID', nanoId, contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }

   if (txn.length == 66) {
     transactionStatuses[nanoId]!['sendChatMessage_$messageNanoID']!['status'] = 'confirmed';
   }
   isLoading = false;
   transactionStatuses[nanoId]!['sendChatMessage_$messageNanoID']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'sendChatMessage', nanoId, messageNanoID);
 }

 String destinationChain = 'Moonbase';

 Future<void> withdrawAndRate(EthereumAddress contractAddress, String nanoId, BigInt rateScore) async {
   transactionStatuses[nanoId] = {
     'withdrawAndRate': {'status': 'pending', 'txn': 'initial'}
   };
   late String txn = '';
   String chain = 'Moonbase';
   TaskContract taskContract = TaskContract(address: contractAddress, client: web3client, chainId: WalletService.chainId);
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[1]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[1]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }

   final transaction = Transaction(
     from: senderAddress,
   );
   try {
     txn = await taskContract.withdrawAndRate(contractAddress, senderAddress, chain, rateScore, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('withdrawAndRate', nanoId, contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('withdrawAndRate', nanoId, contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }
   if (txn.length == 66) {
     transactionStatuses[nanoId]!['withdrawAndRate']!['status'] = 'confirmed';
   }
   transactionStatuses[nanoId]!['withdrawAndRate']!['txn'] = txn;
   isLoading = false;
   notifyListeners();
   tellMeHasItMined(txn, 'withdrawAndRate', nanoId);
 }

 Future<void> errorCase(String actionName, String nanoId, EthereumAddress contractAddress, int code) async {
   late String status;
   if (code == 5000 || code == 4001) {
     status = 'rejected';
   } else {
     status = 'failed';
   }
   transactionStatuses[nanoId]![actionName]!['status'] = status;
   transactionStatuses[nanoId]![actionName]!['txn'] = status;
   if (actionName == 'setApprovalForAll') {
     transactionStatuses['setApprovalForAll']!['setApprovalForAll']!['tokenApproved'] = status;
   } else {
     Task task = await loadOneTask(contractAddress);
     tasks[contractAddress]!.loadingIndicator = false;
     await refreshTask(task);
     isLoading = false;
   }
   isLoadingBackground = false;
   notifyListeners();
 }

 Future<List<String>> getCreatedTokenNames() async {
   List<String> createdTokenNames = await tokenDataFacet.getCreatedTokenNames();
   return createdTokenNames;
 }

 Future<List> balanceOfBatchName(List<EthereumAddress> addresses, List<String> names) async {
   isLoadingBackground = true;
   List balanceList = await tokenDataFacet.balanceOfBatchName(addresses, names);
   isLoadingBackground = false;
   return balanceList;
 }

 Future<List> totalSupplyOfBatchName(List<String> names) async {
   isLoadingBackground = true;
   List totalSupply = await tokenDataFacet.totalSupplyOfBatchName(names);
   isLoadingBackground = false;
   return totalSupply;
 }

 Future getTokenNames(EthereumAddress address) async {
   isLoadingBackground = true;
   List accountTokenNames = await tokenDataFacet.getTokenNames(address);
   isLoadingBackground = false;
   return accountTokenNames;
 }

 Future getTokenIds(EthereumAddress address) async {
   isLoadingBackground = true;
   List accountTokenIds = await tokenDataFacet.getTokenIds(address);
   isLoadingBackground = false;
   return accountTokenIds;
 }

 Future<List> uriOfBatchName(List<String> names) async {
   isLoadingBackground = true;
   List totalSupply = await tokenDataFacet.uriOfBatchName(names);
   isLoadingBackground = false;
   return totalSupply;
 }

 Future<String> createNft(String uri, String name, bool isNF) async {
   late String txn = '';
   transactionStatuses['createNFT'] = {
     'createNFT': {'status': 'pending', 'txn': 'initial'}
   };
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );
   try {
     txn = await tokenFacet.create(uri, name, isNF, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('createNFT', 'createNFT', contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('createNFT', 'createNFT', contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }
   if (txn.length == 66) {
     transactionStatuses['createNFT']!['createNFT']!['status'] = 'confirmed';
   }
   transactionStatuses['createNFT']!['createNFT']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'createNFT', 'createNFT');
   return txn;
 }

 Future<String> mintFungibleByName(String name, List<EthereumAddress> addresses, List<BigInt> quantities) async {
   late String txn = '';
   transactionStatuses['mintFungible'] = {
     'mintFungible': {'status': 'pending', 'txn': 'initial'}
   };
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );
   try {
     txn = await tokenFacet.mintFungibleByName(name, addresses, quantities, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('mintFungible', 'mintFungible', contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('mintFungible', 'mintFungible', contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }
   if (txn.length == 66) {
     transactionStatuses['mintFungible']!['mintFungible']!['status'] = 'confirmed';
   }
   transactionStatuses['mintFungible']!['mintFungible']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'mintFungible', 'mintFungible');
   return txn;
 }

 Future<String> mintNonFungibleByName(String name, List<EthereumAddress> addresses, List<BigInt> quantities) async {
   late String txn = '';
   transactionStatuses['mintNonFungible'] = {
     'mintNonFungible': {'status': 'pending', 'txn': 'initial'}
   };
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );
   try {
     txn = await tokenFacet.mintNonFungibleByName(name, addresses, credentials: creds, transaction: transaction);
   } on JsonRpcError catch (e) {
     errorCase('mintNonFungible', 'mintNonFungible', contractAddress, e.code!);
   } on EthereumUserRejected catch (e) {
     errorCase('mintNonFungible', 'mintNonFungible', contractAddress, e.code);
   } catch (e) {
     log.severe(e);
   }
   if (txn.length == 66) {
     transactionStatuses['mintNonFungible']!['mintNonFungible']!['status'] = 'confirmed';
   }
   transactionStatuses['mintNonFungible']!['mintNonFungible']!['txn'] = txn;
   notifyListeners();
   tellMeHasItMined(txn, 'mintNonFungible', 'mintNonFungible');
   return txn;
 }

 Future<String> safeTransferFrom(EthereumAddress to, BigInt id, BigInt amount, Uint8List data) async {
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );
   String txn = await tokenFacet.safeTransferFrom(senderAddress, to, id, amount, data, credentials: creds, transaction: transaction);
   return txn;
 }

 Future<String> safeBatchTransferFrom(EthereumAddress to, List<BigInt> ids, List<BigInt> amounts, Uint8List data) async {
   var creds;
   var senderAddress;
   if (hardhatDebug == true) {
     creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
     senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
   } else {
     creds = credentials;
     senderAddress = publicAddress;
   }
   final transaction = Transaction(
     from: senderAddress,
   );
   String txn = await tokenFacet.safeBatchTransferFrom(senderAddress, to, ids, amounts, data, credentials: creds, transaction: transaction);
   return txn;
 }

 double gasPriceValue = 0;
 Future<void> getGasPrice(sourceChain, destinationChain, {tokenAddress, tokenSymbol}) async {
   const env = 'testnet';
   if (env == 'local') ;
   const String AddressZero = "0x0000000000000000000000000000000000000000";
   if (env != 'testnet') throw 'env needs to be "local" or "testnet".';

   if (tokenAddress == AddressZero && tokenSymbol == '') {
     throw 'Either tokenAddress or tokenSymbol must be set.';
   }
   String api_url = 'testnet.api.gmp.axelarscan.io';
   final params = {
     'method': 'getGasPrice',
     'destinationChain': destinationChain,
     'sourceChain': sourceChain,
   };

   if (tokenAddress != AddressZero && tokenAddress != null) {
     params['sourceTokenAddress'] = tokenAddress;
   } else {
     params['sourceTokenSymbol'] = tokenSymbol;
   }

   final uri = Uri.https(api_url, '/', params);

   var response = await http.get(uri);

   var decodedResponse = jsonDecode(response.body) as Map;

   final result = decodedResponse['result'];
   final dest = result['destination_native_token'];
   final destPrice = 1e18 * double.parse(dest['gas_price']) * (dest['token_price']['usd']);
   final gasPrice = destPrice / (result['source_token']['token_price']['usd']);
   log.info('gas price: $gasPrice');
   gasPriceValue = gasPrice;
   notifyListeners();
 }

 double transferFee = 0;
 Future<void> getTransferFee(
     {String sourceChainName = 'moonbeam', String destinationChainName = 'ethereum', String assetDenom = 'uausdc', double amountInDenom = 0}) async {
   if (amountInDenom <= 0) throw 'amountInDenom must be more than zero';
   String api_url = 'axelartest-lcd.quickapi.com';

   final params = {
     'source_chain': sourceChainName,
     'destination_chain': destinationChainName,
     'amount': '${amountInDenom.toString()}$assetDenom',
   };

   final uri = Uri.https(api_url, '/axelar/nexus/v1beta1/transfer_fee', params);

   var response = await http.get(uri);

   var decodedResponse = jsonDecode(response.body) as Map;
   log.info(decodedResponse);
   int transferFeeDenum= int.parse(decodedResponse['fee']['amount']);
    transferFee = transferFeeDenum / 1000000;

    notifyListeners();
  }

  Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  Uint8List hexToUint8List(String hex) {
    if (hex.length % 2 != 0) {
      throw 'Odd number of hex digits';
    }
    var l = hex.length ~/ 2;
    var result = Uint8List(l);
    for (var i = 0; i < l; ++i) {
      var x = int.parse(hex.substring(2 * i, 2 * (i + 1)), radix: 16);
      if (x.isNaN) {
        throw 'Expected hex string';
      }
      result[i] = x;
    }
    return result;
  }

  Future<void> myNotifyListeners() async {
    notifyListeners();
  }

  Future<void> testTaskCreation() async {
    int price = 5;
    late int priceInGwei = (price * 1000000000).toInt();
    final transaction = Transaction(
      value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
    );
    var creds;
    var senderAddress;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(hardhatAccounts[0]["key"]);
      senderAddress = EthereumAddress.fromHex(hardhatAccounts[0]["address"]);
    } else {
      creds = credentials;
      senderAddress = publicAddress;
    }

    Map<String, dynamic> taskData = {
      "nanoId": 'test',
      "taskType": 'private',
      "title": 'test job',
      "description": 'test desc',
      "tags": ['ETH'],
      "symbols": ['ETH'],
      "amounts": [BigInt.from(0)]
    };

    final transaction = Transaction(
      from: senderAddress,
      value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
    );
    try {
      if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'axelar') {
        txn = await axelarFacet.createTaskContractAxelar(senderAddress, taskData, credentials: credentials, transaction: transaction);
      } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'hyperlane') {
        txn = await hyperlaneFacet.createTaskContractHyperlane(senderAddress, taskData, credentials: credentials, transaction: transaction);
      } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'layerzero') {
        txn = await layerzeroFacet.createTaskContractLayerzero(senderAddress, taskData, credentials: credentials, transaction: transaction);
      } else if ((!_walletService.checkAllowedChainId() && WalletService.chainId != 31337) && interchainSelected == 'wormhole') {
        txn = await wormholeFacet.createTaskContractWormhole(senderAddress, taskData, credentials: credentials, transaction: transaction);
      } else {
        txn = await taskCreateFacet.createTaskContract(senderAddress, taskData, credentials: creds, transaction: transaction);
      }
    } on JsonRpcError catch (e) {
      errorCase('createTaskContract', 'createTaskContract', contractAddress, e.code!);
    } on EthereumUserRejected catch (e) {
      errorCase('createTaskContract', 'createTaskContract', contractAddress, e.code);
    } catch (e) {
      log.severe(e);
    }
    if (txn.length == 66) {
      transactionStatuses['createTaskContract']!['createTaskContract']!['status'] = 'confirmed';
    }
    transactionStatuses['createTaskContract']!['createTaskContract']!['tokenApproved'] = 'complete';
    transactionStatuses['createTaskContract']!['createTaskContract']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'createTaskContract', 'createTaskContract');
  }
}