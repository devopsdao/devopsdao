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

  final List<EthereumAddress> agreedTasks;
  final List<EthereumAddress> auditAgreed;
  final List<EthereumAddress> completedTasks;

  Account(
      {required this.nickName,
      required this.about,
      required this.walletAddress,
      required this.customerTasks,
      required this.participantTasks,
      required this.auditParticipantTasks,
      required this.customerRating,
      required this.performerRating,

      required this.agreedTasks,
      required this.auditAgreed,
      required this.completedTasks
      });
}
