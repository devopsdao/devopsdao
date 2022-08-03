import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Factory.g.dart';
import 'task.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class TasksServices extends ChangeNotifier {
  List<Task> tasks = [];
  List<Task> tasksNew = [];
  List<Task> tasksOwner = [];
  List<Task> tasksWithMyParticipation = [];
  List<Task> tasksPerformer = [];
  List<Task> tasksAgreedSubmitter = [];

  List<Task> tasksProgressSubmitter = [];
  List<Task> tasksReviewSubmitter = [];
  List<Task> tasksDoneSubmitter = [];
  List<Task> tasksDonePerformer = [];

  final String _rpcUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  final String _wsUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';

  // final String _rpcUrl = Platform.isAndroid
  //     ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
  //     : 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
  // final String _wsUrl = Platform.isAndroid
  //     ? 'https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161'
  //     : 'wss://ropsten.infura.io/ws/v3/9aa3d95b3bc440fa88ea12eaa4456161';
  bool isLoading = true;

  // final String _privatekey =
  //     'f9a150364de5359a07b91b1af8ac1c75ad9e084d7bd2c0e09beb5df7fa6cafa0'; //m's ropsten key
  final String _privatekey =
      '29e52385859d9a1cd067552dcdb4c1734853343cf83dfbf31d76e1871cf1d7ec';
  late Web3Client _web3client;

  // faucet m's key:
  // f9a150364de5359a07b91b1af8ac1c75ad9e084d7bd2c0e09beb5df7fa6cafa0
