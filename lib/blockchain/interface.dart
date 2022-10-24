import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'package:js/js.dart';

import 'package:devopsdao/flutter_flow/flutter_flow_util.dart';
import 'package:nanoid/nanoid.dart';
import 'package:throttling/throttling.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import '../custom_widgets/wallet_action.dart';
import 'Factory.g.dart';
import 'IERC20.g.dart';
import 'task.dart';
import 'package:webthree/webthree.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

import '../wallet/ethereum_transaction_tester.dart';
import '../wallet/main.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InterfaceServices extends ChangeNotifier {
  // Payments goes here (create_job_widget.dart -> payment.dart):
  late double tokensEntered = 0.0;

  // PageView Controller for wallet/main.dart
  late PageController controller = PageController(initialPage: 0);
  late int pageWalletViewNumber = 0;
  late String whichWalletButtonPressed = '';

  // ****** SETTINGS ******** //
// border radius:
  final double borderRadius = 8.0;
}
