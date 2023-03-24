import 'package:dodao/blockchain/classes.dart';
import 'package:flutter/cupertino.dart';

class ManagerServices extends ChangeNotifier {
  late NftTagsBunch treasuryNftsInfoSelected = NftTagsBunch(tag: 'empty', bunch: [SimpleTags(collection: true, tag: 'empty')]);
  late SimpleTags mintNftTagSelected = SimpleTags(collection: true, tag: 'empty');

  Future<void> updateTreasuryNft(NftTagsBunch nft) async {
    treasuryNftsInfoSelected = nft;
    notifyListeners();
  }

  Future<void> updateMintNft(SimpleTags collection) async {
    mintNftTagSelected = collection;
    notifyListeners();
  }

  Future<void> clearSelectedInManager() async {
    treasuryNftsInfoSelected = NftTagsBunch(tag: 'empty', bunch: [SimpleTags(collection: true, tag: 'empty')]);
    mintNftTagSelected = SimpleTags(collection: true, tag: 'empty');
    notifyListeners();
  }
}
