import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:devopsdao/task_dialog/pages/4_selection.dart';
import 'package:devopsdao/task_dialog/widget/participants_list.dart';
import 'package:devopsdao/task_dialog/widget/request_audit_alert.dart';
import 'package:devopsdao/widgets/payment.dart';
import 'package:devopsdao/widgets/select_menu.dart';
import 'package:devopsdao/task_dialog/main_page_buttons.dart';
import 'package:devopsdao/task_dialog/dialog_states.dart';
import 'package:devopsdao/widgets/wallet_action.dart';
import 'package:devopsdao/task_dialog/widget/dialog_button_widget.dart';
import 'package:devopsdao/task_dialog/widget/rate_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:provider/provider.dart';
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

class TaskDialog extends StatefulWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  const TaskDialog({Key? key, this.taskAddress, required this.fromPage}) : super(key: key);

  @override
  _TaskDialog createState() => _TaskDialog();
}

class _TaskDialog extends State<TaskDialog> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    if (tasksServices.tasks[widget.taskAddress] != null) {
      task = tasksServices.tasks[widget.taskAddress]!;
      print('taskAddress: ${widget.taskAddress}');
      print('fromPage: ${widget.fromPage}');
      return TaskInformationDialog(fromPage: widget.fromPage, taskAddress: widget.taskAddress, shimmerEnabled: false);
    }
    // return TaskInformationDialog(
    //     fromPage: widget.fromPage, task: task, shimmerEnabled: true);

    return const AppDataLoadingDialogWidget();
  }
}

class TaskInformationDialog extends StatefulWidget {
  // final int taskCount;
  final String fromPage;
  // final Task task;
  final EthereumAddress? taskAddress;
  final bool shimmerEnabled;
  const TaskInformationDialog({
    Key? key,
    // required this.taskCount,
    required this.fromPage,
    this.taskAddress,
    // required this.task,
    required this.shimmerEnabled,
  }) : super(key: key);

  @override
  _TaskInformationDialogState createState() => _TaskInformationDialogState();
}

class _TaskInformationDialogState extends State<TaskInformationDialog> {
  late Task task;
  int backButtonShowIcon = 1;
  String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;
  late bool initDone;

