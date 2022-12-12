import 'package:webthree/webthree.dart';

class Task {
  final String nanoId;
  final DateTime createTime;
  final String taskType;
  final String title;
  final String description;
  final String symbol;
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
  final double contractValue;
  final double contractValueToken;
  late bool justLoaded;
  final String transport;

  Task({
    required this.nanoId,
    required this.createTime,
    required this.taskType,
    required this.title,
    required this.description,
    required this.symbol,
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
    required this.contractValue,
    required this.contractValueToken,
    required this.justLoaded,
    required this.transport,
  });
}
