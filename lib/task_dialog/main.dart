import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:devopsdao/task_dialog/pages.dart';
import 'package:devopsdao/task_dialog/pages/1_main.dart';
import 'package:devopsdao/task_dialog/pages/3_selection.dart';
import 'package:devopsdao/task_dialog/task_transition_effect.dart';
import 'package:devopsdao/task_dialog/widget/participants_list.dart';
import 'package:devopsdao/task_dialog/widget/request_audit_alert.dart';
import 'package:devopsdao/widgets/payment.dart';
import 'package:devopsdao/widgets/select_menu.dart';
import 'package:devopsdao/task_dialog/buttons.dart';
import 'package:devopsdao/task_dialog/states.dart';
import 'package:devopsdao/widgets/wallet_action.dart';
import 'package:devopsdao/task_dialog/widget/dialog_button_widget.dart';
import 'package:devopsdao/task_dialog/widget/rate_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../chat/main.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

import 'header.dart';
import 'shimmer.dart';

import 'package:beamer/beamer.dart';

import 'package:flutter/services.dart';

import '../widgets/data_loading_dialog.dart';

import 'dart:ui' as ui;

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, chat)

class TaskDialogFuture extends StatefulWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  final bool shimmerEnabled;
  const TaskDialogFuture({
    Key? key,
    required this.fromPage,
    this.taskAddress,
    required this.shimmerEnabled,
  }) : super(key: key);

  @override
  _TaskDialogFutureState createState() => _TaskDialogFutureState();
}

class _TaskDialogFutureState extends State<TaskDialogFuture> {

  String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Task task;
    var tasksServices = context.read<TasksServices>();

    EthereumAddress? taskAddress = widget.taskAddress;
    return FutureBuilder<Task>(
        future: tasksServices.loadOneTask(taskAddress), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            task = snapshot.data!;
            return TaskDialogSkeleton(fromPage: widget.fromPage, task: task, isLoading: false);
          }
          task = Task(
              nanoId: '111',
              createTime: DateTime.now(),
              taskType: 'task[2]',
              title: 'Loading...',
              description: 'Loading...',
              symbol: 'none',
              taskState: 'empty',
              auditState: '',
              rating: 0,
              contractOwner: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              participant: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              auditInitiator: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              auditor: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              participants: [],
              funders: [],
              auditors: [],
              messages: [],
              taskAddress: EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'),
              justLoaded: true,
              contractValue: 0,
              contractValueToken: 0,
              transport: '');
          return TaskDialogSkeleton(fromPage: widget.fromPage, task: task, isLoading: true);
        });
  }
}

class TaskDialogSkeleton extends StatefulWidget {
  final String fromPage;
  final Task task;
  final bool isLoading;
  const TaskDialogSkeleton({
    Key? key,
    required this.task,
    required this.fromPage,
    required this.isLoading,
  }) : super(key: key);

  @override
  _TaskDialogSkeletonState createState() => _TaskDialogSkeletonState();
}

class _TaskDialogSkeletonState extends State<TaskDialogSkeleton> {
  String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    var tasksServices = context.read<TasksServices>();

    final task = widget.task;

    String fromPage = widget.fromPage;

    final double maxStaticDialogWidth = interface.maxStaticDialogWidth;

    if (widget.fromPage == 'customer') {
      backgroundPicture = "assets/images/cross.png";
    } else if (widget.fromPage == 'performer') {
      backgroundPicture = "assets/images/cyrcle.png";
    } else if (widget.fromPage == 'audit') {
      backgroundPicture = "assets/images/cross.png";
    }

    if (task.taskState == 'empty') {
      interface.dialogCurrentState = dialogStates['empty'];
    } else if (fromPage == 'tasks' && tasksServices.publicAddress == null && !tasksServices.validChainID) {
      interface.dialogCurrentState = dialogStates['tasks-new-not-logged'];
    } else if (fromPage == 'tasks' && tasksServices.publicAddress != null && tasksServices.validChainID) {
      interface.dialogCurrentState = dialogStates['tasks-new-logged'];
    } else if (fromPage == 'customer' && task.taskState == 'new') {
      interface.dialogCurrentState = dialogStates['customer-new'];
    } else if (fromPage == 'performer' && task.taskState == 'new') {
      interface.dialogCurrentState = dialogStates['performer-new'];
    } else if (task.taskState == 'agreed' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-agreed'];
    } else if (task.taskState == 'progress' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-progress'];
    } else if (task.taskState == 'review' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-review'];
    } else if (task.taskState == 'completed' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-completed'];
    } else if (task.taskState == 'canceled' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-canceled'];
    } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-audit-requested'];
    } else if ((task.taskState == 'audit' && task.auditState == 'performing') && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-audit-performing'];
    } else if (task.taskState == 'agreed' && fromPage == 'performer') {
      interface.dialogCurrentState = dialogStates['performer-agreed'];
    } else if (task.taskState == 'progress' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-progress'];
    } else if (task.taskState == 'review' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-review'];
    } else if (task.taskState == 'completed' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-completed'];
    } else if (task.taskState == 'canceled' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-canceled'];
    } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-audit-requested'];
    } else if ((task.taskState == 'audit' && task.auditState == 'performing') && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-audit-performing'];
    } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      if (task.auditors.isNotEmpty) {
        for (var i = 0; i < task.auditors.length; i++) {
          if (task.auditors[i] == tasksServices.publicAddress) {
            interface.dialogCurrentState = dialogStates['auditor-applied'];
            break;
          } else {
            interface.dialogCurrentState = dialogStates['auditor-new'];
          }
        }
      } else {
        interface.dialogCurrentState = dialogStates['auditor-new'];
      }
    } else if ((task.taskState == 'audit' && task.auditState == 'performing') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['auditor-performing'];
    } else if ((task.taskState == 'audit' && task.auditState == 'finished') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      // taskState = audit & auditState = finished - will not fires anyway. Should be deleted
      interface.dialogCurrentState = dialogStates['auditor-finished'];
    } else if ((task.taskState == 'completed' && task.auditState == 'finished') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['auditor-finished'];
    }

    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.scaleDown, alignment: Alignment.bottomRight),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // ****** Count Screen size with keyboard and without ***** ///
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
        final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
        final statusBarHeight = MediaQuery.of(context).viewPadding.top;
        return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          Container(
            height: statusBarHeight,
          ),
          TaskDialogHeader(
            maxStaticDialogWidth: maxStaticDialogWidth,
            task: task,
            fromPage: fromPage,),
          SizedBox(
            height: screenHeightSize - statusBarHeight,
            // width: constraints.maxWidth * .8,
            // height: 550,
            width: maxStaticDialogWidth,

            child: widget.isLoading == false
                ? TaskDialogPages(
              task: task,
              fromPage: widget.fromPage,
              screenHeightSize: screenHeightSize,
              screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard - statusBarHeight,
            )
                : ShimmeredTaskPages(
              task: task,
            ),
          ),
        ]);
      }),
    );
  }
}