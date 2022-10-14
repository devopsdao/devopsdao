import 'package:webthree/webthree.dart';

class Task {
  final String title;
  final String description;
  final EthereumAddress contractOwner;
  final String jobState;
  final EthereumAddress contractAddress;
  final int contributorsCount;
  final List<dynamic> contributors;
  final EthereumAddress participiant;
  late bool justLoaded;
  final DateTime createdTime;
  final double contractValue;
  final double contractValueToken;
  final String nanoId;
  final int score;
  final List<dynamic> auditContributors;
  final String auditState;
  final EthereumAddress auditParticipation;
  Task({
    required this.title,
    required this.description,
    required this.contractOwner,
    required this.jobState,
    required this.contractAddress,
    required this.contributorsCount,
    required this.contributors,
    required this.participiant,
    required this.justLoaded,
    required this.createdTime,
    required this.contractValue,
    required this.contractValueToken,
    required this.nanoId,
    required this.score,
    required this.auditContributors,
    required this.auditState,
    required this.auditParticipation
  });
}
