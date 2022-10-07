import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:js/js.dart';

import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:nanoid/nanoid.dart';
import 'package:throttling/throttling.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../custom_widgets/wallet_action.dart';
import 'Factory.g.dart';
import 'IERC20.g.dart';
import 'task.dart';
import 'package:web3dart/browser.dart';
import 'package:web3dart/web3dart.dart';
import "package:universal_html/html.dart" hide Platform;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
// if (dart.library.html) 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:io' if (dart.library.html) 'dart:html';

import '../wallet/ethereum_transaction_tester.dart';
import '../wallet/main.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// import 'dart:html' hide Platform;

@JS()
@anonymous
class JSrawRequestParams {
  external String get chainId;

  // Must have an unnamed factory constructor with named arguments.
  external factory JSrawRequestParams({String chainId});
}

class TasksServices extends ChangeNotifier {
  List<Task> tasks = [];
  List<Task> filterResults = [];
  List<Task> tasksNew = [];
  List<Task> tasksOwner = [];
  List<Task> tasksWithMyParticipation = [];
  List<Task> tasksPerformer = [];
  List<Task> tasksAgreedSubmitter = [];

  List<Task> tasksProgressSubmitter = [];
  List<Task> tasksReviewSubmitter = [];
  List<Task> tasksDoneSubmitter = [];
  List<Task> tasksDonePerformer = [];

  Map<String, Map<String, Map<String, String>>> transactionStatuses = {};

  var credentials;
  EthereumAddress? publicAddress;
  var transactionTester;

  var walletConnectState;
  bool walletConnectConnected = false;
  String walletConnectUri = '';
  String walletConnectSessionUri = '';
  // bool walletConnectActionApproved = false;
  var eth;
  String lastTxn = '';

  String platform = 'mobile';
  final String _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
  final String _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';

  final int _chainId = 1287;
  final int _chainIdRopsten = 3;
  bool isLoading = true;
  bool isLoadingBackground = false;
  final bool _walletconnect = true;

  late Web3Client _web3client;

  bool isDeviceConnected = false;

  late IERC20 ierc20;

