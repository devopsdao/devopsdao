// import 'package:js/js.dart';

import 'package:flutter/material.dart';
// import 'Factory.g.dart';
// import 'abi/IERC20.g.dart';

class InterfaceServices extends ChangeNotifier {
  // Payments goes here (create_job_widget.dart -> payment.dart):
  late double tokensEntered = 0.0;

  //  ************ Wallet **************//
  late int pageWalletViewNumber = 0;
  // PageView Controller for wallet/main.dart
  late PageController controller = PageController(initialPage: 0);

  //  ************ task_dialog **************//
  // PageView Controller for task_dialog.dart
  late PageController tasksController = PageController(initialPage: 1);
  late int pageDialogViewNumber = 1; //initial starts from 1 page
  Map<String, int> dialogPages = {
    'topup' : 0,
    'main' : 1,
    'description' : 2,
    'chat' : 3,
  };

  Map<String, String> dialogProcess = {
    'name' : 'custom null',
    'buttonName' : 'custom null',
    'hint' : 'custom null',
  };

  // Input text on task_dialog.dart
  late String taskMessage;

  // Hint message for task_dialog
  // late String messageHint;


  late String whichWalletButtonPressed = '';

  // wallet/main.dart controller for tabs
  // late TabController walletTabController = TabController(length: 2, vsync: );

  // ****** SETTINGS ******** //
// border radius:
  final double borderRadius = 8.0;
}
