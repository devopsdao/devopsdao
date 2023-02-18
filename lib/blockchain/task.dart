import 'package:webthree/webthree.dart';

class Task {
  final String nanoId;
  final DateTime createTime;
  final String taskType;
  final String title;
  final String description;
  final List<dynamic> tags;
  final List<dynamic> tagsNFT;
  final List<dynamic> symbols;
  final List<dynamic> amounts;
  final String taskState;
  final String auditState;
  final int rating;
  final EthereumAddress contractOwner;
  final EthereumAddress participant;
  final EthereumAddress auditInitiator;
  final EthereumAddress auditor;
  final List<dynamic> participants;
  final List<dynamic> funders;
  final List<dynamic> auditors;
  final List<dynamic> messages;
  final EthereumAddress taskAddress;
  final List<String> tokenNames;
  final List<dynamic> tokenValues;
  late bool justLoaded;
  final String transport;

  Task({
    required this.nanoId,
    required this.createTime,
    required this.taskType,
    required this.title,
    required this.description,
    required this.tags,
    required this.tagsNFT,
    required this.symbols,
    required this.amounts,
    required this.taskState,
    required this.auditState,
    required this.rating,
    required this.contractOwner,
    required this.participant,
    required this.auditInitiator,
    required this.auditor,
    required this.participants,
    required this.funders,
    required this.auditors,
    required this.messages,
    required this.taskAddress,
    required this.tokenNames,
    required this.tokenValues,
    required this.justLoaded,
    required this.transport,
  });
}

// class TaskData extends MapBase<String, TaskData> {
//   final String nanoId;
//   final String taskType;
//   final String title;
//   final String description;
//   final List<String> symbols;
//   final List<int> amounts;

//   final Map<String, TaskData> _map = HashMap.identity();

//   TaskData operator [](Object key) => _map[key];
//   void operator []=(String key, TaskData value) => _map[key] = value;
//   void clear() => _map.clear();
//   Iterable<String> get keys => _map.keys;
//   TaskData remove(Object key) => _map.remove(key);
//   TaskData(
//       {required this.nanoId, required this.taskType, required this.title, required this.description, required this.symbols, required this.amounts});
// }
