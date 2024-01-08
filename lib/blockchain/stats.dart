import 'package:webthree/webthree.dart';

class Stats {
  final String nickName;
  final String about;
  final EthereumAddress walletAddress;
  final List<EthereumAddress> customerTasks;
  final List<EthereumAddress> participantTasks;
  final List<EthereumAddress> auditParticipantTasks;
  final int performerRating;
  final int customerRating;

  Stats(
      {required this.nickName,
      required this.about,
      required this.walletAddress,
      required this.customerTasks,
      required this.participantTasks,
      required this.auditParticipantTasks,
      required this.performerRating,
      required this.customerRating});
}
