import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:dodao/task_dialog/pages/1_main.dart';
import 'package:dodao/task_dialog/pages/3_selection.dart';
import 'package:dodao/task_dialog/task_transition_effect.dart';
import 'package:dodao/task_dialog/widget/participants_list.dart';
import 'package:dodao/task_dialog/widget/request_audit_alert.dart';
import 'package:dodao/widgets/payment.dart';
import 'package:dodao/widgets/select_menu.dart';
import 'package:dodao/task_dialog/buttons.dart';
import 'package:dodao/task_dialog/states.dart';
import 'package:dodao/widgets/wallet_action_dialog.dart';
import 'package:dodao/task_dialog/widget/dialog_button_widget.dart';
import 'package:dodao/task_dialog/pages/1_main/rate_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../widgets/chat/main.dart';

import '../config/theme.dart';
import '../config/flutter_flow_util.dart';

import 'main.dart';
import 'shimmer.dart';

import 'package:beamer/beamer.dart';

import 'package:flutter/services.dart';

import '../widgets/data_loading_dialog.dart';

import 'dart:ui' as ui;

class TaskDialogBeamer extends StatefulWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  const TaskDialogBeamer({Key? key, this.taskAddress, required this.fromPage}) : super(key: key);

  @override
  _TaskDialogBeamerState createState() => _TaskDialogBeamerState();
}

class _TaskDialogBeamerState extends State<TaskDialogBeamer> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String taskAddressString = widget.taskAddress.toString();
    RouteInformation routeInfo = RouteInformation(location: '/${widget.fromPage}/$taskAddressString');
    Beamer.of(context).updateRouteInformation(routeInfo);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
        child: TaskDialogFuture(fromPage: widget.fromPage, taskAddress: widget.taskAddress!),
      )
    );
  }
}
