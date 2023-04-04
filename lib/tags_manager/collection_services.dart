import 'package:dodao/blockchain/classes.dart';
import 'package:flutter/cupertino.dart';

class CollectionServices extends ChangeNotifier {
  final NftTagsBunch emptyNftBunch  = NftTagsBunch(name: 'empty', bunch: { BigInt.from(0) : SimpleTags(collection: true, name: 'empty', id: BigInt.from(0))});
  final SimpleTags emptyTag = SimpleTags(collection: true, name: 'empty', id: BigInt.from(0));
  late NftTagsBunch treasuryNftsInfoSelected = emptyNftBunch;
  late SimpleTags mintNftTagSelected = emptyTag;
  late bool showMintButton = false;

  Future<void> updateTreasuryNft(NftTagsBunch nft) async {
    treasuryNftsInfoSelected = nft;
    showMintButton = false;
    notifyListeners();
  }

  Future<void> updateMintNft(SimpleTags collection) async {
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
