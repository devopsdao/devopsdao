
import 'package:devopsdao/blockchain/classes.dart';
import 'package:flutter/cupertino.dart';


class ManagerServices extends ChangeNotifier {
  late NftTagsBunch treasuryNftsInfoSelected = NftTagsBunch(bunch: [SimpleTags(tag: 'empty')]);
  late SimpleTags mintNftTagSelected = SimpleTags(tag: 'empty');

  Future<void> updateTreasuryNft(NftTagsBunch nft) async {
    treasuryNftsInfoSelected = nft;
    notifyListeners();
  }
  Future<void> updateMintNft(SimpleTags collection) async {
    mintNftTagSelected = collection;
    notifyListeners();
  }
  Future<void> clearSelectedInManager() async {
    treasuryNftsInfoSelected = NftTagsBunch(bunch: [SimpleTags(tag: 'empty')]);
    mintNftTagSelected = SimpleTags(tag: 'empty');
    notifyListeners();
  }
}