  TasksServices() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        platform = 'mobile';
      } else if (Platform.isLinux) {
        platform = 'linux';
      }
    } catch (e) {
      platform = 'web';
    }
    print("platform:" + platform);
    init();
  }

  bool initComplete = false;
  Future<void> init() async {
    await getTransferFee(
        sourceChainName: 'moonbeam',
        destinationChainName: 'ethereum',
        assetDenom: 'uausdc',
        amountInDenom: 100000);
    isDeviceConnected = false;

    if (platform != 'web') {
      final StreamSubscription subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
        }
      });
    } else {
      // print('Client is listening: ${await client.isListeningForNetwork()}');

      // final message = Uint8List.fromList(utf8.encode('Hello from web3dart'));
      // final signature = await credentials.signPersonalMessage(message);
      // print('Signature: ${base64.encode(signature)}');
    }

    if (platform != 'web') {
      if (transactionTester == null) {
        transactionTester = EthereumTransactionTester();
      }
      await transactionTester?.initSession();
      await transactionTester?.removeSession();
    }
    _web3client = Web3Client(
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
    await getABI();
    await getDeployedContract();

    if (platform == 'web') {}

    initComplete = true;
  }

  late ContractAbi _abiCode;

  late num totalTaskLen = 0;
  int taskLoaded = 0;
  late EthereumAddress _contractAddress;
  late EthereumAddress _contractAddressRopsten;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/Factory.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'Factory');
    _contractAddress = EthereumAddress.fromHex(
        jsonABI["networks"][_chainId.toString()]["address"]);
    _contractAddressRopsten = EthereumAddress.fromHex(
        jsonABI["networks"][_chainIdRopsten.toString()]["address"]);
  }

  int chainID = 0;
  bool validChainID = false;

  Future<void> connectWallet() async {
    if (platform != 'web') {
      print('not web');
      connectWalletWC();
    } else {
      connectWalletMM();
    }
  }

  Future<void> connectWalletWC() async {
    if (transactionTester != null) {
      var connector = await transactionTester.initWalletConnect();

      if (walletConnectConnected == false) {
        print("disconnected");
        walletConnectUri = '';
        walletConnectSessionUri = '';
      }
      // Subscribe to events
      connector.on('connect', (session) {
        print(session);
        walletConnectState = TransactionState.connected;
        walletConnectConnected = true;
        () async {
          credentials = await transactionTester?.getCredentials();
          publicAddress = await transactionTester?.getPublicAddress(session);
          _creds = credentials;
          ownAddress = publicAddress;
          fetchTasks();

          myBalance();
          isLoading = true;

          chainID = session.chainId;
          if (chainID == 1287) {
            validChainID = true;
          } else {
            validChainID = false;
          }
        }();
        notifyListeners();
      });
      connector.on('session_request', (payload) {
        print(payload);
      });
      connector.on('session_update', (payload) {
        print(payload);
        if (payload.approved == true) {
          // walletConnectActionApproved = true;
          // notifyListeners();
        }
      });
      connector.on('disconnect', (session) {
        print(session);
        walletConnectState = TransactionState.disconnected;
        walletConnectConnected = false;
        walletConnectUri = '';
        walletConnectSessionUri = '';

        ownAddress = null;
        ethBalance = 0;
        ethBalanceToken = 0;
        pendingBalance = 0;
        pendingBalanceToken = 0;
        notifyListeners();
      });
      final SessionStatus? session = await transactionTester?.connect(
        onDisplayUri: (uri) => {
          walletConnectSessionUri = uri.split("?").first,
          platform == 'mobile' ? launchURL(uri) : walletConnectUri = uri,
          notifyListeners()
        },
      );

      if (session == null) {
        print('Unable to connect');
        walletConnectState = TransactionState.failed;
      } else if (walletConnectConnected == true) {
        credentials = await transactionTester?.getCredentials();
        publicAddress = await transactionTester?.getPublicAddress(session);
      } else {
        walletConnectState = TransactionState.failed;
      }
    } else {
      print("not initialized");
    }
  }

  Future<void> connectWalletMM() async {
    if (window.ethereum != null) {
      final eth = window.ethereum;

      if (eth == null) {
        print('MetaMask is not available');
        return;
      }
      var ethRPC = eth.asRpcService();

      final client = Web3Client.custom(ethRPC);
      final credentials = await eth.requestAccount();
      _creds = credentials;

      publicAddress = _creds.address;

      final chainIDHex = await eth.rawRequest('eth_chainId');
      int chainID = int.parse(chainIDHex);

      if (chainID == 1287) {
        validChainID = true;
      } else {
        print('invalid chainID ${chainID}');

        await eth.rawRequest('wallet_switchEthereumChain',
            params: [JSrawRequestParams(chainId: '0x507')]);
        final chainIDHex = await eth.rawRequest('eth_chainId');
        chainID = int.parse(chainIDHex);
        if (chainID == 1287) {
          validChainID = true;
        } else {
          validChainID = false;
        }
      }
      // print(chainID);

      //chainID = 1287;
      walletConnectConnected = true;
      // validChainID = true;

      // print('Using ${_creds.address}');

      ownAddress = publicAddress;
      fetchTasks();

      myBalance();
      notifyListeners();
      // final client = Web3Client.custom(eth.asRpcService());
      // final credentials = await eth.requestAccount();
      // _creds = credentials;

      // Subscribe to events
      // eth.on('connect', (session) {
      //   print(session);
      //   // walletConnectState = TransactionState.connected;
      //   // walletConnectConnected = true;
      //   // () async {
      //   //   credentials = await transactionTester?.getCredentials();
      //   //   publicAddress = await transactionTester?.getPublicAddress(session);
      //   //   _creds = credentials;
      //   //   ownAddress = publicAddress;
      //   //   fetchTasks();

      //   //   myBalance();
      //   //   isLoading = true;

      //   //   chainID = session.chainId;
      //   //   if (chainID == 1287) {
      //   //     validChainID = true;
      //   //   } else {
      //   //     validChainID = false;
      //   //   }
      //   // }();
      //   notifyListeners();
      // });
      // connector.on('session_request', (payload) {
      //   print(payload);
      // });
      // connector.on('session_update', (payload) {
      //   print(payload);
      //   if (payload.approved == true) {
      //     // walletConnectActionApproved = true;
      //     // notifyListeners();
      //   }
      // });
      // connector.on('disconnect', (session) {
      //   print(session);
      //   walletConnectState = TransactionState.disconnected;
      //   walletConnectConnected = false;
      //   walletConnectUri = '';
      //   walletConnectSessionUri = '';

      //   ownAddress = null;
      //   ethBalance = 0;
      //   ethBalanceToken = 0;
      //   pendingBalance = 0;
      //   pendingBalanceToken = 0;
      //   notifyListeners();
      // });
      // final SessionStatus? session = await transactionTester?.connect(
      //   onDisplayUri: (uri) => {
      //     walletConnectSessionUri = uri.split("?").first,
      //     platform == 'mobile' ? launchURL(uri) : walletConnectUri = uri,
      //     notifyListeners()
      //   },
      // );

      // if (session == null) {
      //   print('Unable to connect');
      //   walletConnectState = TransactionState.failed;
      // } else if (walletConnectConnected == true) {
      //   credentials = await transactionTester?.getCredentials();
      //   publicAddress = await transactionTester?.getPublicAddress(session);
      // } else {
      //   walletConnectState = TransactionState.failed;
      // }
    } else {
      print("eth not initialized");
    }
  }

  Future<List<dynamic>> web3Call({
    EthereumAddress? sender,
    required DeployedContract contract,
    required ContractFunction function,
    required List<dynamic> params,
    BlockNum? atBlock,
  }) {
    var response;
    try {
      response = _web3client.call(
          sender: sender,
          contract: contract,
          function: function,
          params: params,
          atBlock: atBlock);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<String> web3Transaction(Credentials cred, Transaction transaction,
      {int? chainId = 1, bool fetchChainIdFromNetworkId = false}) async {
    var response;
    try {
      response = _web3client.sendTransaction(cred, transaction,
          chainId: chainId,
          fetchChainIdFromNetworkId: fetchChainIdFromNetworkId);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<TransactionReceipt?> web3GetTransactionReceipt(String hash) async {
    var response;
    try {
      response = _web3client.getTransactionReceipt(hash);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<EtherAmount> web3GetBalance(EthereumAddress address,
      {BlockNum? atBlock}) async {
    var response;
    try {
      response = _web3client.getBalance(address, atBlock: atBlock);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  Future<BigInt> web3GetBalanceToken(EthereumAddress address, String symbol,
      {BlockNum? atBlock}) async {
    var response;
    try {
      response = await ierc20.balanceOf(address);
    } catch (e) {
      print(e);
    } finally {
      return response;
    }
  }

  late dynamic _creds;
  EthereumAddress? ownAddress;
  double? ethBalance = 0;
  double? ethBalanceToken = 0;
  double? pendingBalance = 0;
  double? pendingBalanceToken = 0;
  int score = 0;
  int scoredTaskCount = 0;
  double myScore = 0.0;

  late DeployedContract _deployedContract;
  late ContractFunction _createTask;
  late ContractFunction _deleteTask;
  late ContractFunction _tasks;
  late ContractFunction _taskCount;
  late ContractFunction _changeTaskStatus;
  late ContractFunction _taskParticipation;
  late ContractFunction _withdraw;
  late ContractFunction _withdrawToChain;
  late ContractFunction _getBalance;
  late ContractFunction _rateTask;
  late Throttling thr;
  late String searchKeyword = '';

  Future<void> listenToEvents() async {
    final JobContractCreated = _deployedContract.event('JobContractCreated');
    final subscription = _web3client
        .events(FilterOptions.events(
            contract: _deployedContract, event: JobContractCreated))
        .listen((event) {
      final decoded =
          JobContractCreated.decodeResults(event.topics!, event.data!);
      //
      print('event fired');
    });
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createTask = _deployedContract.function('createJobContract');
    // _deleteTask = _deployedContract.function('deleteTask');
    _tasks = _deployedContract.function('getJobInfo');
    _taskCount = _deployedContract.function('countNew');
    _changeTaskStatus = _deployedContract.function('jobStateChange');
    _taskParticipation = _deployedContract.function('jobParticipate');
    _withdraw = _deployedContract.function('transferToaddress');
    _getBalance = _deployedContract.function('getBalance');
    _withdrawToChain = _deployedContract.function('transferToaddressChain2');
    // _rateTask = _deployedContract.function('jobRating');

    //aUSDC contract
    EthereumAddress tokenContractAddress =
        EthereumAddress.fromHex('0xD1633F7Fb3d716643125d6415d4177bC36b7186b');

    ierc20 = IERC20(
        address: tokenContractAddress, client: _web3client, chainId: _chainId);

    thr = Throttling(duration: const Duration(seconds: 20));
    thr.throttle(() {
      fetchTasks();
    });
    await myBalance();
    await monitorEvents();
    await listenToEvents();
  }

  Future<void> myBalance() async {
    if (ownAddress != null) {
      final EtherAmount balance = await web3GetBalance(ownAddress!);
      final BigInt weiBalance = balance.getInWei;
      final ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
      ethBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();

      final BigInt weiBalanceToken =
          await web3GetBalanceToken(ownAddress!, 'aUSDC');
      final ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 6);
      ethBalanceToken =
          (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();
      notifyListeners();
    }
  }

  // EthereumAddress lastJobContract;
  Future<void> monitorEvents() async {
    final factory = Factory(
        address: _contractAddress, client: _web3client, chainId: _chainId);
    // listen for the Transfer event when it's emitted by the contract above
    final subscription = factory.oneEventForAllEvents().listen((event) async {
      print('received event ${event.contractAdr} index ${event.index}');
      thr.throttle(() {
        fetchTasks();
      });
    });
    final subscription2 =
        factory.jobContractCreatedEvents().listen((event) async {
      print(
          'received event ${event.title} jobAddress ${event.jobAddress} description ${event.description}');
      if (event.jobOwner == ownAddress) {
        transactionStatuses[event.nanoId]!['task'] = {
          'jobAddress': event.jobAddress.toString()
        };
      }
    });

    final subscription3 = ierc20.approvalEvents().listen((event) async {
      print(
          'received event approvalEvents ${event.owner} spender ${event.spender} value ${event.value}');
      if (event.owner == ownAddress) {
        print(event.owner);
      }
    });
  }

  Future tellMeHasItMined(
      String hash, String _taskAction, String _nanoId) async {
    if (hash.length == 66) {
      TransactionReceipt? transactionReceipt =
          await web3GetTransactionReceipt(hash);
      while (transactionReceipt == null) {
        Future.delayed(const Duration(milliseconds: 1000));
        transactionReceipt = await web3GetTransactionReceipt(hash);
      }

      if (transactionReceipt.status == true) {
        transactionStatuses[_nanoId]![_taskAction]!['status'] = 'minted';
        transactionStatuses[_nanoId]![_taskAction]!['txn'] = hash;
        notifyListeners();
        print('tell me has it mined');
        thr.throttle(() {
          fetchTasks();
        });
      }
      await myBalance();
    } else {
      isLoadingBackground = false;
    }
  }

  Future<void> runFilter(String enteredKeyword) async {
    filterResults.clear();
    print(enteredKeyword);
    searchKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all tasks
      filterResults = tasksNew.toList();
    } else {
      for (int i = 0; i < tasksNew.length; i++) {
        if (tasksNew
            .elementAt(i)
            .title
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          filterResults.add(tasksNew.elementAt(i));
        }
      }
    }
    // Refresh the UI
    notifyListeners();
  }

  Future<void> resetFilter() async {
    filterResults.clear();
    filterResults = tasksNew.toList();
  }

  late bool loopRunning = false;
  late bool stopLoopRunning = false;

  Future<void> fetchTasks() async {
    isLoadingBackground = true;
    notifyListeners();
    List totalTaskList = await web3Call(
      contract: _deployedContract,
      function: _taskCount,
      params: [],
    );

    totalTaskLen = totalTaskList[0].toInt();
    tasks.clear();

    if (loopRunning) {
      stopLoopRunning = true;
    }

    if (loopRunning == false) {
      loopRunning = true;
      for (var i = 0; i < totalTaskLen; i++) {
        if (stopLoopRunning) {
          tasks.clear();
          stopLoopRunning = false;
          loopRunning = false;
          fetchTasks();
          break;
        }
        var task;
        var value;
        double ethBalancePrecise = 0;
        double ethBalanceToken = 0;
        task = await web3Call(
            contract: _deployedContract,
            function: _tasks,
            params: [BigInt.from(i)]);
        if (task != null) {
          value = await web3Call(
              contract: _deployedContract,
              function: _getBalance,
              params: [BigInt.from(task[6].toInt())]);
          final BigInt weiBalance = value[0];
          ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
          final BigInt weiBalanceToken =
              await web3GetBalanceToken(task[2], task[10]);
          final ethBalancePreciseToken =
              weiBalanceToken.toDouble() / pow(10, 6);
          ethBalanceToken =
              (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

          var taskObject = Task(
            title: task[0],
            description: task[7],
            contractOwner: task[4],
            contractAddress: task[2],
            jobState: task[1],
            contributorsCount: task[8].length,
            contributors: task[8],
            participiant: task[9],
            justLoaded: true,
            createdTime:
                DateTime.fromMillisecondsSinceEpoch(task[5].toInt() * 1000),
            contractValue: ethBalancePrecise,
            contractValueToken: ethBalanceToken,
            nanoId: task[11],
            score: 0,
            // score: task[12]
          );

          taskLoaded = task[6].toInt() +
              1; // this count we need to show the loading process. does not affect anything else

          notifyListeners();
          if (task[1] != "") {
            tasks.add(taskObject);
          }
        }
      }

      if (loopRunning) {
        filterResults.clear();
        tasksNew.clear();
        tasksOwner.clear();
        tasksWithMyParticipation.clear();
        tasksPerformer.clear();
        tasksAgreedSubmitter.clear();
        tasksReviewSubmitter.clear();
        tasksDonePerformer.clear();
        tasksDoneSubmitter.clear();
        tasksProgressSubmitter.clear();

        pendingBalance = 0;
        pendingBalanceToken = 0;
        score = 0;
        scoredTaskCount = 0;

        for (var k = 0; k < tasks.length; k++) {
          final task = tasks[k];

          if (task.participiant == ownAddress) {
            // Calculate Pending among:
            if ((task.contractValue != 0 || task.contractValueToken != 0)) {
              if (task.jobState == "agreed" ||
                  task.jobState == "progress" ||
                  task.jobState == "review" ||
                  task.jobState == "completed") {
                pendingBalance = pendingBalance! + task.contractValue;
                pendingBalanceToken =
                    pendingBalanceToken! + task.contractValueToken;
              }
            }
            // add all scored Task for calculation:
            if (task.score != 0) {
              score = score! + task.score;
              scoredTaskCount++;
            }
          }

          if (task.jobState != "" && task.jobState == "new") {
            if (task.contractOwner == ownAddress) {
              tasksOwner.add(task);
            } else if (task.contributors.length != 0) {
              var taskExist = false;
              for (var p = 0; p < task.contributors.length; p++) {
                if (task.contributors[p] == ownAddress) {
                  taskExist = true;
                }
              }
              if (taskExist) {
                tasksWithMyParticipation.add(task);
              } else {
                tasksNew.add(task);
                filterResults.add(task);
              }
            } else {
              tasksNew.add(task);
              filterResults.add(task);
            }
          }

          if (task.jobState != "" && task.jobState == "agreed") {
            if (task.contractOwner == ownAddress) {
              tasksAgreedSubmitter.add(task);
            } else if (task.participiant == ownAddress) {
              tasksPerformer.add(task);
            }
          }

          if (task.jobState != "" && task.jobState == "progress") {
            if (task.contractOwner == ownAddress) {
              tasksProgressSubmitter.add(task);
            } else if (task.participiant == ownAddress) {
              tasksPerformer.add(task);
            }
          }

          if (task.jobState != "" && task.jobState == "review") {
            if (task.contractOwner == ownAddress) {
              tasksReviewSubmitter.add(task);
            } else if (task.participiant == ownAddress) {
              tasksPerformer.add(task);
            }
          }
          if (task.jobState != "" &&
              (task.jobState == "completed" || task.jobState == "canceled")) {
            if (task.contractOwner == ownAddress) {
              tasksDoneSubmitter.add(task);
            } else if (task.participiant == ownAddress) {
              tasksDonePerformer.add(task);
            }
          }
        }

        // Final Score Calculation
        if (score != 0) {
          myScore = score / scoredTaskCount;
        }

        isLoading = false;
        isLoadingBackground = false;
        await myBalance();
        notifyListeners();
        runFilter(searchKeyword); // reset search bar
      }
      loopRunning = false;
    }
  }

  Future<void> approveSpend(
      EthereumAddress _contractAddress,
      EthereumAddress ownAddress,
      String symbol,
      BigInt amount,
      String nanoId) async {
    final transaction = Transaction(
      from: ownAddress,
    );
    final result = await ierc20.approve(_contractAddress, amount,
        credentials: _creds, transaction: transaction);
    print('result of approveSpend: ' + result);
    transactionStatuses[nanoId]!['addTask']!['tokenApproved'] = 'approved';
    notifyListeners();
    await tellMeHasItMined(result, 'addTask', nanoId);
    print('mined');
  }

  String taskTokenSymbol = 'ETH';
  Future<void> addTask(
      String title, String description, double price, String nanoId) async {
    print(price);
    // taskTokenSymbol = "aUSDC";
    if (taskTokenSymbol != '') {
      transactionStatuses[nanoId] = {
        'addTask': {
          'status': 'pending',
          'tokenApproved': 'initial',
          'txn': 'initial'
        } //
      };
      late int priceInGwei = (price * 1000000000).toInt();
      final BigInt priceInBigInt = BigInt.from(price * 1e6);
      late String txn;

      if (taskTokenSymbol == 'ETH') {
        txn = await web3Transaction(
            _creds,
            Transaction.callContract(
              from: ownAddress,
              contract: _deployedContract,
              function: _createTask,
              parameters: [
                nanoId,
                title,
                description,
                taskTokenSymbol,
                priceInBigInt,
              ],
              value: EtherAmount.fromUnitAndValue(
                  EtherUnit.gwei, priceInGwei.toInt()),
            ),
            chainId: _chainId);
      } else if (taskTokenSymbol == 'aUSDC') {
        await approveSpend(_contractAddress, ownAddress!, taskTokenSymbol,
            priceInBigInt, nanoId);
        txn = await web3Transaction(
            _creds,
            Transaction.callContract(
              from: ownAddress,
              contract: _deployedContract,
              function: _createTask,
              parameters: [
                nanoId,
                title,
                description,
                taskTokenSymbol,
                priceInBigInt
              ],
            ),
            chainId: _chainId);
        print(txn);
      }
      isLoading = false;
      // isLoadingBackground = true;
      lastTxn = txn;
      transactionStatuses[nanoId]!['addTask']!['status'] = 'confirmed';
      transactionStatuses[nanoId]!['addTask']!['tokenApproved'] = 'complete';
      transactionStatuses[nanoId]!['addTask']!['txn'] = txn;

      tellMeHasItMined(txn, 'addTask', nanoId);
      notifyListeners();
    }
  }

  Future<void> addTokens(
      EthereumAddress addressToSend, double price, String nanoId) async {
    print(price);
    transactionStatuses[nanoId] = {
      'addTokens': {
        'status': 'pending',
        'tokenApproved': 'initial',
        'txn': 'initial'
      }
    };
    late int priceInGwei = (price * 1000000000).toInt();
    final BigInt priceInBigInt = BigInt.from(price * 1e6);
    late String txn;

    if (taskTokenSymbol == 'ETH') {
      final transaction = Transaction(
        from: ownAddress,
        to: addressToSend,
        value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
      );

      txn = await web3Transaction(_creds, transaction, chainId: _chainId);
      print(txn);
    } else if (taskTokenSymbol == 'aUSDC') {
      final transaction = Transaction(
        from: ownAddress,
      );
      txn = await ierc20.transfer(addressToSend, priceInBigInt,
          credentials: _creds, transaction: transaction);
    }
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['addTokens']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['addTokens']!['tokenApproved'] = 'complete';
    transactionStatuses[nanoId]!['addTokens']!['txn'] = txn;

    tellMeHasItMined(txn, 'addTokens', nanoId);
    notifyListeners();
  }

  Future<void> taskParticipation(
      EthereumAddress contractAddress, String nanoId) async {
    transactionStatuses[nanoId] = {
      'taskParticipation': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    txn = await web3Transaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _taskParticipation,
          parameters: [contractAddress],
        ),
        chainId: _chainId);
    isLoading = false;
    // isLoadingBackground = true;
    // lastTxn = txn;
    transactionStatuses[nanoId]!['taskParticipation']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskParticipation']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskParticipation', nanoId);
  }

  Future<void> changeTaskStatus(EthereumAddress contractAddress,
      EthereumAddress participiantAddress, String state, String nanoId) async {
    transactionStatuses[nanoId] = {
      'changeTaskStatus': {'status': 'pending', 'txn': 'initial'}
    };
    // lastTxn = 'pending';
    late String txn;
    txn = await web3Transaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _changeTaskStatus,
          parameters: [contractAddress, participiantAddress, state],
        ),
        chainId: _chainId);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['changeTaskStatus']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['changeTaskStatus']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'changeTaskStatus', nanoId);
  }

  Future<void> withdraw(EthereumAddress contractAddress, String nanoId) async {
    late String txn;
    transactionStatuses[nanoId] = {
      'withdraw': {'status': 'pending', 'txn': 'initial'}
    };
    txn = await web3Transaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _withdraw,
          parameters: [contractAddress, ownAddress],
        ),
        chainId: _chainId);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['withdraw']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['withdraw']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'withdraw', nanoId);
  }

  String destinationChain = 'Moonbase';
  Future<void> withdrawToChain(
      EthereumAddress contractAddress, String nanoId) async {
    transactionStatuses[nanoId] = {
      'withdrawToChain': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    late int priceInGwei = (80000000 * gasPriceValue).toInt();
    print("gasPriceValue");
    print(gasPriceValue);
    EtherAmount value =
        EtherAmount.fromUnitAndValue(EtherUnit.wei, priceInGwei);
    print("value");
    print(value);
    print("destinationChain: " + destinationChain);
    txn = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _withdrawToChain,
          parameters: [
            contractAddress,
            _contractAddressRopsten,
            destinationChain
          ],
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, priceInGwei),
        ),
        chainId: _chainId);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['withdrawToChain']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['withdrawToChain']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'withdrawToChain', nanoId);
  }

  Future<void> rateTask(
      EthereumAddress contractAddress, double rateScore, String nanoId) async {
    transactionStatuses[nanoId] = {
      'rateTask': {'status': 'pending', 'txn': 'initial'}
    };
    // lastTxn = 'pending';
    late String txn;
    txn = await web3Transaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _rateTask,
          parameters: [contractAddress, rateScore],
        ),
        chainId: _chainId);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['rateTask']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['rateTask']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'rateTask', nanoId);
  }

  double gasPriceValue = 0;
  Future<void> getGasPrice(sourceChain, destinationChain,
      {tokenAddress, tokenSymbol}) async {
    final env = 'testnet';
    if (env == 'local') ;
    final String AddressZero = "0x0000000000000000000000000000000000000000";
    if (env != 'testnet') throw 'env needs to be "local" or "testnet".';

    if (tokenAddress == AddressZero && tokenSymbol == '')
      throw 'Either tokenAddress or tokenSymbol must be set.';
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
    final destPrice =
        1e18 * double.parse(dest['gas_price']) * (dest['token_price']['usd']);
    final gasPrice = destPrice / (result['source_token']['token_price']['usd']);
    print('gas price:');
    print(gasPrice);
    gasPriceValue = gasPrice;
    notifyListeners();
  }

  /**
   * Gest the transfer fee for a given transaction
   * ported to Dart from https://github.com/axelarnetwork/axelarjs-sdk/blob/main/src/libs/AxelarQueryAPI.ts#L85
   * example testnet query: "https://axelartest-lcd.quickapi.com/axelar/nexus/v1beta1/transfer_fee?source_chain=ethereum&destination_chain=terra&amount=100000000uusd"
   * @param sourceChainName
   * @param destinationChainName
   * @param assetDenom
   * @param amountInDenom
   * @returns
   */
  double transferFee = 0;
  Future<void> getTransferFee(
      {String sourceChainName = 'moonbeam',
      String destinationChainName = 'ethereum',
      String assetDenom = 'uausdc',
      double amountInDenom = 0}) async {
    if (amountInDenom <= 0) throw 'amountInDenom must be more than zero';
    String api_url = 'axelartest-lcd.quickapi.com';

    final params = {
      'source_chain': sourceChainName,
      'destination_chain': destinationChainName,
      'amount': '${amountInDenom.toString()}${assetDenom}',
    };

    final uri =
        Uri.https(api_url, '/axelar/nexus/v1beta1/transfer_fee', params);

    var response = await http.get(uri);

    var decodedResponse = jsonDecode(response.body) as Map;
    print(decodedResponse);
    int transferFeeDenum = int.parse(decodedResponse['fee']['amount']);
    transferFee = transferFeeDenum / 1000000;

    notifyListeners();
  }

  Future<void> myNotifyListeners() async {
    notifyListeners();
  }
}
