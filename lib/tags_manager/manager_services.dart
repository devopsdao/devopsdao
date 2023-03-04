
import 'package:devopsdao/blockchain/classes.dart';
import 'package:flutter/cupertino.dart';


class ManagerServices extends ChangeNotifier {
  late NftTagsBunch treasuryNftSelected = NftTagsBunch(bunch: [SimpleTags(tag: 'empty')]);

  Future<void> updateTreasuryNft(NftTagsBunch nft) async {
    treasuryNftSelected = nft;
    notifyListeners();
  }
  Future<void> clearTreasuryNft() async {
    treasuryNftSelected = NftTagsBunch(bunch: [SimpleTags(tag: 'empty')]);
    notifyListeners();
  }
}
