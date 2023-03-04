import '../blockchain/classes.dart';

List<SimpleTags> nftTagsList = [
  SimpleTags(tag: "Javascript", icon: "", nft: true),
  SimpleTags(tag: "Dart", icon: "", nft: true),
  SimpleTags(tag: "Flutter", icon: "", nft: true),
  SimpleTags(tag: "Node.js", icon: "", nft: true),

  SimpleTags(tag: "MongoDb", icon: "", nft: true),
  SimpleTags(tag: "Solidity", icon: "", nft: true),
  SimpleTags(tag: "Solidity", icon: "", nft: true),
  SimpleTags(tag: "Solidity", icon: "", nft: true),
  SimpleTags(tag: "Solidity", icon: "", nft: true),
  SimpleTags(tag: "Solidity", icon: "", nft: true),

  SimpleTags(tag: "Axelar", icon: "", nft: true),
  SimpleTags(tag: "Diamond", icon: "", nft: true),
  SimpleTags(tag: "Web3", icon: "", nft: true),

  SimpleTags(tag: "Moonbase Alpha", icon: "", nft: true),

  SimpleTags(tag: "item 1", icon: "", nft: true),
  SimpleTags(tag: "item 2", icon: "", nft: true),
  SimpleTags(tag: "item 3", icon: "", nft: true),
  SimpleTags(tag: "item 4", icon: "", nft: true),
  SimpleTags(tag: "item 5", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 1", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 2", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 3", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 4", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 5", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 6", icon: "", nft: true),
  SimpleTags(tag: "item Alpha 7", icon: "", nft: true),

  SimpleTags(tag: "Javascript 2", icon: "", nft: true),
  SimpleTags(tag: "Dart 2", icon: "", nft: true),
  SimpleTags(tag: "Flutter 2", icon: "", nft: true),
  SimpleTags(tag: "Node.js 2", icon: "", nft: true),

  SimpleTags(tag: "MongoDb 2", icon: "", nft: true),
  SimpleTags(tag: "Solidity 2", icon: "", nft: true),

  SimpleTags(tag: "Axelar 2", icon: "", nft: true),
  SimpleTags(tag: "Diamond 2", icon: "", nft: true),
  SimpleTags(tag: "Web3 2", icon: "", nft: true),

  SimpleTags(tag: "Moonbase Alpha 3", icon: "", nft: true),

  SimpleTags(tag: "Axelar 3", icon: "", nft: true),
  SimpleTags(tag: "Diamond 4", icon: "", nft: true),
  SimpleTags(tag: "Web3 4", icon: "", nft: true),

  SimpleTags(tag: "Moonbase Alpha 5", icon: "", nft: true) ,

];

// final nftTagsBunch

final Map<String, NftTagsBunch> nftTagsMap = {
  for (var e in nftTagsList) e.tag : NftTagsBunch(bunch: [])
};

void start() {
  nftTagsMap.forEach((key, value) {
    nftTagsMap[key]!.bunch.clear();
    for (SimpleTags value in nftTagsList) {
      if(value.tag == key) {
        nftTagsMap[key]!.bunch.add(value);
      }
    }
  });
}
//
//
// final Map<String, List<SimpleTags>> nftTagsMap = {
//   for (var e in nftTagsList) e.tag : []
// };
