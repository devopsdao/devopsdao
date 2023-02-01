import 'package:webthree/webthree.dart';

class Account {
  final String nickName;
  final String about;
  final int rating;
  final EthereumAddress walletAddress;

  Account({
    required this.nickName,
    required this.about,
    required this.walletAddress,
    required this.rating,
  });
}