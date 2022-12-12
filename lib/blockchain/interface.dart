// import 'package:js/js.dart';

import 'package:flutter/material.dart';

import '../task_dialog/dialog_states.dart';
// import 'Factory.g.dart';
// import 'abi/IERC20.g.dart';

class InterfaceServices extends ChangeNotifier {
  // Payments goes here (create_job_widget.dart -> payment.dart):
  late double tokensEntered = 0.0;


  // ************* Transport Images ****** //
  late Map<String, Widget> transportImages = {
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
    'layerzero' : Image.asset(
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
  // PageView Controller for wallet/main.dart
  late PageController controller = PageController(initialPage: 0);

  //  ************ task_dialog **************//
  // PageView Controller for main.dart
  late PageController dialogPagesController = PageController(initialPage: 1);
  late int dialogPageNum = 0; //initial starts from 1 page
  late Map<String, dynamic> dialogCurrentState;

  // selected Performer or Auditor in participants_list.dart:
  late Map<String, String> selectedUser = {};

  // Input text on main.dart
  late String taskMessage;

  // Hint message for task_dialog
  // late String messageHint;


  // dialog context (for closing it from outside)
  late BuildContext mainDialogContext;


  late String whichWalletButtonPressed = '';

  // wallet/main.dart controller for tabs
  // late TabController walletTabController = TabController(length: 2, vsync: );



  // ***********  create_job_widget ************ ////
  late PageController pageViewNewTaskController = PageController(initialPage: 0);


  // ****** SETTINGS ******** //
  // border radius:
  final double borderRadius = 8.0;
  // -------------------- Sizes for Dialog window ------------------------- //
  final double maxDialogWidth = 600;
  final double maxInternalDialogWidth = 480;
  final double maxGlobalWidth = 1000;

  Future updateDialogPageNum(number) async {
    dialogPageNum = number;
    notifyListeners();
  }
}



