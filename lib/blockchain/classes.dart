import 'package:webthree/webthree.dart';

class Task {
  final String nanoId;
  final DateTime createTime;
  final String taskType;
  final String title;
  late String description;
  late String repository;
  final List<dynamic> tags;
  final List<dynamic> tagsNFT;
  final List<dynamic> tokenContracts;
  final List<dynamic> tokenIds;
  final List<dynamic> tokenAmounts;
  final String taskState;
  final String auditState;
  final int performerRating;
  final int customerRating;
  final EthereumAddress contractOwner;
  final EthereumAddress performer;
  final EthereumAddress auditInitiator;
  final EthereumAddress auditor;
  final List<dynamic> participants;
  final List<dynamic> funders;
  final List<dynamic> auditors;
  final List<dynamic> messages;
  final EthereumAddress taskAddress;
  final List<dynamic> tokenNames;
  final List<dynamic> tokenBalances;
  late bool loadingIndicator;
  final String transport;

  Task({
    required this.nanoId,
    required this.createTime,
    required this.taskType,
    required this.title,
    required this.description,
    required this.repository,
    required this.tags,
    required this.tagsNFT,
    required this.tokenContracts,
    required this.tokenIds,
    required this.tokenAmounts,
    required this.taskState,
    required this.auditState,
    required this.performerRating,
    required this.customerRating,
    required this.contractOwner,
    required this.performer,
    required this.auditInitiator,
    required this.auditor,
    required this.participants,
    required this.funders,
    required this.auditors,
    required this.messages,
    required this.taskAddress,
    required this.tokenNames,
    required this.tokenBalances,
    required this.loadingIndicator,
    required this.transport,
  });
}

class TokenItem {
  final String name;
  final String? icon;
  final String? type;
  late bool nft;
  late bool inactive;
  late double balance;
  final BigInt? id;
  late bool selected;
  late String feature;
  late bool collection;
  TokenItem(
      {required this.name,
      this.icon,
      this.type = 'myNft',
      this.nft = false,
      this.inactive = false,
      this.balance = 0,
      this.id,
      this.selected = false,
      this.feature = 'Simple',
      required this.collection});
}

class NftCollection {
  late String name;
  late bool selected;
  final Map<BigInt, TokenItem> bunch;
  NftCollection({required this.name, this.selected = false, required this.bunch});
}

class TagsCompare {
  late String state;
  TagsCompare({required this.state});
}

class Token {
  final String name;
  final bool approved;
  Token({required this.name, required this.approved});
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
