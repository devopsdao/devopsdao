// import 'package:js/js.dart';

import 'package:flutter/material.dart';

import '../task_dialog/states.dart';
import '../widgets/tags/tags_old.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jovial_svg/jovial_svg.dart';

// import 'Factory.g.dart';
// import 'abi/IERC20.g.dart';

class InterfaceServices extends ChangeNotifier {
  // Payments goes here (create_job.dart.old -> payment.dart):
  late double tokensEntered = 0.0;

  // ************* Transport Images ****** //
  late Map<String, Widget> interchainImages = {
    'hyperlane': Image.asset(
      'assets/images/hyperlane.png',
      height: 36,
      filterQuality: FilterQuality.medium,
    ),
    'axelar': Image.asset(
      'assets/images/Axelar-Logo-Update.png',
      height: 34,
      filterQuality: FilterQuality.medium,
    ),
    'layerzero': Image.asset(
      'assets/images/LayerZero.png',
      height: 44,
      filterQuality: FilterQuality.medium,
      isAntiAlias: true,
    ),
    'wormhole': Image.asset(
      'assets/images/worm.png',
      height: 34,
      filterQuality: FilterQuality.medium,
    )
  };

  //  ************ Wallet **************//
  late int pageWalletViewNumber = 0;
  // PageView Controller for wallet/accounts_page.dart
  late PageController controller = PageController(initialPage: 0);

  //  ************ accounts_dialog **************//
  late PageController accountsDialogPagesController = PageController(initialPage: 0);
  late int accountsDialogPageNum = 0;
  Future updateAccountsDialogPageNum(number) async {
    accountsDialogPageNum = number;
    notifyListeners();
  }

  //  ************ task_dialog **************//
  // PageView Controller for accounts_page.dart
  late PageController dialogPagesController = PageController(initialPage: 1);
  late int dialogPageNum = 0; //initial starts from 1 page
  Future updateDialogPageNum(number) async {
    dialogPageNum = number;
    notifyListeners();
  }

  late Map<String, dynamic> dialogCurrentState;

  // selected Performer or Auditor in participants_list.dart:
  late Map<String, String> selectedUser = {};
  // participants_list.dart & 3_selection.dart & auditor
  final double tileHeight = 34;
  final double heightForInfo = 140;

  // Input text on accounts_page.dart
  late String taskMessage = '';
  late String taskTopupMessage = '';
  Future emptyTaskMessage() async {
    taskMessage = '';
    taskTopupMessage = '';
  }

  // Hint message for task_dialog
  // late String messageHint;

  // dialog context (for closing it from outside)
  late BuildContext mainDialogContext;

  late String whichWalletButtonPressed = '';

  // wallet/accounts_page.dart controller for tabs
  // late TabController walletTabController = TabController(length: 2, vsync: );

  // ***********  create_job_widget ************ ////
  late PageController pageViewNewTaskController = PageController(initialPage: 0);

  // ***********  Pull request status  *********** //

  late TextSpan statusText = const TextSpan(text: 'Not created', style: TextStyle(fontWeight: FontWeight.bold));

  // ***********  tags  ************ ////
  // late List<SimpleTags> tempTagsList = [
  //   SimpleTags(collection: true, tag: "Dart", icon: "", nft: true),
  //   SimpleTags(collection: true, tag: "Flutter", icon: "", nft: true),
  //   SimpleTags(collection: true, tag: "Solidity", icon: "", nft: true),
  //   SimpleTags(collection: true, tag: "Diamond", icon: "", nft: true),
  //   SimpleTags(collection: true, tag: "Web3", icon: "", nft: true),
  // ];
  // late List<SimpleTags> tempTagsListForTask = [
  //   SimpleTags(collection: true, tag: "Dart", icon: "", nft: true),
  //   SimpleTags(collection: true, tag: "Solidity", icon: ""),
  //   SimpleTags(collection: true, tag: "Flutter", icon: "", nft: true),
  //   SimpleTags(collection: true, tag: "Diamond", icon: ""),
  //   SimpleTags(collection: true, tag: "Web3", icon: ""),
  // ];
  // late List<SimpleTags> auditorTagsList = [];
  // late List<SimpleTags> tasksTagsList = [];
  // late List<SimpleTags> customerTagsList = [];
  // late List<SimpleTags> performerTagsList = [];
  // late List<SimpleTags> createTagsList = [];
  // Future updateTagList(list, {required String page}) async {
  //   if (page == 'auditor') {
  //     auditorTagsList = list;
  //   } else if (page == 'tasks') {
  //     tasksTagsList = list;
  //   } else if (page == 'customer') {
  //     customerTagsList = list;
  //   } else if (page == 'performer') {
  //     performerTagsList = list;
  //   } else if (page == 'create') {
  //     createTagsList = list;
  //   }
  //   notifyListeners();
  // }
  //
  // Future removeTag(tagName, {required String page}) async {
  //   if (page == 'auditor') {
  //     auditorTagsList.removeWhere((item) => item.tag == tagName);
  //   } else if (page == 'tasks') {
  //     tasksTagsList.removeWhere((item) => item.tag == tagName);
  //   } else if (page == 'customer') {
  //     customerTagsList.removeWhere((item) => item.tag == tagName);
  //   } else if (page == 'performer') {
  //     performerTagsList.removeWhere((item) => item.tag == tagName);
  //   } else if (page == 'create') {
  //     createTagsList.removeWhere((item) => item.tag == tagName);
  //   }
  //   notifyListeners();
  // }

  // **** manager treasury pageCount (to avoid screen freezing on animation)
  late int treasuryPageCount = 1;
  Future treasuryPageCountUpdate(number) async {
    treasuryPageCount = number;
    notifyListeners();
  }


  // ****** SETTINGS ******** //
  // border radius:
  final double borderRadius = 8.0;
  // -------------------- Sizes for Dialog window ------------------------- //
  final double maxStaticDialogWidth = 600;
  final double maxStaticInternalDialogWidth = 480;
  final double maxStaticGlobalWidth = 1000;
}


// class TagsValueController extends ValueNotifier{
//   TagsValueController(List<SimpleTags>super.value);
//
//   void addTag(SimpleTags val) {
//     value.add(val);
//     print(value.first.tag);
//     notifyListeners();
//   }
// }