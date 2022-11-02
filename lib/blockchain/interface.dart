// import 'package:js/js.dart';

import 'package:flutter/material.dart';
// import 'Factory.g.dart';
// import 'abi/IERC20.g.dart';

class InterfaceServices extends ChangeNotifier {
  // Payments goes here (create_job_widget.dart -> payment.dart):
  late double tokensEntered = 0.0;

  // PageView Controller for wallet/main.dart
  late PageController controller = PageController(initialPage: 0);
  // PageView Controller for task_dialog.dart
  late PageController TasksController = PageController(initialPage: 0);

  // Input text on task_dialog.dart
  late String messageForStateController;

  late int pageWalletViewNumber = 0;
  late String whichWalletButtonPressed = '';

  // wallet/main.dart controller for tabs
  // late TabController walletTabController = TabController(length: 2, vsync: );

  // ****** SETTINGS ******** //
// border radius:
  final double borderRadius = 8.0;
}
