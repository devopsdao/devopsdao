import 'package:web3dart/web3dart.dart';

class Task {
  // final int id;
  final String title;
  final String description;
  final EthereumAddress contractOwner;
  final String jobState;
  final EthereumAddress contractAddress;
  final int contributorsCount;
  final List<dynamic> contributors;
  final EthereumAddress participiant;
  final int contractValue;
  Task({
    // required this.id,
    required this.title,
    required this.description,
    required this.contractOwner,
    required this.jobState,
    required this.contractAddress,
    required this.contributorsCount,
    required this.contributors,
    required this.participiant,
    required this.contractValue,
  });
}
