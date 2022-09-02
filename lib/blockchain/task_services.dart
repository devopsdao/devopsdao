import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:js';

import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:throttling/throttling.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'Factory.g.dart';
import 'task.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../wallet/ethereum_transaction_tester.dart';
import '../wallet/main.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// enum TransactionState {
//   disconnected,
//   connecting,
//   connected,
//   connectionFailed,
//   transferring,
//   success,
//   failed,
// }

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
  var credentials;
  EthereumAddress? publicAddress;
  var transactionTester;

  var walletConnectState;
  bool walletConnectConnected = false;
  String walletConnectUri = '';
  String walletConnectSessionUri = '';
  // bool walletConnectActionApproved = false;
  String lastTxn = '';

  // final String _rpcUrl =
  // Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  // final String _wsUrl =
  // Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';

  // final String _rpcUrl = Platform.isAndroid
  //     ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
  //     : 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
  // final String _wsUrl = Platform.isAndroid
  //     ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
  //     : 'wss://ropsten.infura.io/ws/v3/9aa3d95b3bc440fa88ea12eaa4456161';

  String platform = 'mobile';
  final String _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
  final String _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';
  // final String _rpcUrl = Platform.isAndroid
  //     ? 'https://rpc.api.moonbase.moonbeam.network'
  //     : 'https://rpc.api.moonbase.moonbeam.network';
  // final String _wsUrl = Platform.isAndroid
  //     ? 'wss://wss.api.moonbase.moonbeam.network'
  //     : 'wss://wss.api.moonbase.moonbeam.network';
  final int _chainId = 1287;
  bool isLoading = true;
  bool isLoadingBackground = false;
  final bool _walletconnect = true;

  // final String _privatekey =
  //     'f9a150364de5359a07b91b1af8ac1c75ad9e084d7bd2c0e09beb5df7fa6cafa0'; //m's ropsten key
  final String _privatekey =
      'f819f5453032c5166a3a459506058cb46c37d6eca694dafa76f2b6fe33d430e8';
  late Web3Client _web3client;

  bool isDeviceConnected = false;

  // faucet m's key:
  // f9a150364de5359a07b91b1af8ac1c75ad9e084d7bd2c0e09beb5df7fa6cafa0
