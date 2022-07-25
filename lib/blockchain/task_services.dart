import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class TasksServices extends ChangeNotifier {
  List<Task> tasks = [];
  List<Task> tasksNew = [];
  List<Task> tasksAgreed = [];
  List<Task> tasksProgress = [];
  List<Task> tasksReview = [];
  List<Task> tasksCompleted = [];
  List<Task> tasksCanceled = [];
  final String _rpcUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';
  final String _wsUrl =
  Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';
  bool isLoading = true;

  final String _privatekey =
      '01fe73c191d0433fd7f64390a02469f30044a40a48a548591b630952e084884f';
  late Web3Client _web3cient;

  TasksServices() {
    init();
  }

  Future<void> init() async {
    _web3cient = Web3Client(
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
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'Factory');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

  late DeployedContract _deployedContract;
  late ContractFunction _createTask;
  late ContractFunction _deleteTask;
  late ContractFunction _tasks;
  late ContractFunction _taskCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createTask = _deployedContract.function('createJobContract');
    // _deleteTask = _deployedContract.function('deleteTask');
    _tasks = _deployedContract.function('getJobInfo');
    _taskCount = _deployedContract.function('countNew');
    await fetchTasks();
  }

  Future<void> fetchTasks() async {
    List totalTaskList = await _web3cient.call(
      contract: _deployedContract,
      function: _taskCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    tasks.clear();
    tasksNew.clear();
    tasksAgreed.clear();
    for (var i = 0; i < totalTaskLen; i++) {

      var temp = await _web3cient.call(
          contract: _deployedContract,
          function: _tasks,
          params: [BigInt.from(i)]);
      print(temp);
      var taskObject = Task(
        // id: (temp[0] as BigInt).toInt(),
        title: temp[0],
        description: temp[7],
        contractOwner: temp[4].toString(),
        jobState: temp[1],
      );

      if (temp[1] != "") {
        var taskState = temp[1];
        tasks.add(
            taskObject
        );
      }
      if (temp[1] != "" && temp[1] == "new") {
        tasksNew.add(taskObject);
      }
      if (temp[1] != "" && temp[1] == "agreed") {
        tasksAgreed.add(taskObject);
      }
    }
    isLoading = false;

    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createTask,
        parameters: [title, description],
        value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
      ),

    );
    isLoading = true;
    fetchTasks();
  }

  // Future<void> deleteTask(int id) async {
  //   await _web3cient.sendTransaction(
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