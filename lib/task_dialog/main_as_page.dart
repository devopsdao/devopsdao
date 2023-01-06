import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:devopsdao/task_dialog/pages/4_selection.dart';
import 'package:devopsdao/task_dialog/widget/participants_list.dart';
import 'package:devopsdao/task_dialog/widget/request_audit_alert.dart';
import 'package:devopsdao/widgets/payment.dart';
import 'package:devopsdao/widgets/select_menu.dart';
import 'package:devopsdao/task_dialog/main_page_buttons.dart';
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
import 'package:shimmer/shimmer.dart';
import 'package:webthree/credentials.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../chat/main.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

import 'package:beamer/beamer.dart';

import 'package:flutter/services.dart';

import '../widgets/data_loading_dialog.dart';

import 'dart:ui' as ui;

import 'main.dart';

// class TaskDialogPage extends StatefulWidget {
//   final String fromPage;
//   final EthereumAddress? taskAddress;
//   const TaskDialogPage({Key? key, this.taskAddress, required this.fromPage}) : super(key: key);

//   @override
//   _TaskDialogPage createState() => _TaskDialogPage();
// }

// class _TaskDialogPage extends State<TaskDialogPage> {
//   late Task task;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var tasksServices = context.watch<TasksServices>();
//     if (tasksServices.tasks[widget.taskAddress] != null) {
//       task = tasksServices.tasks[widget.taskAddress]!;
//       return TaskInformationFuture(fromPage: widget.fromPage, taskAddress: widget.taskAddress, shimmerEnabled: false);
//     }
//     return const AppDataLoadingDialogWidget();
//   }
// }

class TaskInformationFuture extends StatefulWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  final bool shimmerEnabled;
  const TaskInformationFuture({
    Key? key,
    required this.fromPage,
    this.taskAddress,
    required this.shimmerEnabled,
  }) : super(key: key);

  @override
  _TaskInformationFutureState createState() => _TaskInformationFutureState();
}

class _TaskInformationFutureState extends State<TaskInformationFuture> {

  String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Task task;
    var interface = context.read<InterfaceServices>();
    var tasksServices = context.read<TasksServices>();

    EthereumAddress? taskAddress = widget.taskAddress;
    return FutureBuilder<Task>(
        future: tasksServices.loadOneTask(taskAddress), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            task = snapshot.data!;
            return TaskInformationPage(fromPage: widget.fromPage, task: task, isLoading: false);
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
          return TaskInformationPage(fromPage: widget.fromPage, task: task, isLoading: true);
        });
  }
}

class TaskInformationPage extends StatefulWidget {
  final String fromPage;
  final Task task;
  final bool isLoading;
  const TaskInformationPage({
    Key? key,
    required this.task,
    required this.fromPage,
    required this.isLoading,
  }) : super(key: key);

  @override
  _TaskInformationPageState createState() => _TaskInformationPageState();
}

class _TaskInformationPageState extends State<TaskInformationPage> {
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

    final double maxDialogWidth = interface.maxDialogWidth;
    final double borderRadius = interface.borderRadius;

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
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(9),
        image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.scaleDown, alignment: Alignment.bottomRight),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return StatefulBuilder(
          builder: (context, setState) {
            // ****** Count Screen size with keyboard and without ***** ///
            final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
            final double screenHeightSizeNoKeyboard = constraints.maxHeight - 70;
            final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;

            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: maxDialogWidth,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: InkWell(
                          onTap: () {
                            interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['main'],
                                duration: const Duration(milliseconds: 400), curve: Curves.ease);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            height: 30,
                            width: 30,
                            child: Consumer<InterfaceServices>(
                              builder: (context, model, child) {
                                late Map<String, int> mapPages = model.dialogCurrentState['pages'];
                                late String page = mapPages.entries.firstWhere((element) => element.value == model.dialogPageNum, orElse: () {
                                  return const MapEntry('main', 0);
                                }).key;
                                return Row(
                                  children: <Widget>[
                                    if (page == 'topup')
                                      const Expanded(
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 30,
                                        ),
                                      ),
                                    if (page.toString() == 'main')
                                      const Expanded(
                                        child: Center(),
                                      ),
                                    if (page == 'description' || page == 'chat' || page == 'select')
                                      const Expanded(
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 30,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                          flex: 10,
                          child: GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RichText(
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.copy,
                                            size: 20,
                                            color: Colors.black26,
                                          ),
                                        )),
                                        TextSpan(
                                          text: task.title,
                                          style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () async {
                              Clipboard.setData(
                                      ClipboardData(text: 'https://dodao.dev/index.html#/${widget.fromPage}/${task.taskAddress.toString()}'))
                                  .then((_) {
                                Flushbar(
                                        icon: const Icon(
                                          Icons.copy,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        message: 'Task URL copied to your clipboard!',
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: Colors.blueAccent,
                                        shouldIconPulse: false)
                                    .show(context);
                              });
                            },
                          )),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          interface.dialogPageNum = interface.dialogCurrentState['pages']['main']; // reset page to *main*
                          interface.selectedUser = {}; // reset
                          Navigator.pop(context);
                          RouteInformation routeInfo = RouteInformation(location: '/${widget.fromPage}');
                          Beamer.of(context).updateRouteInformation(routeInfo);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          height: 30,
                          width: 30,
                          child: Row(
                            children: const <Widget>[
                              Expanded(
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeightSize,
                  // width: constraints.maxWidth * .8,
                  // height: 550,
                  width: maxDialogWidth,

                  child: widget.isLoading == false
                      ? DialogPages(
                          borderRadius: borderRadius,
                          task: task,
                          fromPage: widget.fromPage,
                          topConstraints: constraints,
                          screenHeightSize: screenHeightSize,
                          screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
                        )
                      : ShimmeredTaskPages(
                          borderRadius: borderRadius,
                          task: task,
                        ),
                ),
              ]),
            );
          },
        );
      }),
    );
  }
}

class ShimmeredTaskPages extends StatefulWidget {
  final double borderRadius;
  final Task task;

  const ShimmeredTaskPages({
    Key? key,
    required this.borderRadius,
    required this.task,
  }) : super(key: key);

  @override
  _ShimmeredTaskPagesState createState() => _ShimmeredTaskPagesState();
}

class _ShimmeredTaskPagesState extends State<ShimmeredTaskPages> {
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();

    final double maxInternalWidth = interface.maxInternalDialogWidth;

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerWidth = dialogConstraints.maxWidth - 50;

      return PageView(
        scrollDirection: Axis.horizontal,
        controller: interface.dialogPagesController,
        onPageChanged: (number) {
          Provider.of<InterfaceServices>(context, listen: false).updateDialogPageNum(number);
        },
        children: <Widget>[
          if (interface.dialogCurrentState['pages'].containsKey('main'))
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxInternalWidth,
              ),
              child: Column(
                children: [
                  // const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(height: 62, width: innerWidth, color: Colors.grey[300])),
                  ),
                  // ************ Show prices and topup part ******** //
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(padding: const EdgeInsets.only(top: 14), height: 50, width: innerWidth, color: Colors.grey[300])),
                  ),

                  // ********* Text Input ************ //
                  Shimmer.fromColors(
                      baseColor: Colors.grey[350]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(padding: const EdgeInsets.only(top: 14), height: 70, width: innerWidth, color: Colors.grey[350]))
                ],
              ),
            ),
        ],
      );
    });
  }
}