// r's key
// f819f5453032c5166a3a459506058cb46c37d6eca694dafa76f2b6fe33d430e8
  // internal key's
  // 29e52385859d9a1cd067552dcdb4c1734853343cf83dfbf31d76e1871cf1d7ec - second user
  // e1f0d3b368c3aaf8fde11e8da9a6ab2162fbd08f384145b480f16ab9cd746941 - second user
  // 01fe73c191d0433fd7f64390a02469f30044a40a48a548591b630952e084884f

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

  Future<void> init() async {
    isDeviceConnected = false;

    final StreamSubscription subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
      }
    });
    if (transactionTester == null) {
      transactionTester = EthereumTransactionTester();
    }
    await transactionTester?.initSession();
    await transactionTester?.removeSession();
    _web3client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    // await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;

  late num totalTaskLen = 0;
  int? taskLoaded;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/Factory.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'Factory');
    // _contractAddress = EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    _contractAddress = EthereumAddress.fromHex(
        jsonABI["networks"][_chainId.toString()]["address"]);
  }

  // var session;
  // // _transactionTester?.initWalletConnect();
  // Future<void> connectWallet() async {
  //   TransactionTester? _transactionTester = EthereumTransactionTester();
  //   await _transactionTester.initWalletConnect();
  //   _transactionTester.disconnect();
  //   session = _transactionTester.connect(
  //     onDisplayUri: (uri) => {print(uri), walletConnectUri = uri},
  //   );
  //   if (session == null) {
  //     print('Unable to connect');
  //     // setState(() => _state = TransactionState.failed);
  //     walletConnectState = TransactionState.failed;
  //   } else {
  //     walletConnectState = TransactionState.connected;
  //   }
  // }

  Future<void> connectWallet4() async {
    // if (transactionTester == null) {
    //   transactionTester = EthereumTransactionTester();
    // }

    var connector = await transactionTester.initWalletConnect();

    //if (tasksServices.walletConnectState == null ||
    // tasksServices.walletConnectState == TransactionState.disconnected) {
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
      }();
      notifyListeners();
    });
    connector.on('session_request', (payload) {
      print(payload);
      // tasksServices.walletConnectState = TransactionState.session_request;
    });
    connector.on('session_update', (payload) {
      print(payload);
      if (payload.approved == true) {
        // walletConnectActionApproved = true;
        // notifyListeners();
      }
      // tasksServices.walletConnectState = TransactionState.session_update;
    });
    connector.on('disconnect', (session) {
      print(session);
      walletConnectState = TransactionState.disconnected;
      walletConnectConnected = false;
      walletConnectUri = '';
      walletConnectSessionUri = '';
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
  }

  late dynamic _creds;
  EthereumAddress? ownAddress;
  double? ethBalance;
  double? pendingBalance = 0;
  // Future<void> getCredentials() async {
  //   if (_walletconnect == true && credentials != null) {
  //     // TransactionTester? _transactionTester = EthereumTransactionTester();
  //     // await _transactionTester?.sendTransactionWC();
  //     _creds = credentials;
  //     ownAddress = publicAddress;
  //     await fetchTasks();
  //     myBalance();
  //   } else {
  //     _creds = EthPrivateKey.fromHex(_privatekey);
  //     ownAddress = await _creds.extractAddress();
  //     // myBalance = await _creds.getBalance();
  //   }
  // }

  late DeployedContract _deployedContract;
  late ContractFunction _createTask;
  late ContractFunction _deleteTask;
  late ContractFunction _tasks;
  late ContractFunction _taskCount;
  late ContractFunction _changeTaskStatus;
  late ContractFunction _taskParticipation;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;
  // late Throttle throttledFunction;
  late Throttling thr;
  late String searchKeyword = '';

  Future<void> listenToEvents() async {
    // final fromBlock = new BlockNum.genesis();
    final OneEventForAll = _deployedContract.event('OneEventForAll');
    final subscription = _web3client
        .events(FilterOptions.events(
            contract: _deployedContract, event: OneEventForAll))
        // .take(10)
        .listen((event) {
      // final decoded = OneEventForAll.decodeResults(event.topics, event.data);
      //
      // final from = decoded[0] as EthereumAddress;
      // final to = decoded[1] as EthereumAddress;
      // final value = decoded[2] as BigInt;
      //
      // print('$from sent $value MetaCoins to $to');
      print('event fired');
    });
    // await subscription.asFuture();
    // await subscription.cancel();
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

    // EasyDebounce.debounce(
    //     'fetchTasks',                 // <-- An ID for this particular debouncer
    //     Duration(milliseconds: 10000),    // <-- The debounce duration
    //         () => fetchTasks()                // <-- The target method
    // );
    // EasyDebounce.fire('fetchTasks');
    // EasyDebounce.cancel('fetchTasks');
    // throttledFunction = fetchTasks.throttled(
    //   const Duration(seconds: 10),
    // );
    // throttledFunction();

    thr = Throttling(duration: const Duration(seconds: 20));
    thr.throttle(() {
      fetchTasks();
    });
    await myBalance();
    await monitorEvents();
    await listenToEvents();
  }

  Future<void> myBalance() async {
    // late EtherAmount myWalletValue = await _web3client.call(
    //     contract: _deployedContract, function: _getBalance, params: [ownAddress]
    // );
    if (ownAddress != null) {
      final EtherAmount balance = await _web3client.getBalance(ownAddress!);
      final BigInt weiBalance = balance.getInWei;
      // ethBalance = weiBalance.toDouble() * 100000;
      final ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
      ethBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();
      notifyListeners();
      // print(ethBalance);
      // print(ethBalance.toDouble() / 1000000000000000000);
    }
  }

  Future<void> monitorEvents() async {
    final factory = Factory(
        address: _contractAddress, client: _web3client, chainId: _chainId);
    // listen for the Transfer event when it's emitted by the contract above
    final subscription = factory.oneEventForAllEvents().listen((event) async {
      print('received event ${event.contractAdr} index ${event.index}');
      // EasyDebounce.debounce(
      //     'fetchTasks',                 // <-- An ID for this particular debouncer
      //     Duration(milliseconds: 10000),    // <-- The debounce duration
      //         () => fetchTasks()                // <-- The target method
      // );
      // throttledFunction();
      thr.throttle(() {
        fetchTasks();
      });
      // await fetchTasks();
    });
    final subscription2 =
        await factory.jobContractCreatedEvents().listen((event) {
      print(
          'received event ${event.title} jobAddress ${event.jobAddress} description ${event.description}');
      // await fetchTasks();
    });

    // subscription.asFuture();
    // subscription2.asFuture();

    // final allJobs = await factory.allJobs();
    // print('allJobs');
    //
    // BigInt index = BigInt.from(1);
    // final GetJobInfo = await factory.getJobInfo(index);
    // print('getJobInfo');
  }

  Future tellMeHasItMined(String hash) async {
    if (hash.length == 66) {
      TransactionReceipt? transactionReceipt =
          await _web3client.getTransactionReceipt(hash);
      while (transactionReceipt == null) {
        Future.delayed(const Duration(milliseconds: 1000));
        transactionReceipt = await _web3client.getTransactionReceipt(hash);
      }
      // TransactionInformation transactionResult =
      //     await _web3client.getTransactionByHash(hash);
      // print(transactionReceipt);
      if (transactionReceipt.status == true) {
        lastTxn = 'minted';
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
    // filterResults = _allTasks.toList();
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all tasks
      filterResults = tasksNew.toList();
      // print(filterResults);

    } else {
      for (int i = 0; i < tasksNew.length; i++) {
        if (tasksNew
            .elementAt(i)
            .title
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          print('${tasksNew.elementAt(i).title}');
          filterResults.add(tasksNew.elementAt(i));
          // notifyListeners();
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
    notifyListeners();
    List totalTaskList = await _web3client.call(
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
        var temp = await _web3client.call(
            contract: _deployedContract,
            function: _tasks,
            params: [BigInt.from(i)]);
        print(temp);
        var value = await _web3client.call(
            contract: _deployedContract,
            function: _getBalance,
            params: [BigInt.from(temp[6].toInt())]);

        final BigInt weiBalance = value[0];
        final ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
        // ethBalance = (((ethBalancePrecise * 10000).ceil()) / 10000).toDouble();

        // print(value);
        // print(EtherAmount.fromUnitAndValue(EtherUnit.wei, value[0]));
        // print(price);
        // print('Data type: ${ownAddress.runtimeType}');

        // late int contributorsCount;
        // temp[8].length != 0 ? contributorsCount = temp[8].length : contributorsCount = 0;

        var taskObject = Task(
          // id: temp[6].toString(),
          title: temp[0],
          description: temp[7],
          // contractOwner: temp[4].toString(),
          contractOwner: temp[4],
          contractAddress: temp[2],
          jobState: temp[1],
          contributorsCount: temp[8].length,
          contributors: temp[8],
          participiant: temp[9],
          justLoaded: true,
          createdTime:
              DateTime.fromMillisecondsSinceEpoch(temp[5].toInt() * 1000),
          contractValue: ethBalancePrecise,
        );

        taskLoaded = temp[6]
            .toInt(); // this count we need to show the loading process. does not affect anything else

        // if (isLoading == true) {
        notifyListeners();
        // }
        if (temp[1] != "") {
          // var taskState = temp[1];
          tasks.add(taskObject);
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

        for (var k = 0; k < tasks.length; k++) {
          final temp = tasks[k];
          // if (pendingBalance != null) {
          //
          // }
          // final pendingBalance2 = temp.contractValue;
          if (temp.contractValue != 0 && temp.participiant == ownAddress) {
            if (temp.jobState == "agreed" ||
                temp.jobState == "progress" ||
                temp.jobState == "review" ||
                temp.jobState == "completed") {
              pendingBalance = pendingBalance! + temp.contractValue;
            }
          }

          if (temp.jobState != "" && temp.jobState == "new") {
            if (temp.contractOwner == ownAddress) {
              tasksOwner.add(temp);
            } else if (temp.contributors.length != 0) {
              var taskExist = false;
              for (var p = 0; p < temp.contributors.length; p++) {
                if (temp.contributors[p] == ownAddress) {
                  taskExist = true;
                }
              }
              if (taskExist) {
                tasksWithMyParticipation.add(temp);
              } else {
                tasksNew.add(temp);
                filterResults.add(temp);
              }
            } else {
              tasksNew.add(temp);
              filterResults.add(temp);
            }
          }

          if (temp.jobState != "" && temp.jobState == "agreed") {
            if (temp.contractOwner == ownAddress) {
              tasksAgreedSubmitter.add(temp);
            } else if (temp.participiant == ownAddress) {
              tasksPerformer.add(temp);
            }
          }

          if (temp.jobState != "" && temp.jobState == "progress") {
            if (temp.contractOwner == ownAddress) {
              tasksProgressSubmitter.add(temp);
            } else if (temp.participiant == ownAddress) {
              tasksPerformer.add(temp);
            }
          }

          if (temp.jobState != "" && temp.jobState == "review") {
            if (temp.contractOwner == ownAddress) {
              tasksReviewSubmitter.add(temp);
            } else if (temp.participiant == ownAddress) {
              tasksPerformer.add(temp);
            }
          }
          if (temp.jobState != "" &&
              (temp.jobState == "completed" || temp.jobState == "canceled")) {
            if (temp.contractOwner == ownAddress) {
              tasksDoneSubmitter.add(temp);
            } else if (temp.participiant == ownAddress) {
              tasksDonePerformer.add(temp);
            }
          }
        }

        isLoading = false;
        isLoadingBackground = false;
        await myBalance();
        notifyListeners();
        taskLoaded = 0;
        runFilter(searchKeyword); // reset search bar
      }
      loopRunning = false;
    }
  }

  Future<void> addTask(String title, String description, String price) async {
    late int priceInGwei = (double.parse(price) * 1000000000).toInt();
    // late EtherAmount priceInGwei =
    //     EtherAmount.fromUnitAndValue(EtherUnit.ether, int.parse(price));
    // late int priceInGwei = priceInDouble.toInt();
    // print(priceInGwei);
    lastTxn = 'pending';
    late String txn;
    txn = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _createTask,
          parameters: [title, description],
          // gasPrice: EtherAmount.inWei(BigInt.one),
          // maxGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1000)
          //     .getValueInUnit(EtherUnit.gwei)
          //     .toInt(),
          // value: priceInGwei
          // value:
          // EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei.toInt()),
        ),
        chainId: _chainId);
    isLoading = false;
    isLoadingBackground = true;
    lastTxn = txn;
    notifyListeners();
    // fetchTasks();
    tellMeHasItMined(txn);
  }

  Future<void> taskParticipation(EthereumAddress contractAddress) async {
    // var convertedContractAddrToInt = int.parse(contractAddress);
    // assert(myInt is int);
    lastTxn = 'pending';
    late String txn;
    // late TransactionInformation txnRes;
    // late TransactionReceipt? txnRes;
    txn = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _taskParticipation,
          parameters: [contractAddress],
          // gasPrice: EtherAmount.inWei(BigInt.one),
          // maxGas: 100000,
          // maxFeePerGas: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1000),
          // maxPriorityFeePerGas:
          //     EtherAmount.fromUnitAndValue(EtherUnit.ether, 1000),
          // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        ),
        chainId: _chainId);
    isLoading = false;
    isLoadingBackground = true;
    lastTxn = txn;
    notifyListeners();
    // print(txn);
    // txnRes = await _web3client
    //     .addedBlocks()
    //     .asyncMap((_) => _web3client.getTransactionReceipt(txn))
    //     .firstWhere((receipt) => receipt != null);

    // txnRes = await _web3client.getTransactionByHash(txn);
    // txnRes = await _web3client.getTransactionReceipt(txn);
    // print(txnRes);
    // fetchTasks();
    tellMeHasItMined(txn);
  }

  Future<void> changeTaskStatus(EthereumAddress contractAddress,
      EthereumAddress participiantAddress, String state) async {
    lastTxn = 'pending';
    late String txn;
    txn = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _changeTaskStatus,
          parameters: [contractAddress, participiantAddress, state],
          // gasPrice: EtherAmount.inWei(BigInt.one),
          // maxGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1000)
          //     .getValueInUnit(EtherUnit.gwei)
          //     .toInt(),
          // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        ),
        chainId: _chainId);
    isLoading = false;
    isLoadingBackground = true;
    lastTxn = txn;
    notifyListeners();
    // fetchTasks();
    tellMeHasItMined(txn);
  }

  Future<void> withdraw(EthereumAddress contractAddress) async {
    lastTxn = 'pending';
    late String txn;
    txn = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          from: ownAddress,
          contract: _deployedContract,
          function: _withdraw,
          parameters: [contractAddress, ownAddress],
          // gasPrice: EtherAmount.inWei(BigInt.one),
          // maxGas: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 1000)
          //     .getValueInUnit(EtherUnit.gwei)
          //     .toInt(),
          // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        ),
        chainId: _chainId);
    isLoading = false;
    isLoadingBackground = true;
    lastTxn = txn;
    notifyListeners();
    // fetchTasks();
    tellMeHasItMined(txn);
  }

  // Future<void> deleteTask(int id) async {
  //   await _web3client.sendTransaction(
  //     _creds,
  //     Transaction.callContract(
  //       contract: _deployedContract,
  //       function: _deleteTask,
  //       parameters: [BigInt.from(id)],
  //     ),
  //   );
  //   isLoading = true;
  //   notifyListeners();
  //   fetchTasks();
  // }
}
