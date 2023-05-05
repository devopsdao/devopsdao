import 'package:dodao/blockchain/classes.dart';
import 'package:flutter/cupertino.dart';

class CollectionServices extends ChangeNotifier {
  final NftCollection emptyNftBunch  = NftCollection(name: 'empty', bunch: { BigInt.from(0) : TokenItem(collection: true, name: 'empty', id: BigInt.from(0))});
  final TokenItem emptyTag = TokenItem(collection: true, name: 'empty', id: BigInt.from(0));
  late NftCollection treasuryNftsInfoSelected = emptyNftBunch;
  late TokenItem mintNftTagSelected = emptyTag;
  late bool showMintButton = false;

  Future<void> updateTreasuryNft(NftCollection nft) async {
    treasuryNftsInfoSelected = nft;
    showMintButton = false;
    notifyListeners();
  }

  Future<void> updateMintNft(TokenItem collection) async {
    mintNftTagSelected = collection;
    showMintButton = false;
    notifyListeners();
  }

  Future<void> update() async {
    showMintButton = true;
    notifyListeners();
  }

  Future<void> clearSelectedInManager() async {
    treasuryNftsInfoSelected = emptyNftBunch;
    mintNftTagSelected = emptyTag;
    showMintButton = false;
    notifyListeners();
  }
}
