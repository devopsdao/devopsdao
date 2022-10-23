import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:js/js.dart'
    if (dart.library.io) 'package:webthree/src/browser/js_stub.dart'
    if (dart.library.js) 'package:js/js.dart';

import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:nanoid/nanoid.dart';
import 'package:throttling/throttling.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../custom_widgets/wallet_action.dart';
import 'Factory.g.dart';
import 'TasksFacet.g.dart';
import 'TaskContract.g.dart';
import 'IERC20.g.dart';
import 'task.dart';
import "package:universal_html/html.dart" hide Platform;
import 'package:webthree/browser.dart'
    if (dart.library.io) 'package:webthree/src/browser/dart_wrappers_stub.dart'
    if (dart.library.js) 'package:webthree/browser.dart';
import 'package:webthree/webthree.dart';
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
  bool hardhatDebug = false;
  Map<String, Task> tasks = {};
  Map<String, Task> filterResults = {};
  Map<String, Task> tasksNew = {};
  Map<String, Task> tasksAuditPending = {};
  Map<String, Task> tasksAuditApplied = {};
  Map<String, Task> tasksAuditWorkingOn = {};
  Map<String, Task> tasksAuditComplete = {};

  Map<String, Task> tasksPerformerParticipate = {};
  Map<String, Task> tasksPerformerProgress = {};
  Map<String, Task> tasksPerformerComplete = {};

  Map<String, Task> tasksCustomerApplied = {};
  Map<String, Task> tasksCustomerWorking = {};
  Map<String, Task> tasksCustomerComplete = {};

  Map<String, Map<String, Map<String, String>>> transactionStatuses = {};

  var credentials;
  EthereumAddress? publicAddress;
  var transactionTester;

  var walletConnectState;
  bool walletConnected = false;
  String walletConnectUri = '';
  String walletConnectSessionUri = '';
  // bool walletConnectActionApproved = false;
  var eth;
  String lastTxn = '';

  String platform = 'mobile';
  //final String _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
  //final String _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';

  late String _rpcUrl;
  late String _wsUrl;

  late int chainId;
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
    if (hardhatDebug == true) {
      chainId = 31337;
      _rpcUrl = 'http://localhost:8545';
      _wsUrl = 'wss://localhost:8545';
    } else {
      chainId = 1287;
      _rpcUrl = 'https://rpc.api.moonbase.moonbeam.network';
      _wsUrl = 'wss://wss.api.moonbase.moonbeam.network';
    }
    isDeviceConnected = false;

    if (platform != 'web') {
      final StreamSubscription subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        if (result != ConnectivityResult.none) {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          await getTransferFee(
              sourceChainName: 'moonbeam',
              destinationChainName: 'ethereum',
              assetDenom: 'uausdc',
              amountInDenom: 100000);
        }
      });
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
    await startup();
    // await getABI();
    // await getDeployedContract();

    if (platform == 'web') {}

    initComplete = true;
  }

  late ContractAbi _abiCode;

  late num totalTaskLen = 0;
  int taskLoaded = 0;
  late EthereumAddress _contractAddress;
  EthereumAddress zeroAddress =
      EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('lib/blockchain/abi/TasksFacet.json');

    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI), 'TasksFacet');

    String addressesFile =
        await rootBundle.loadString('lib/blockchain/abi/addresses.json');
    var addresses = jsonDecode(addressesFile);
    _contractAddress = EthereumAddress.fromHex(addresses["Diamond"]);
  }

  bool validChainID = false;

  Future<void> connectWalletWC() async {
    print('async');
    if (transactionTester != null) {
      var connector = await transactionTester.initWalletConnect();

      if (walletConnected == false) {
        print("disconnected");
        walletConnectUri = '';
        walletConnectSessionUri = '';
      }
      // Subscribe to events
      connector.on('connect', (session) {
        print(session);
        walletConnectState = TransactionState.connected;
        walletConnected = true;
        () async {
          if (hardhatDebug == false) {
            credentials = await transactionTester?.getCredentials();
            chainId = session.chainId;
            if (chainId == 1287) {
              validChainID = true;
            } else {
              validChainID = false;
            }
            publicAddress = await transactionTester?.getPublicAddress(session);
          } else {
            chainId = 31337;
            validChainID = true;
          }
          fetchTasks();

          myBalance();
          isLoading = true;
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
        walletConnected = false;
        walletConnectUri = '';
        walletConnectSessionUri = '';

        publicAddress = null;
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
      } else if (walletConnected == true) {
        if (hardhatDebug == false) {
          credentials = await transactionTester?.getCredentials();
        }
        publicAddress = await transactionTester?.getPublicAddress(session);
      } else {
        walletConnectState = TransactionState.failed;
      }
    } else {
      print("not initialized");
      print(walletConnectState);
    }
  }

  Future<void> connectWalletMM() async {
    if (platform == 'web' && window.ethereum != null) {
      final eth = window.ethereum;

      if (eth == null) {
        print('MetaMask is not available');
        return;
      }
      var ethRPC = eth.asRpcService();

      final client = Web3Client.custom(ethRPC);

      credentials = await eth.requestAccount();
      publicAddress = credentials.address;
      final chainIdHex = await eth.rawRequest('eth_chainId');
      int chainId = int.parse(chainIdHex);

      if (chainId == 1287) {
        validChainID = true;
      } else {
        print('invalid chainId ${chainId}');

        await eth.rawRequest('wallet_switchEthereumChain',
            params: [JSrawRequestParams(chainId: '0x507')]);
        final chainIdHex = await eth.rawRequest('eth_chainId');
        chainId = int.parse(chainIdHex);
        if (chainId == 1287) {
          validChainID = true;
        } else {
          validChainID = false;
        }
      }

      // walletConnected = true;

// Subscribe to events
      var connectStream = eth.connect;
      connectStream.listen((event) {
        print(event);
      });
      var disconnectStream = eth.disconnect;
      disconnectStream.listen((event) {
        print(event);
      });
      var connect = eth.stream('connect').listen((event) {
        print(event);
      });
      var disconnect = eth.stream('disconnect').listen((event) {
        print(event);
      });
      // eth.on('connect', (session) {
      //   print(session);
      //   walletConnected = true;
      //   () async {
      //     if (hardhatDebug == false) {
      //       credentials = await eth.requestAccount();
      //       publicAddress = credentials.address;
      //       final chainIdHex = await eth.rawRequest('eth_chainId');
      //       int chainId = int.parse(chainIdHex);
      //       if (chainId == 1287) {
      //         validChainID = true;
      //       } else {
      //         validChainID = false;
      //       }
      //     } else {
      //       chainId = 31337;
      //       validChainID = true;
      //     }
      //     fetchTasks();
      //     myBalance();
      //     isLoading = true;
      //   }();
      //   notifyListeners();
      // });

      // eth.on('disconnect', (session) {
      //   print(session);
      //   walletConnected = false;
      //   publicAddress = null;
      //   ethBalance = 0;
      //   ethBalanceToken = 0;
      //   pendingBalance = 0;
      //   pendingBalanceToken = 0;
      //   notifyListeners();
      // });

      fetchTasks();

      myBalance();
      notifyListeners();
    } else {
      print("eth not initialized");
    }
  }

  // Future<void> disconnectWalletMM() {
  //   final eth = window.ethereum;
  //   // eth?.cancel();
  // }

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

  // late dynamic credentials;
  late dynamic accounts;
  double? ethBalance = 0;
  double? ethBalanceToken = 0;
  double? pendingBalance = 0;
  double? pendingBalanceToken = 0;
  int score = 0;
  int scoredTaskCount = 0;
  double myScore = 0.0;

  late TasksFacet tasksFacet;
  // late TaskContract taskContract;

  late DeployedContract _deployedContract;
  late ContractFunction _withdraw;

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

  late Map fees;
  Future<void> startup() async {
    String addressesFile =
        await rootBundle.loadString('lib/blockchain/abi/addresses.json');
    var addresses = jsonDecode(addressesFile);
    _contractAddress = EthereumAddress.fromHex(
        addresses['contracts'][chainId.toString()]["Diamond"]);

    if (hardhatDebug == true) {
      String accountsFile =
          await rootBundle.loadString('lib/blockchain/accounts/hardhat.json');
      accounts = jsonDecode(accountsFile);
      credentials = EthPrivateKey.fromHex(accounts[0]["key"]);
      publicAddress = EthereumAddress.fromHex(accounts[0]["address"]);
      walletConnected = true;
      validChainID = true;
    }

    thr = Throttling(duration: const Duration(seconds: 20));
    await connectContracts();
    thr.throttle(() {
      fetchTasks();
    });
    await myBalance();
    await monitorEvents();

    fees = await _web3client.getGasInEIP1559();
    print(fees);
    print("maxFeePerGas: ${fees['medium'].maxFeePerGas}");
    print("maxPriorityFeePerGas: ${fees['medium'].maxPriorityFeePerGas}");
    print("maxPriorityFeePerGas: ${fees['medium'].maxPriorityFeePerGas}");
    print("maxGas: ${fees['medium'].estimatedGas}");

    BigInt estimatedGas = await _web3client.estimateGas(
        sender: publicAddress,
        to: EthereumAddress.fromHex(
            '0x3089c7c8f5aa2be20531634df9c12b72eaa79b0a'),
        amountOfGas: fees['medium'].estimatedGas,
        maxFeePerGas: fees['medium'].maxFeePerGas,
        maxPriorityFeePerGas: fees['medium'].maxPriorityFeePerGas);
    print("maxGas: ${estimatedGas}");

    // print("maxGas: ${fees['medium'].estimatedGas * 10}");
    // print("maxGas: ${fees['medium'].estimatedGas * 1000000}");
  }

  Future<void> connectContracts() async {
    EthereumAddress tokenContractAddress =
        EthereumAddress.fromHex('0xD1633F7Fb3d716643125d6415d4177bC36b7186b');

    ierc20 = IERC20(
        address: tokenContractAddress, client: _web3client, chainId: chainId);
    tasksFacet = TasksFacet(
        address: _contractAddress, client: _web3client, chainId: chainId);
  }

  Future<void> myBalance() async {
    if (publicAddress != null) {
      final EtherAmount balance = await web3GetBalance(publicAddress!);
      // final BigInt weiBalance = BigInt.from(0);
      final BigInt weiBalance = balance.getInWei;
      final ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
      ethBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();

      // final BigInt weiBalanceToken =
      //     await web3GetBalanceToken(publicAddress!, 'aUSDC');
      final BigInt weiBalanceToken = BigInt.from(0);
      final ethBalancePreciseToken = weiBalanceToken.toDouble() / pow(10, 6);
      ethBalanceToken =
          (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();
      notifyListeners();
    }
  }

  // EthereumAddress lastJobContract;
  Future<void> monitorEvents() async {
    // listen for the Transfer event when it's emitted by the contract
    final subscription =
        tasksFacet.oneEventForAllEvents().listen((event) async {
      print('received event ${event.contractAdr} index ${event.message}');
      thr.throttle(() {
        fetchTasks();
      });
    });
    final subscription2 =
        tasksFacet.jobContractCreatedEvents().listen((event) async {
      print(
          'received event ${event.title} jobAddress ${event.taskAddress} description ${event.description}');
      if (event.taskOwner == publicAddress) {
        transactionStatuses[event.nanoId]!['task'] = {
          'jobAddress': event.taskAddress.toString()
        };
      }
    });

    final subscription3 = ierc20.approvalEvents().listen((event) async {
      print(
          'received event approvalEvents ${event.owner} spender ${event.spender} value ${event.value}');
      if (event.owner == publicAddress) {
        print(event.owner);
      }
    });
  }

  Future tellMeHasItMined(String hash, String taskAction, String nanoId) async {
    if (hash.length == 66) {
      TransactionReceipt? transactionReceipt =
          await web3GetTransactionReceipt(hash);
      while (transactionReceipt == null) {
        Future.delayed(const Duration(milliseconds: 1000));
        transactionReceipt = await web3GetTransactionReceipt(hash);
      }

      if (transactionReceipt.status == true) {
        transactionStatuses[nanoId]![taskAction]!['status'] = 'minted';
        transactionStatuses[nanoId]![taskAction]!['txn'] = hash;
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

  Future<void> runFilter(
      String enteredKeyword, Map<String, Task> taskList) async {
    filterResults.clear();
    print(enteredKeyword);
    searchKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      filterResults = Map.from(taskList);
    } else {
      for (String nanoId in taskList.keys) {
        if (taskList[nanoId]!
            .title
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          filterResults[nanoId] = taskList[nanoId]!;
        }
      }
    }
    // Refresh the UI
    notifyListeners();
  }

  Future<void> resetFilter(Map<String, Task> taskList) async {
    filterResults.clear();
    filterResults = Map.from(taskList);
  }

  late bool loopRunning = false;
  late bool stopLoopRunning = false;

  Future<void> fetchTasks() async {
    isLoadingBackground = true;
    notifyListeners();
    List totalTaskList = await tasksFacet.getTaskContracts();
    tasks.clear();

    if (loopRunning) {
      stopLoopRunning = true;
    }

    if (loopRunning == false) {
      loopRunning = true;
      for (var i = 0; i < totalTaskList.length; i++) {
        if (stopLoopRunning) {
          tasks.clear();
          stopLoopRunning = false;
          loopRunning = false;
          fetchTasks();
          break;
        }
        List task;
        List value;
        double ethBalancePrecise = 0;
        double ethBalanceToken = 0;
        TaskContract taskContract = TaskContract(
            address: totalTaskList[i], client: _web3client, chainId: chainId);
        task = await taskContract.getTaskInfo();
        if (task != null) {
          print(task);
          final BigInt weiBalance = await taskContract.getBalance();
          // final BigInt weiBalance = BigInt.from(0);
          ethBalancePrecise = weiBalance.toDouble() / pow(10, 18);
          // final BigInt weiBalanceToken =
          //     await web3GetBalanceToken(totalTaskList[i], task[6]);
          final BigInt weiBalanceToken = BigInt.from(0);
          final ethBalancePreciseToken =
              weiBalanceToken.toDouble() / pow(10, 6);
          ethBalanceToken =
              (((ethBalancePreciseToken * 10000).floor()) / 10000).toDouble();

          var taskObject = Task(
            // nanoId: task[0],
            nanoId: task[1].toString(),
            createTime:
                DateTime.fromMillisecondsSinceEpoch(task[1].toInt() * 1000),
            taskType: task[2],
            title: task[3],
            description: task[4],
            symbol: task[5],
            taskState: task[6],
            auditState: task[7],
            rating: task[8].toInt(),
            contractOwner: task[9],
            participant: task[10],
            auditInitiator: task[11],
            auditor: task[12],
            participants: task[13],
            funders: task[14],
            auditors: task[15],
            messages: task[16],
            contractAddress: totalTaskList[i],
            justLoaded: true,
            contractValue: ethBalancePrecise,
            contractValueToken: ethBalanceToken,
          );

          taskLoaded = i +
              1; // this count we need to show the loading process. does not affect anything else

          notifyListeners();
          if (task[1] != "") {
            tasks[taskObject.nanoId] = taskObject;
            // tasks.add(taskObject);
          }
        }
      }

      taskLoaded = 0;

      if (loopRunning) {
        filterResults.clear();
        tasksNew.clear();

        tasksAuditPending.clear();
        tasksAuditApplied.clear();
        tasksAuditWorkingOn.clear();
        tasksAuditComplete.clear();

        tasksCustomerApplied.clear();
        tasksCustomerWorking.clear();
        tasksCustomerComplete.clear();

        tasksPerformerParticipate.clear();
        tasksPerformerProgress.clear();
        tasksPerformerComplete.clear();

        pendingBalance = 0;
        pendingBalanceToken = 0;
        score = 0;
        scoredTaskCount = 0;

        for (Task task in tasks.values) {
          // for (var k = 0; k < tasks.length; k++) {
          // final task = tasks[k];

          // Who participate in the TASK:
          if (task.participant == publicAddress) {
            // Calculate Pending among:
            if ((task.contractValue != 0 || task.contractValueToken != 0)) {
              if (task.taskState == "agreed" ||
                  task.taskState == "progress" ||
                  task.taskState == "review" ||
                  task.taskState == "completed") {
                pendingBalance = pendingBalance! + task.contractValue;
                pendingBalanceToken =
                    pendingBalanceToken! + task.contractValueToken;
              }
            }
            // add all scored Task for calculation:
            if (task.rating != 0) {
              score = score + task.rating;
              scoredTaskCount++;
            }
          }
          if (task.taskState != "" &&
              (task.taskState == "agreed" ||
                  task.taskState == "progress" ||
                  task.taskState == "review" ||
                  task.taskState == "audit")) {
            if (task.contractOwner == publicAddress) {
              tasksCustomerWorking[task.nanoId] = task;
            } else if (task.participant == publicAddress) {
              tasksPerformerProgress[task.nanoId] = task;
            }
            if (hardhatDebug == true) {
              tasksPerformerProgress[task.nanoId] = task;
            }
          }

          // New TASKs for all users:
          if (task.taskState != "" && task.taskState == "new") {
            if (hardhatDebug == true) {
              tasksNew[task.nanoId] = task;
              filterResults[task.nanoId] = task;
            }
            if (task.contractOwner == publicAddress) {
              tasksCustomerApplied[task.nanoId] = task;
            } else if (task.participants.isNotEmpty) {
              var taskExist = false;
              for (var p = 0; p < task.participants.length; p++) {
                if (task.participants[p] == publicAddress) {
                  taskExist = true;
                }
              }
              if (taskExist) {
                tasksPerformerParticipate[task.nanoId] = task;
              } else {
                tasksNew[task.nanoId] = task;
                filterResults[task.nanoId] = task;
                // tasksNew.add(task);
                // filterResults.add(task);
              }
            } else {
              tasksNew[task.nanoId] = task;
              filterResults[task.nanoId] = task;
              // tasksNew.add(task);
              // filterResults.add(task);
            }
          }

          if (task.taskState != "" &&
              (task.taskState == "completed" || task.taskState == "canceled")) {
            if (task.contractOwner == publicAddress) {
              tasksCustomerComplete[task.nanoId] = task;
            } else if (task.participant == publicAddress) {
              tasksPerformerComplete[task.nanoId] = task;
            }
            if (hardhatDebug == true) {
              tasksPerformerComplete[task.nanoId] = task;
            }
          }

          // **** AUDIT ****
          // For auditors:
          if (task.taskState == "audit") {
            // Auditor side:
            if (task.auditState == "requested") {
              if (task.auditors.isNotEmpty) {
                var contrExist = false;
                for (var p = 0; p < task.auditors.length; p++) {
                  if (task.auditors[p] == publicAddress) {
                    contrExist = true;
                  }
                }
                if (contrExist) {
                  tasksAuditApplied[task.nanoId] = task;
                } else {
                  tasksAuditPending[task.nanoId] = task;
                }
              } else {
                tasksAuditPending[task.nanoId] = task;
              }
            }

            if (task.auditor == publicAddress) {
              if (task.auditState == "performing") {
                tasksAuditWorkingOn[task.nanoId] = task;
              } else if (task.auditState == "complete" ||
                  task.auditState == "finished") {
                tasksAuditComplete[task.nanoId] = task;
              }
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
        // runFilter(searchKeyword); // reset search bar
      }
      loopRunning = false;
    }
  }

  Future<void> approveSpend(
      EthereumAddress _contractAddress,
      EthereumAddress publicAddress,
      String symbol,
      BigInt amount,
      String nanoId) async {
    final transaction = Transaction(
      from: publicAddress,
    );
    final result = await ierc20.approve(_contractAddress, amount,
        credentials: credentials, transaction: transaction);
    print('result of approveSpend: ' + result);
    transactionStatuses[nanoId]!['createTaskContract']!['tokenApproved'] =
        'approved';
    notifyListeners();
    await tellMeHasItMined(result, 'createTaskContract', nanoId);
    print('mined');
  }

  String taskTokenSymbol = 'ETH';
  Future<void> createTaskContract(
      String title, String description, double price, String nanoId) async {
    if (taskTokenSymbol != '') {
      transactionStatuses[nanoId] = {
        'createTaskContract': {
          'status': 'pending',
          'tokenApproved': 'initial',
          'txn': 'initial'
        } //
      };
      late int priceInGwei = (price * 1000000000).toInt();
      final BigInt priceInBigInt = BigInt.from(price * 1e6);
      late String txn;
      String taskType = 'public';
      if (taskTokenSymbol == 'ETH') {
        final transaction = Transaction(
          from: publicAddress,
          value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );
        txn = await tasksFacet.createTaskContract(nanoId, taskType, title,
            description, taskTokenSymbol, priceInBigInt,
            credentials: credentials, transaction: transaction);
      } else if (taskTokenSymbol == 'aUSDC') {
        await approveSpend(_contractAddress, publicAddress!, taskTokenSymbol,
            priceInBigInt, nanoId);
        final transaction = Transaction(
          value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
        );
        txn = await tasksFacet.createTaskContract(nanoId, title, taskType,
            description, taskTokenSymbol, priceInBigInt,
            credentials: credentials, transaction: transaction);
        print(txn);
      }
      isLoading = false;
      // isLoadingBackground = true;
      lastTxn = txn;
      transactionStatuses[nanoId]!['createTaskContract']!['status'] =
          'confirmed';
      transactionStatuses[nanoId]!['createTaskContract']!['tokenApproved'] =
          'complete';
      transactionStatuses[nanoId]!['createTaskContract']!['txn'] = txn;

      tellMeHasItMined(txn, 'createTaskContract', nanoId);
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
        from: publicAddress,
        to: addressToSend,
        value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
      );

      txn = await web3Transaction(credentials, transaction, chainId: chainId);
      print(txn);
    } else if (taskTokenSymbol == 'aUSDC') {
      final transaction = Transaction(
        from: publicAddress,
      );
      txn = await ierc20.transfer(addressToSend, priceInBigInt,
          credentials: credentials, transaction: transaction);
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

  Future<void> taskParticipate(
      EthereumAddress contractAddress, String nanoId) async {
    transactionStatuses[nanoId] = {
      'taskParticipate': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    String message = 'taking this task';
    BigInt replyTo = BigInt.from(0);
    TaskContract taskContract = TaskContract(
        address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(accounts[1]["key"]);
    } else {
      creds = credentials;
    }
    final transaction = Transaction(
      from: publicAddress,
    );
    txn = await taskContract.taskParticipate(message, replyTo,
        credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    // lastTxn = txn;
    transactionStatuses[nanoId]!['taskParticipate']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskParticipate']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskParticipate', nanoId);
  }

  Future<void> taskAuditParticipate(
      EthereumAddress contractAddress, String nanoId) async {
    transactionStatuses[nanoId] = {
      'taskAuditParticipate': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    String message = 'auditing this task';
    BigInt replyTo = BigInt.from(0);
    TaskContract taskContract = TaskContract(
        address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(accounts[1]["key"]);
    } else {
      creds = credentials;
    }
    final transaction = Transaction(
      from: publicAddress,
    );
    txn = await taskContract.taskAuditParticipate(message, replyTo,
        credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    // lastTxn = txn;
    transactionStatuses[nanoId]!['taskAuditParticipate']!['status'] =
        'confirmed';
    transactionStatuses[nanoId]!['taskAuditParticipate']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskAuditParticipate', nanoId);
  }

  Future<void> taskStateChange(EthereumAddress contractAddress,
      EthereumAddress participantAddress, String state, String nanoId) async {
    transactionStatuses[nanoId] = {
      'taskStateChange': {'status': 'pending', 'txn': 'initial'}
    };
    // lastTxn = 'pending';
    late String txn;
    String message = 'moving this task';
    BigInt replyTo = BigInt.from(0);
    BigInt score = BigInt.from(5);
    TaskContract taskContract = TaskContract(
        address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    if (hardhatDebug == true) {
      if (state == 'agreed' ||
          state == 'audit' ||
          state == 'completed' ||
          state == 'canceled') {
        creds = credentials;
      } else if (state == 'progress' || state == 'review') {
        creds = EthPrivateKey.fromHex(accounts[1]["key"]);
      } else {
        //a default for any new state
        creds = credentials;
      }
    } else {
      creds = credentials;
    }
    final transaction = Transaction(
      from: publicAddress,
    );
    txn = await taskContract.taskStateChange(
        participantAddress, state, message, replyTo, score,
        credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['taskStateChange']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskStateChange']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskStateChange', nanoId);
  }

  Future<void> taskAuditDecision(
      EthereumAddress contractAddress, String favour, String nanoId) async {
    transactionStatuses[nanoId] = {
      'taskAuditDecision': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    String message = 'auditing this task';
    BigInt replyTo = BigInt.from(0);
    BigInt score = BigInt.from(5);
    TaskContract taskContract = TaskContract(
        address: contractAddress, client: _web3client, chainId: chainId);
    var creds;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(accounts[2]["key"]);
    } else {
      creds = credentials;
    }
    final transaction = Transaction(
      from: publicAddress,
    );
    txn = await taskContract.taskAuditDecision(favour, message, replyTo, score,
        credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['taskAuditDecision']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['taskAuditDecision']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'taskAuditDecision', nanoId);
  }

  String destinationChain = 'Moonbase';
  Future<void> withdrawToChain(
      EthereumAddress contractAddress, String nanoId) async {
    transactionStatuses[nanoId] = {
      'withdrawToChain': {'status': 'pending', 'txn': 'initial'}
    };
    late String txn;
    String chain = 'moonbase';
    TaskContract taskContract = TaskContract(
        address: contractAddress, client: _web3client, chainId: chainId);
    //should send value now?!
    var creds;
    if (hardhatDebug == true) {
      creds = EthPrivateKey.fromHex(accounts[1]["key"]);
    } else {
      creds = credentials;
    }

    BigInt estimatedGas = await _web3client.estimateGas(
        sender: publicAddress,
        to: contractAddress,
        amountOfGas: fees['medium'].estimatedGas,
        maxFeePerGas: fees['medium'].maxFeePerGas,
        maxPriorityFeePerGas: fees['medium'].maxPriorityFeePerGas);

    int price = 15;
    int priceInGwei = (price).toInt();
    EtherAmount gasPrice =
        EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei);

    final transaction = Transaction(
        from: publicAddress,
        // maxFeePerGas: fees['medium'].maxFeePerGas,
        // maxPriorityFeePerGas: fees['medium'].maxPriorityFeePerGas,
        maxGas: estimatedGas.toInt(),
        gasPrice: gasPrice);
    txn = await taskContract.transferToaddress(publicAddress!, chain,
        credentials: creds, transaction: transaction);
    isLoading = false;
    // isLoadingBackground = true;
    lastTxn = txn;
    transactionStatuses[nanoId]!['withdrawToChain']!['status'] = 'confirmed';
    transactionStatuses[nanoId]!['withdrawToChain']!['txn'] = txn;
    notifyListeners();
    tellMeHasItMined(txn, 'withdrawToChain', nanoId);
  }

  double gasPriceValue = 0;
  Future<void> getGasPrice(sourceChain, destinationChain,
      {tokenAddress, tokenSymbol}) async {
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

  Future<void> testTaskCreation() async {
    int price = 5;
    late int priceInGwei = (price * 1000000000).toInt();
    final transaction = Transaction(
      value: EtherAmount.fromUnitAndValue(EtherUnit.gwei, priceInGwei),
    );
    var createContract = await tasksFacet.createTaskContract('testID', 'public',
        'task title', 'task decription', 'ETH', BigInt.from(1),
        credentials: credentials, transaction: transaction);
    var taskContracts = await tasksFacet.getTaskContracts();

    TaskContract taskContract = TaskContract(
        address: taskContracts[0], client: _web3client, chainId: chainId);
    var taskInfo = await taskContract.getTaskInfo();
  }
}
