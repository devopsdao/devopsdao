// import 'package:js/js.dart';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

import '../task_dialog/states.dart';
import '../widgets/paw_indicator_with_tasks_list.dart';
import '../widgets/tags/tags_old.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jovial_svg/jovial_svg.dart';

// import 'Factory.g.dart';
// import 'abi/IERC20.g.dart';

class InterfaceServices extends ChangeNotifier {

  late double tokensEntered = 0.0;
  late String tokenSelected = '';


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

  //  *************** Wallet ***************//
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

  // late double boxKeyboardHeight = 0;
  // late double boxKeyboardHeightNoKeyboard = 0;
  // Future updateBoxKeyboardHeight() async {
  //   boxKeyboardHeight = boxKeyboardHeightNoKeyboard;
  //   notifyListeners();
  // }


  late Map<String, dynamic> dialogCurrentState;

  // final GlobalKey<PawRefreshAndTasksListState> indicator = GlobalKey<PawRefreshAndTasksListState>();
  // Future runPaw() async {
  //   indicator.currentState!.runPaw();
  //   // notifyListeners();
  // }

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
  late BuildContext createJobPageContext;

  late String whichWalletButtonPressed = '';

  // wallet/accounts_page.dart controller for tabs
  // late TabController walletTabController = TabController(length: 2, vsync: );

  // ***********  create_job_widget ************ ////
  late PageController pageViewNewTaskController = PageController(initialPage: 0);

  // ***********  Pull request status  *********** //

  late TextSpan statusText = const TextSpan(text: 'Not created', style: TextStyle(fontWeight: FontWeight.bold));

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