  @override
  void initState() {
    super.initState();
    initDone = true;
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    // Task task = widget.task;
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

    EthereumAddress? taskAddress = widget.taskAddress;
    return FutureBuilder<Task> (
        future: tasksServices.getTask(taskAddress), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            task = snapshot.data!;
          } else {
            task = Task(
              nanoId: '111',
              createTime: DateTime.now(),
              taskType: 'task[2]',
              title: 'Loading...',
              description: 'Loading...',
              symbol: 'none',
              taskState: 'new',
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
            );
          }

          if (fromPage == 'tasks' && tasksServices.publicAddress == null && !tasksServices.validChainID) {
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
          } else if ((task.taskState == 'audit' && task.auditState == 'requested') &&
              (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
            interface.dialogCurrentState = dialogStates['customer-audit-requested'];
          } else if ((task.taskState == 'audit' && task.auditState == 'performing') &&
              (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
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
          } else if ((task.taskState == 'audit' && task.auditState == 'requested') &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
            interface.dialogCurrentState = dialogStates['performer-audit-requested'];
          } else if ((task.taskState == 'audit' && task.auditState == 'performing') &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
            interface.dialogCurrentState = dialogStates['performer-audit-performing'];
          } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
            if (task.auditors.isNotEmpty) {
              for (var i = 0; i < task.auditors.length; i++) {
                if (task.auditors[i] == tasksServices.publicAddress) {
                  interface.dialogCurrentState = dialogStates['auditor-applied'];
                } else {
                  interface.dialogCurrentState = dialogStates['auditor-new'];
                }
              }
            } else {
              interface.dialogCurrentState = dialogStates['auditor-new'];
            }
          } else if ((task.taskState == 'audit' && task.auditState == 'performing') &&
              (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
            interface.dialogCurrentState = dialogStates['auditor-performing'];
          } else if ((task.taskState == 'audit' && task.auditState == 'finished') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
            // taskState = audit & auditState = finished - will not fires anyway. Should be deleted
            interface.dialogCurrentState = dialogStates['auditor-finished'];
          } else if ((task.taskState == 'completed' && task.auditState == 'finished') &&
              (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
            interface.dialogCurrentState = dialogStates['auditor-finished'];
          }

          // init first page in dialog:
          if (interface.dialogCurrentState['pages']['main'] != null && initDone == true) {
            initDone = false;
            interface.dialogPageNum = interface.dialogCurrentState['pages']['main'];
            interface.dialogPagesController = PageController(initialPage: interface.dialogCurrentState['pages']['main']);
            // print(interface.dialogCurrentState['pages']['main']);
          }

          // else {
          //   print('Initial page in dialog not set! Default is 0');
          //   interface.dialogPageNum = 0;
          //   interface.dialogPagesController = PageController(initialPage: 0);
          // }

          bool shimmerEnabled = widget.shimmerEnabled;
          Widget child;
          child = LayoutBuilder(builder: (context, constraints) {
            // print('max:  ${constraints.maxHeight}');
            // print('max * : ${constraints.maxHeight * .65}');
            // print(constraints.minWidth);
            return StatefulBuilder(
              builder: (context, setState) {
                // ****** Count Screen size with keyboard and without ***** ///
                final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
                final double screenHeightSizeNoKeyboard = constraints.maxHeight - 120;
                // < 400 ? 330
                // : constraints.maxHeight - 140;
                final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;

                return WillPopScope(
                  onWillPop: () async => false,
                  child: Dialog(
                    insetPadding: const EdgeInsets.all(20),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: SingleChildScrollView(
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
                                      builder: (context, intfc, child) {
                                        late String page = intfc.dialogCurrentState['pages'].entries
                                            .firstWhere((element) => element.value == intfc.dialogPageNum)
                                            .key;
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
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(const SnackBar(
                                        //         content: Text(
                                        //             'Copied to your clipboard !')));
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
                                  // print(widget.fromPage);
                                  // context.beamToNamed('/${widget.fromPage}');
                                  // context.beamBack();
                                  // interface.dialogPageNum = interface.dialogPages['main'] ?? 0; // reset page to *main*
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
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(6),
                                  // ),
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
                        Container(
                          height: screenHeightSize,
                          // width: constraints.maxWidth * .8,
                          // height: 550,
                          width: maxDialogWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            image: DecorationImage(
                              image: AssetImage(backgroundPicture),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: DialogPages(
                            borderRadius: borderRadius,
                            task: task,
                            fromPage: widget.fromPage,
                            topConstraints: constraints,
                            shimmerEnabled: shimmerEnabled,
                            screenHeightSize: screenHeightSize,
                            screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              },
            );
          });
          return child;
        });
  }
}

class DialogPages extends StatefulWidget {
  // final String buttonName;
  final double borderRadius;
  final Task task;
  final String fromPage;
  final BoxConstraints topConstraints;
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;
  bool shimmerEnabled;

  DialogPages({
    Key? key,
    // required this.buttonName,
    required this.borderRadius,
    required this.task,
    required this.fromPage,
    required this.topConstraints,
    required this.shimmerEnabled,
    required this.screenHeightSize,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  @override
  _DialogPagesState createState() => _DialogPagesState();
}

class _DialogPagesState extends State<DialogPages> {
  bool enableRatingButton = false;
  double ratingScore = 0;

  TextEditingController? messageForStateController;

  @override
  void initState() {
    super.initState();
    messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    // Don't forget to dispose all of your controllers!
    messageForStateController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    // final Map<String, dynamic> dialogState = widget.dialogState;
    final double maxInternalWidth = interface.maxInternalDialogWidth;

    interface.taskMessage = messageForStateController!.text;

    Task task = widget.task;
    String fromPage = widget.fromPage;
    bool shimmerEnabled = widget.shimmerEnabled;

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerWidth = dialogConstraints.maxWidth - 50;
      // print (dialogConstraints.maxWidth);

      return PageView(
        scrollDirection: Axis.horizontal,
        // pageSnapping: false,
        // physics: ((
        //   fromPage == 'tasks' ||
        //   fromPage == 'auditor' ||
        //   fromPage == 'performer') &&
        //   interface.dialogPageNum == 1)
        //     ? const RightBlockedScrollPhysics() : null,
        // physics: BouncingScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        controller: interface.dialogPagesController,
        onPageChanged: (number) {
          // interface.dialogPageNum = number;
          // tasksServices.myNotifyListeners();
          Provider.of<InterfaceServices>(context, listen: false).updateDialogPageNum(number);
        },
        children: <Widget>[
          // GestureDetector(
          //   child: RiveAnimation.file(
          //     'assets/rive_animations/rating_animation.riv',
          //     fit: BoxFit.fitWidth,
          //     onInit: _onRiveInit,
          //   ),
          //   onTap: _hitBump,
          // ),
          // Shimmer.fromColors(
          //   baseColor: Colors.grey[300]!,
          //   highlightColor: Colors.grey[100]!,
          //   enabled: shimmerEnabled,
          //   child:
          if (interface.dialogCurrentState['pages'].containsKey('topup'))
            Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxInternalWidth,
                    maxHeight: widget.screenHeightSizeNoKeyboard,
                    // maxHeight: widget.screenHeightSize
                  ),
                  child: Column(
                    children: [
                      Payment(purpose: 'topup', innerWidth: innerWidth, borderRadius: widget.borderRadius),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
                        width: innerWidth + 8,
                        child: Row(
                          // direction: Axis.horizontal,
                          // crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            TaskDialogButton(
                              // padding: 8.0,
                              inactive: interface.tokensEntered == 0.0 ? true : false,
                              buttonName: 'Topup contract',
                              buttonColorRequired: Colors.lightBlue.shade600,
                              callback: () {
                                tasksServices.addTokens(
                                  task.taskAddress,
                                  interface.tokensEntered, task.nanoId,
                                  // message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                                );
                                Navigator.pop(context);

                                showDialog(
                                    context: context,
                                    builder: (context) => WalletAction(
                                      nanoId: task.nanoId,
                                      taskName: 'addTokens',
                                    ));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          if (interface.dialogCurrentState['pages'].containsKey('main'))
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxInternalWidth,
                ),
                child: Column(
                  children: [
                    // const SizedBox(height: 50),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: GestureDetector(
                        onTap: () {
                          interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                              duration: const Duration(milliseconds: 300), curve: Curves.ease);
                          tasksServices.myNotifyListeners();
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.width * .08,
                          // width: MediaQuery.of(context).size.width * .57
                          width: innerWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                          ),
                          child: LayoutBuilder(builder: (context, constraints) {
                            final text = TextSpan(
                              text: task.description,
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                            );
                            final textHeight = TextPainter(text: text, maxLines: 3, textDirection: ui.TextDirection.ltr);
                            final oneLineHeight = TextPainter(text: text, maxLines: 1, textDirection: ui.TextDirection.ltr);
                            textHeight.layout(maxWidth: constraints.maxWidth);
                            oneLineHeight.layout(maxWidth: constraints.maxWidth);
                            final numLines = textHeight.computeLineMetrics().length;

                            // final textHeight =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
                            // textHeight.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width
                            // print(tp.didExceedMaxLines);
                            return LimitedBox(
                              maxHeight: textHeight.didExceedMaxLines ? textHeight.height + 26 : (oneLineHeight.height * 3) + 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(3.0, 0.0, 8.0, 0.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: Container(
                                              padding: const EdgeInsets.all(6.0),
                                              // padding: const EdgeInsets.all(3),
                                              child: RichText(maxLines: 3, text: text)),
                                        ),
                                        // TaskDialogButton(
                                        //   padding: 6.0,
                                        //   inactive: false,
                                        //
                                        //   buttonName: 'Up',
                                        //   buttonColorRequired: Colors.lightBlue.shade600,
                                        //   callback: () {
                                        //     Provider.of<InterfaceServices>(context, listen: false).updateDialogPageNum(6);
                                        //   },
                                        // ),

                                        Container(
                                          width: 54,
                                          padding: const EdgeInsets.all(4.0),
                                          child: Material(
                                            elevation: 9,
                                            borderRadius: BorderRadius.circular(6),
                                            color: Colors.lightBlue.shade600,
                                            child: InkWell(
                                              onTap: () {
                                                interface.dialogPagesController.animateToPage(
                                                    interface.dialogCurrentState['pages']['description'] ?? 99,
                                                    duration: const Duration(milliseconds: 400),
                                                    curve: Curves.ease);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(6.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Icon(Icons.info_outline_rounded, size: 22, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   width: ,
                                        // ),
                                        if (interface.dialogCurrentState['pages'].containsKey('chat'))
                                          Container(
                                            width: 54,
                                            padding: const EdgeInsets.all(4.0),
                                            child: Material(
                                              elevation: 9,
                                              borderRadius: BorderRadius.circular(6),
                                              color: Colors.lightBlue.shade600,
                                              child: InkWell(
                                                onTap: () {
                                                  interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['chat'] ?? 99,
                                                      duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(6.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Icon(Icons.chat_outlined, size: 22, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (textHeight.didExceedMaxLines)
                                    Container(
                                        alignment: Alignment.center,
                                        height: 14,
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue.shade600,
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(8.0),
                                            bottomLeft: Radius.circular(8.0),
                                          ),
                                          // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                        ),
                                        child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Read more ',
                                                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.8, color: Colors.white),
                                                ),
                                                const WidgetSpan(
                                                  child: Icon(Icons.forward, size: 13, color: Colors.white),
                                                ),
                                              ],
                                            ))),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 14),

                    // if (
                    //   interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
                    //   interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                    //   interface.dialogCurrentState['name'] == 'customer-audit-performing' ||
                    //   interface.dialogCurrentState['name'] == 'performer-audit-performing' ||
                    //   tasksServices.hardhatDebug == true
                    // )
                    //
                    // // if (task.taskState == "audit" &&
                    // //     (fromPage == 'customer' || fromPage == 'performer' ||
                    // //         tasksServices.hardhatDebug == true))
                    //
                    //   Container(
                    //     padding: const EdgeInsets.only(top: 14.0),
                    //     child: Material(
                    //       elevation: 10,
                    //       borderRadius: BorderRadius.circular(widget.borderRadius),
                    //       child: Container(
                    //           width: innerWidth,
                    //           decoration: BoxDecoration(
                    //             borderRadius:
                    //             BorderRadius.circular(widget.borderRadius),
                    //           ),
                    //           child: Column(
                    //             children: [
                    //               if (
                    //               interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
                    //               interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                    //               tasksServices.hardhatDebug == true
                    //               )
                    //                 Container(
                    //                   alignment: Alignment.topLeft,
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: RichText(
                    //                       text: TextSpan(
                    //                           style: DefaultTextStyle.of(context)
                    //                               .style
                    //                               .apply(fontSizeFactor: 1.0),
                    //                           children: const <TextSpan>[
                    //                             TextSpan(
                    //                                 text:
                    //                                 'Warning, this contract on Audit state \n'
                    //                                     'Please choose auditor: ',
                    //                                 style: TextStyle(
                    //                                     height: 2,
                    //                                     fontWeight: FontWeight.bold)),
                    //                           ])),
                    //                 ),
                    //               if (
                    //               interface.dialogCurrentState['name'] == 'customer-audit-performing' ||
                    //               interface.dialogCurrentState['name'] == 'performer-audit-performing' ||
                    //               tasksServices.hardhatDebug == true
                    //               )
                    //                 Container(
                    //                   alignment: Alignment.topLeft,
                    //                   padding: const EdgeInsets.all(8.0),
                    //                   child: RichText(
                    //                       text: TextSpan(
                    //                           style: DefaultTextStyle.of(context)
                    //                               .style
                    //                               .apply(fontSizeFactor: 1.0),
                    //                           children: <TextSpan>[
                    //                             const TextSpan(
                    //                                 text: 'Your request is being resolved \n'
                    //                                     'Your auditor: \n',
                    //                                 style: TextStyle(
                    //                                     height: 2,
                    //                                     fontWeight: FontWeight.bold)),
                    //                             TextSpan(
                    //                                 text: task.auditor.toString(),
                    //                                 style: DefaultTextStyle.of(context)
                    //                                     .style
                    //                                     .apply(fontSizeFactor: 0.7))
                    //                           ])),
                    //                 ),
                    //               // if (  task.auditState == "requested" ||
                    //               //         tasksServices.hardhatDebug == true)
                    //               //   Container(
                    //               //     alignment: Alignment.topLeft,
                    //               //     padding: const EdgeInsets.all(8.0),
                    //               //     child: ParticipantList(
                    //               //       listType: 'audit',
                    //               //       obj: task,
                    //               //     ),
                    //               //   ),
                    //             ],
                    //           )
                    //       ),
                    //     ),
                    //   ),

                    if (interface.dialogCurrentState['name'] == 'customer-completed' || tasksServices.hardhatDebug == true)
                      Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                              width: innerWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(widget.borderRadius),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                        text:
                                        TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: const <TextSpan>[
                                          TextSpan(text: 'Rate the task:', style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                        ])),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: const [
                                      // RatingBar.builder(
                                      //   initialRating: 4,
                                      //   minRating: 1,
                                      //   direction: Axis.horizontal,
                                      //   allowHalfRating: true,
                                      //   itemCount: 5,
                                      //   itemPadding: const EdgeInsets.symmetric(
                                      //       horizontal: 5.0),
                                      //   itemBuilder: (context, _) => const Icon(
                                      //     Icons.star,
                                      //     color: Colors.amber,
                                      //   ),
                                      //   itemSize: 30.0,
                                      //   onRatingUpdate: (rating) {
                                      //     setState(() {
                                      //       enableRatingButton = true;
                                      //     });
                                      //     ratingScore = rating;
                                      //     tasksServices.myNotifyListeners();
                                      //   },
                                      // ),
                                      RateAnimatedWidget()
                                    ]),
                                  ),
                                ],
                              )),
                        ),
                      ),

                    // ********* auditor choose part ************ //
                    if (interface.dialogCurrentState['name'] == 'customer-audit-requested' ||
                        interface.dialogCurrentState['name'] == 'performer-audit-requested' ||
                        interface.dialogCurrentState['name'] == 'customer-audit-performing' ||
                        interface.dialogCurrentState['name'] == 'performer-audit-performing' ||
                        tasksServices.hardhatDebug == true)
                    // if (task.auditInitiator == tasksServices.publicAddress &&
                    //     interface.dialogCurrentState['pages'].containsKey('select'))
                      Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                            ),
                            child: ListBody(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Icon(Icons.warning_amber_rounded,
                                          size: 45, color: Colors.orange), //Icon(Icons.forward, size: 13, color: Colors.white),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          const Text('Warning, this contract on Audit state!',
                                              style: TextStyle(height: 1.1, fontWeight: FontWeight.bold)),
                                          if (task.auditInitiator == tasksServices.publicAddress &&
                                              interface.dialogCurrentState['pages'].containsKey('select'))
                                            Text(
                                                'There '
                                                    '${task.auditors.length == 1 ? 'is' : 'are'} '
                                                    '${task.auditors.length.toString()} auditor'
                                                    '${task.auditors.length == 1 ? '' : 's'}'
                                                    ' waiting for your decision',
                                                style: const TextStyle(
                                                  height: 1.1,
                                                )),
                                          if (task.auditor == EthereumAddress.fromHex('0x0000000000000000000000000000000000000000') &&
                                              task.auditInitiator != tasksServices.publicAddress)
                                            const Text('the auditor is expected to be selected', style: TextStyle(height: 1.1)),
                                          if (task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                            const Text('Your request is being resolved by: ', style: TextStyle(height: 1.1)),
                                          if (task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                            Text('${task.auditor}',
                                                style: const TextStyle(
                                                  height: 1.5,
                                                  fontSize: 9,
                                                  // backgroundColor: Colors.black12
                                                )),
                                        ])),
                                    if (task.auditInitiator == tasksServices.publicAddress &&
                                        interface.dialogCurrentState['pages'].containsKey('select'))
                                      TaskDialogButton(
                                        padding: 6.0,
                                        inactive: false,
                                        buttonName: 'Select',
                                        buttonColorRequired: Colors.orange,
                                        callback: () {
                                          interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                                              duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // ********* Participant choose part ************ //
                    if (interface.dialogCurrentState['name'] == 'customer-new' || tasksServices.hardhatDebug == true)
                    // if (task.taskState == "new" &&
                    //     task.participants.isNotEmpty &&
                    //     (fromPage == 'customer' || tasksServices.hardhatDebug == true))
                      Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                            ),
                            child: ListBody(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Icon(Icons.new_releases,
                                          size: 45, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: RichText(
                                          text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: <TextSpan>[
                                            TextSpan(
                                                text: 'There '
                                                    '${task.participants.length == 1 ? 'is' : 'are'} '
                                                    '${task.participants.length.toString()} participant'
                                                    '${task.participants.length == 1 ? '' : 's'}'
                                                    ' waiting for your decision',
                                                style: const TextStyle(
                                                  height: 1,
                                                )),
                                          ])),
                                    ),
                                    TaskDialogButton(
                                      padding: 6.0,
                                      inactive: false,
                                      buttonName: 'Select',
                                      buttonColorRequired: Colors.orange,
                                      callback: () {
                                        interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                                            duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // ********* Audit Completed part ************ //
                    if (interface.dialogCurrentState['name'] == 'auditor-finished' || tasksServices.hardhatDebug == true)
                    // if (task.taskState == "new" &&
                    //     task.participants.isNotEmpty &&
                    //     (fromPage == 'customer' || tasksServices.hardhatDebug == true))
                      Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                            ),
                            child: ListBody(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Icon(Icons.new_releases,
                                          size: 45, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                              children: const <TextSpan>[
                                                TextSpan(
                                                    text: 'Thank you for your contribution. This Task completed. You have earned: ',
                                                    style: TextStyle(
                                                      height: 1,
                                                    )),
                                              ])),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // ************ Show prices and topup part ******** //
                    // if (!FocusScope.of(context).hasFocus)
                    Container(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: innerWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: ListBody(
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: <TextSpan>[
                                            TextSpan(
                                                text: '${task.contractValue} DEV \n',
                                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0)),
                                            TextSpan(
                                                text: '${task.contractValueToken} aUSDC',
                                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0))
                                          ])),
                                    ],
                                  )),
                              const Spacer(),
                              if (fromPage == 'customer' || tasksServices.hardhatDebug == true)
                                TaskDialogButton(
                                  padding: 6.0,
                                  inactive: false,
                                  buttonName: 'Topup',
                                  buttonColorRequired: Colors.lightBlue.shade600,
                                  callback: () {
                                    interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['topup'] ?? 99,
                                        duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ChooseWalletButton(
                    //   active: tasksServices.platform == 'mobile' ? true : false,
                    //   buttonName: 'metamask',
                    //   borderRadius: widget.borderRadius,
                    // ),
                    // const SizedBox(height: 14),
                    // if (tasksServices.publicAddress != null &&
                    //   tasksServices.validChainID &&
                    //   ((interface.dialogCurrentState['mainButtonName'] == 'Participate' &&
                    //       fromPage == 'tasks') ||
                    //       interface.dialogCurrentState['mainButtonName'] == 'Start the task' ||
                    //       interface.dialogCurrentState['mainButtonName'] == 'Review' ||
                    //       interface.dialogCurrentState['mainButtonName'] == 'In favor of' ||
                    //       interface.dialogCurrentState['mainButtonName'] == 'Sign Review'))

                    // ********* Text Input ************ //
                    if (interface.dialogCurrentState['name'] == 'tasks-new-logged' ||
                        interface.dialogCurrentState['name'] == 'performer-agreed' ||
                        interface.dialogCurrentState['name'] == 'performer-progress' ||
                        interface.dialogCurrentState['name'] == 'customer-review' ||
                        tasksServices.hardhatDebug == true)
                      Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            // constraints: const BoxConstraints(maxHeight: 500),
                            padding: const EdgeInsets.all(8.0),
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                            ),
                            child: TextFormField(
                              controller: messageForStateController,
                              // onChanged: (_) => EasyDebounce.debounce(
                              //   'messageForStateController',
                              //   Duration(milliseconds: 2000),
                              //   () => setState(() {}),
                              // ),
                              autofocus: false,
                              obscureText: false,
                              onTapOutside: (test) {
                                FocusScope.of(context).unfocus();
                                interface.taskMessage = messageForStateController!.text;
                              },

                              decoration: InputDecoration(
                                // suffixIcon: interface.dialogCurrentState['pages']['chat'] != null ? IconButton(
                                //   onPressed: () {
                                //     interface.dialogPagesController.animateToPage(
                                //         interface.dialogCurrentState['pages']['chat'] ?? 99,
                                //         duration: const Duration(milliseconds: 600),
                                //         curve: Curves.ease);
                                //   },
                                //   icon: const Icon(Icons.chat),
                                //   highlightColor: Colors.grey,
                                //   hoverColor: Colors.transparent,
                                //   color: Colors.blueAccent,
                                //   // splashColor: Colors.black,
                                // ) : null,
                                labelText: interface.dialogCurrentState['labelMessage'],
                                labelStyle: const TextStyle(fontSize: 17.0, color: Colors.black54),
                                hintText: '[Enter your message here..]',
                                hintStyle: const TextStyle(fontSize: 14.0, color: Colors.black54),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyText1.override(
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                                lineHeight: null,
                              ),
                              minLines: 1,
                              maxLines: 3,
                            ),
                          ),
                        ),
                      ),
                    // ************** PERFORMER ROLE NETWORK CHOOSE *************** //

                    if ((task.contractValue != 0 || task.contractValueToken != 0) &&
                        (interface.dialogCurrentState['name'] == 'performer-completed' || tasksServices.hardhatDebug == true))
                    // if (task.taskState == 'completed' &&
                    //     (fromPage == 'performer' ||
                    //         tasksServices.hardhatDebug == true) &&
                    //     (task.contractValue != 0 || task.contractValueToken != 0))
                      Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            // constraints: const BoxConstraints(maxHeight: 500),
                            padding: const EdgeInsets.all(8.0),
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                            ),
                            child: SelectNetworkMenu(object: task),
                          ),
                        ),
                      ),

                    // ChooseWalletButton(active: true, buttonName: 'wallet_connect', borderRadius: widget.borderRadius,),
                    const Spacer(),

                    DialogButtonSetOnFirstPage(task: task, fromPage: fromPage, width: innerWidth, enableRatingButton: enableRatingButton)
                  ],
                ),
              ),
            ),
          // Shimmer.fromColors(
          //     baseColor: Colors.grey[300]!,
          //     highlightColor: Colors.grey[100]!,
          //     enabled: shimmerEnabled,
          //     child:
          if (interface.dialogCurrentState['pages'].containsKey('description'))
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxInternalWidth,
                ),
                child: Column(
                  children: [
                    Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: GestureDetector(
                            onTap: () {
                              // interface.dialogPagesController.animateToPage(
                              //     interface.dialogPages['chat'] == null ? interface.dialogPages['select']! : interface.dialogPages['chat']!,
                              //     duration: const Duration(milliseconds: 300),
                              //     curve: Curves.ease);
                            },
                            child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: widget.screenHeightSizeNoKeyboard - 220, minHeight: 40),
                                  child: SingleChildScrollView(
                                    child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        // height: MediaQuery.of(context).size.width * .08,
                                        // width: MediaQuery.of(context).size.width * .57
                                        width: innerWidth,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(widget.borderRadius),
                                        ),
                                        child: Container(
                                            padding: const EdgeInsets.all(6),
                                            child: RichText(
                                                text: TextSpan(
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text: task.description,
                                                      )
                                                    ])))),
                                  ),
                                ),
                                // const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  child: RichText(
                                      text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: <TextSpan>[
                                        const TextSpan(text: 'Created: ', style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: DateFormat('MM/dd/yyyy, hh:mm a').format(task.createTime),
                                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0))
                                      ])),
                                ),
                              ],
                            ))),

                    // const SizedBox(height: 14),
                    Container(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            child: GestureDetector(
                                child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    // height: MediaQuery.of(context).size.width * .08,
                                    // width: MediaQuery.of(context).size.width * .57
                                    width: innerWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(widget.borderRadius),
                                    ),
                                    child: ListBody(children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          Clipboard.setData(ClipboardData(text: task.contractOwner.toString())).then((_) {
                                            Flushbar(
                                                icon: const Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                message: '${task.contractOwner.toString()} copied to your clipboard!',
                                                duration: const Duration(seconds: 2),
                                                backgroundColor: Colors.blueAccent,
                                                shouldIconPulse: false)
                                                .show(context);
                                          });
                                        },
                                        child: RichText(
                                            text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: [
                                              const WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5.0),
                                                    child: Icon(
                                                      Icons.copy,
                                                      size: 16,
                                                      color: Colors.black26,
                                                    ),
                                                  )),
                                              const TextSpan(text: 'Contract owner: \n', style: TextStyle(height: 1, fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                  text: task.contractOwner.toString(),
                                                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                            ])),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Clipboard.setData(ClipboardData(text: task.taskAddress.toString())).then((_) {
                                            Flushbar(
                                                icon: const Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                message: '${task.taskAddress.toString()} copied to your clipboard!',
                                                duration: const Duration(seconds: 2),
                                                backgroundColor: Colors.blueAccent,
                                                shouldIconPulse: false)
                                                .show(context);
                                          });
                                        },
                                        child: RichText(
                                            text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: [
                                              const WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5.0),
                                                    child: Icon(
                                                      Icons.copy,
                                                      size: 16,
                                                      color: Colors.black26,
                                                    ),
                                                  )),
                                              const TextSpan(text: 'Contract address: \n', style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                  text: task.taskAddress.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                            ])),
                                      ),
                                      if (task.participant != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                        GestureDetector(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(text: task.participant.toString())).then((_) {
                                              Flushbar(
                                                  icon: const Icon(
                                                    Icons.copy,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  message: '${task.participant.toString()} copied to your clipboard!',
                                                  duration: const Duration(seconds: 2),
                                                  backgroundColor: Colors.blueAccent,
                                                  shouldIconPulse: false)
                                                  .show(context);
                                            });
                                          },
                                          child: RichText(
                                              text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: [
                                                const WidgetSpan(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: 5.0),
                                                      child: Icon(
                                                        Icons.copy,
                                                        size: 16,
                                                        color: Colors.black26,
                                                      ),
                                                    )),
                                                const TextSpan(text: 'Performer: \n', style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: task.participant.toString(),
                                                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                              ])),
                                        ),
                                      if (task.auditor != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                        GestureDetector(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(text: task.auditor.toString())).then((_) {
                                              Flushbar(
                                                  icon: const Icon(
                                                    Icons.copy,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  message: '${task.auditor.toString()} copied to your clipboard!',
                                                  duration: const Duration(seconds: 2),
                                                  backgroundColor: Colors.blueAccent,
                                                  shouldIconPulse: false)
                                                  .show(context);
                                            });
                                          },
                                          child: RichText(
                                              text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: [
                                                const WidgetSpan(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: 5.0),
                                                      child: Icon(
                                                        Icons.copy,
                                                        size: 16,
                                                        color: Colors.black26,
                                                      ),
                                                    )),
                                                const TextSpan(text: 'Auditor selected: \n', style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: task.auditor.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                              ])),
                                        ),
                                      // RichText(
                                      //   text: TextSpan(
                                      //     style: DefaultTextStyle.of(context)
                                      //         .style
                                      //         .apply(fontSizeFactor: 1.0),
                                      //     children: <TextSpan>[
                                      //       const TextSpan(
                                      //           text: 'Created: ',
                                      //           style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                      //       TextSpan(
                                      //           text: DateFormat('MM/dd/yyyy, hh:mm a')
                                      //               .format(task.createdTime),
                                      //           style: DefaultTextStyle.of(context)
                                      //               .style
                                      //               .apply(fontSizeFactor: 1.0))
                                      //     ])),
                                    ]))))),
                    // const SizedBox(height: 14),
                    // **************** CUSTOMER AND PERFORMER BUTTONS ****************** //
                    // ************************* AUDIT REQUEST ************************* //
                    const Spacer(),
                    // if ((fromPage == 'performer' ||
                    //     fromPage == 'customer' ||
                    //     tasksServices.hardhatDebug == true) &&
                    //     (task.taskState == "progress" || task.taskState == "review")
                    //     // && task.contractOwner != tasksServices.publicAddress
                    // )

                    if (interface.dialogCurrentState['name'] == 'customer-progress' ||
                        interface.dialogCurrentState['name'] == 'customer-review' ||
                        interface.dialogCurrentState['name'] == 'performer-review' ||
                        tasksServices.hardhatDebug == true)
                      Container(
                        padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
                        width: innerWidth + 8,
                        child: Row(
                          children: [
                            TaskDialogButton(
                              inactive: false,
                              buttonName: 'Request audit',
                              buttonColorRequired: Colors.orangeAccent.shade700,
                              callback: () {
                                showDialog(context: context, builder: (context) => RequestAuditDialog(who: fromPage, task: task));
                              },
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          if (interface.dialogCurrentState['pages'].containsKey('select'))
            SelectedPage(screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard, innerWidth: innerWidth, task: task),

          if (interface.dialogCurrentState['pages'].containsKey('chat'))
            Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxInternalWidth,
                        ),
                        child: Container(
                            padding: const EdgeInsets.all(6.0),
                            // height: widget.topConstraints.maxHeight,
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                            ),
                            child: ChatPage(task: task, tasksServices: tasksServices)),
                      )),
                )),
        ],
      );
    });
  }
}
