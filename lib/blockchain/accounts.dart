import 'package:webthree/webthree.dart';

class Account {
  final String nickName;
  final String about;
  final EthereumAddress walletAddress;
  final List<EthereumAddress> customerTasks;
  final List<EthereumAddress> participantTasks;
  final List<EthereumAddress> auditParticipantTasks;
  final List<int> customerRating;
  final List<int> performerRating;

  Account(
      {required this.nickName,
      required this.about,
      required this.walletAddress,
      required this.customerTasks,
      required this.participantTasks,
      required this.auditParticipantTasks,
      required this.customerRating,
      required this.performerRating});
}
