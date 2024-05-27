import 'package:webthree/webthree.dart';

class Account {
  final String nickName;
  final String about;
  final EthereumAddress walletAddress;
  final List<EthereumAddress> customerTasks;
  final List<EthereumAddress> participantTasks;
  final List<EthereumAddress> auditParticipantTasks;
  final List<BigInt> customerRating;
  final List<BigInt> performerRating;

  final List<EthereumAddress> performerAgreedTasks;
  final List<EthereumAddress> customerAgreedTasks;
  final List<EthereumAddress> performerAuditedTasks;
  final List<EthereumAddress> customerAuditedTasks;
  final List<EthereumAddress> auditAgreed;
  final List<EthereumAddress> auditCompleted;
  final List<EthereumAddress> performerCompletedTasks;
  final List<EthereumAddress> customerCompletedTasks;

  Account(
      {required this.nickName,
      required this.about,
      required this.walletAddress,
      required this.customerTasks,
      required this.participantTasks,
      required this.auditParticipantTasks,
      required this.customerRating,
      required this.performerRating,
      required this.performerAgreedTasks,
      required this.customerAgreedTasks,
      required this.performerAuditedTasks,
      required this.customerAuditedTasks,
      required this.auditAgreed,
      required this.auditCompleted,
      required this.performerCompletedTasks,
      required this.customerCompletedTasks});
}
