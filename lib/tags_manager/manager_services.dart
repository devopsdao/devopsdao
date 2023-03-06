
import 'package:devopsdao/blockchain/classes.dart';
import 'package:flutter/cupertino.dart';


class ManagerServices extends ChangeNotifier {
  late NftTagsBunch treasuryNftInfoSelected = NftTagsBunch(bunch: [SimpleTags(tag: 'empty')]);

  Future<void> updateTreasuryNft(NftTagsBunch nft) async {
    treasuryNftInfoSelected = nft;
    notifyListeners();
  }
  Future<void> clearTreasuryNft() async {
    treasuryNftInfoSelected = NftTagsBunch(bunch: [SimpleTags(tag: 'empty')]);
    notifyListeners();
  }
}