// r's key
// f819f5453032c5166a3a459506058cb46c37d6eca694dafa76f2b6fe33d430e8
  // internal key's
  // 29e52385859d9a1cd067552dcdb4c1734853343cf83dfbf31d76e1871cf1d7ec - second user
  // 01fe73c191d0433fd7f64390a02469f30044a40a48a548591b630952e084884f

  TasksServices() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }

  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
    await rootBundle.loadString('build/contracts/Factory.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'Factory');
    // _contractAddress = EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["3"]["address"]);
  }

  late EthPrivateKey _creds;
  EthereumAddress? ownAddress;
  EthereumAddress? myBalance;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
    ownAddress = await _creds.extractAddress();
    // myBalance = await _creds.getBalance();
  }
  // EtherAmount myBalance = _web3client.getBalance(_creds);

  late DeployedContract _deployedContract;
  late ContractFunction _createTask;
  late ContractFunction _deleteTask;
  late ContractFunction _tasks;
  late ContractFunction _taskCount;
  late ContractFunction _changeTaskStatus;
  late ContractFunction _taskParticipation;
  late ContractFunction _withdraw;
  late ContractFunction _getBalance;



  Future<void> listenToEvents() async {
    final OneEventForAll = _deployedContract.event('OneEventForAll');
    final subscription = _web3client
        .events(FilterOptions.events(contract: _deployedContract, event: OneEventForAll))
        // .take(1)
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
    await subscription.asFuture();
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
    await monitorEvents();
    await fetchTasks();
  }


  // Future<void> myBalance() async {
  //   final myWalletValue = await _web3client.call(
  //       contract: _deployedContract, function: _getBalance, params: [ownAddress]
  //   );
  // }

  Future<void> monitorEvents() async {
    final factory =
        Factory(address: _contractAddress, client: _web3client, chainId: 3);
    // listen for the Transfer event when it's emitted by the contract above
    final subscription =
        factory.oneEventForAllEvents().take(10).listen((event) async {
      print('received event ${event.contractAdr} index ${event.index}');
      await fetchTasks();
    });
    final subscription2 =
        await factory.jobContractCreatedEvents().take(1).listen((event) {
      print(
          'received event ${event.title} jobAddress ${event.jobAddress} description ${event.description}');
      // await fetchTasks();
    });

    // subscription.asFuture();
    // subscription2.asFuture();

    final allJobs = await factory.allJobs();
    print('allJobs');

    BigInt index = BigInt.from(1);
    final GetJobInfo = await factory.getJobInfo(index);
    print('getJobInfo');
  }

  Future<void> fetchTasks() async {
    List totalTaskList = await _web3client.call(
      contract: _deployedContract,
      function: _taskCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    tasks.clear();
    tasksNew.clear();
    tasksOwner.clear();
    tasksWithMyParticipation.clear();
    tasksPerformer.clear();
    tasksAgreedSubmitter.clear();
    tasksReviewSubmitter.clear();
    tasksDonePerformer.clear();
    tasksDoneSubmitter.clear();
    tasksProgressSubmitter.clear();

    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3client.call(
          contract: _deployedContract,
          function: _tasks,
          params: [BigInt.from(i)]);
      print(temp);
      var value = await _web3client.call(
          contract: _deployedContract,
          function: _getBalance,
          params: [BigInt.from(temp[6].toInt())]);

      print(value);
      print(EtherAmount.fromUnitAndValue(EtherUnit.wei, value[0]));
      // print(price);
      // print('Data type: ${ownAddress.runtimeType}');
      //
      // late int contributorsCount;
      // temp[8].length != 0 ? contributorsCount = temp[8].length : contributorsCount = 0;

      var taskObject = Task(
        // id: (temp[0] as BigInt).toInt(),
        title: temp[0],
        description: temp[7],
        // contractOwner: temp[4].toString(),
        contractOwner: temp[4],
        contractAddress: temp[2],
        jobState: temp[1],
        // contributorsCount: temp[8].isEmpty ? 0 : temp[8].length(),
        contributorsCount: temp[8].length,
        contributors: temp[8],
        participiant: temp[9],
        // contractValue: value[0],
      );

      if (temp[1] != "") {
        var taskState = temp[1];
        tasks.add(taskObject);
      }
      if (temp[1] != "" && temp[1] == "new") {
        if (temp[4] == ownAddress) {
          tasksOwner.add(taskObject);
        } else if (temp[8].length != 0) {
          for (var p = 0; p < temp[8].length; p++) {
            // late EthereumAddress _tempParticipationsAddress;
            // _tempParticipationsAddress = temp[8][p];
            if (temp[8][p] == ownAddress) {
              tasksWithMyParticipation.add(taskObject);
            }
          }
        } else {
          tasksNew.add(taskObject);
        }
      }

      if (temp[1] != "" && temp[1] == "agreed") {
        if (temp[4] == ownAddress) {
          tasksAgreedSubmitter.add(taskObject);
        } else if (temp[9] == ownAddress) {
          tasksPerformer.add(taskObject);
        }
      }

      if (temp[1] != "" && temp[1] == "progress") {
        if (temp[4] == ownAddress) {
          tasksProgressSubmitter.add(taskObject);
        } else if (temp[9] == ownAddress) {
          tasksPerformer.add(taskObject);
        }
      }

      if (temp[1] != "" && temp[1] == "review") {
        if (temp[4] == ownAddress) {
          tasksReviewSubmitter.add(taskObject);
        } else if (temp[9] == ownAddress) {
          tasksPerformer.add(taskObject);
        }
      }
      if (temp[1] != "" && (temp[1] == "completed" || temp[1] == "canceled")) {
        if (temp[4] == ownAddress) {
          tasksDoneSubmitter.add(taskObject);
        } else if (temp[9] == ownAddress) {
          tasksDonePerformer.add(taskObject);
        }
      }
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _createTask,
          parameters: [title, description],
          //value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 0.0001),
        ),
        chainId: 3);
    isLoading = true;
    // fetchTasks();
  }

  Future<void> taskParticipation(EthereumAddress contractAddress) async {
    // var convertedContractAddrToInt = int.parse(contractAddress);
    // assert(myInt is int);
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _taskParticipation,
          parameters: [contractAddress],
          // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        ),
        chainId: 3);
    isLoading = true;
    // fetchTasks();
  }

  Future<void> changeTaskStatus(EthereumAddress contractAddress,
      EthereumAddress participiantAddress, String state) async {
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _changeTaskStatus,
          parameters: [contractAddress, participiantAddress, state],
          // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        ),
        chainId: 3);
    isLoading = true;
    // fetchTasks();
  }

  Future<void> withdraw(int contractAddress) async {
    await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _withdraw,
          parameters: [contractAddress],
          // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
        ),
        chainId: 3);
    isLoading = true;
    // fetchTasks();
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
