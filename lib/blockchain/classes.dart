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

class AccountStats {
  final List<EthereumAddress> accountAddresses;
  final List<String> nicknames;
  final List<String> aboutTexts;
  final List<BigInt> ownerTaskCounts;
  final List<BigInt> participantTaskCounts;
  final List<BigInt> auditParticipantTaskCounts;
  final List<BigInt> agreedTaskCounts;
  final List<BigInt> auditAgreedTaskCounts;
  final List<BigInt> completedTaskCounts;
  final List<BigInt> auditCompletedTaskCounts;
  final List<BigInt> avgCustomerRatings;
  final List<BigInt> avgPerformerRatings;
  final BigInt overallAvgCustomerRating;
  final BigInt overallAvgPerformerRating;

  AccountStats({
    required this.accountAddresses,
    required this.nicknames,
    required this.aboutTexts,
    required this.ownerTaskCounts,
    required this.participantTaskCounts,
    required this.auditParticipantTaskCounts,
    required this.agreedTaskCounts,
    required this.auditAgreedTaskCounts,
    required this.completedTaskCounts,
    required this.auditCompletedTaskCounts,
    required this.avgCustomerRatings,
    required this.avgPerformerRatings,
    required this.overallAvgCustomerRating,
    required this.overallAvgPerformerRating,
  });
}

class AccountData {
  final EthereumAddress accountAddress;
  final String nickname;
  final String aboutText;
  final int ownerTaskCount;
  final int participantTaskCount;
  final int completedTaskCount;
  final int avgCustomerRating;
  final int avgPerformerRating;

  AccountData({
    required this.accountAddress,
    required this.nickname,
    required this.aboutText,
    required this.ownerTaskCount,
    required this.participantTaskCount,
    required this.completedTaskCount,
    required this.avgCustomerRating,
    required this.avgPerformerRating,
  });
}

class TaskStats {
  final BigInt countNew;
  final BigInt countAgreed;
  final BigInt countProgress;
  final BigInt countReview;
  final BigInt countCompleted;
  final BigInt countCanceled;
  final BigInt countPrivate;
  final BigInt countPublic;
  final BigInt countHackaton;
  final BigInt avgTaskDuration;
  final BigInt avgPerformerRating;
  final BigInt avgCustomerRating;
  final List<String> topTags;
  final List<BigInt> topTagCounts;
  final List<String> topTokenNames;
  final List<BigInt> topTokenBalances;
  final List<BigInt> topETHBalances;
  final List<BigInt> topETHAmounts;
  final List<BigInt> createTimestamps;
  // final List<BigInt> newTimestamps;
  // final List<BigInt> agreedTimestamps;
  // final List<BigInt> progressTimestamps;
  // final List<BigInt> reviewTimestamps;
  // final List<BigInt> completedTimestamps;
  // final List<BigInt> canceledTimestamps;

  TaskStats(
      {required this.countNew,
      required this.countAgreed,
      required this.countProgress,
      required this.countReview,
      required this.countCompleted,
      required this.countCanceled,
      required this.countPrivate,
      required this.countPublic,
      required this.countHackaton,
      required this.avgTaskDuration,
      required this.avgPerformerRating,
      required this.avgCustomerRating,
      required this.topTags,
      required this.topTagCounts,
      required this.topTokenNames,
      required this.topTokenBalances,
      required this.topETHBalances,
      required this.topETHAmounts,
      required this.createTimestamps
      // required this.newTimestamps,
      // required this.agreedTimestamps,
      // required this.progressTimestamps,
      // required this.reviewTimestamps,
      // required this.completedTimestamps,
      // required this.canceledTimestamps,
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
