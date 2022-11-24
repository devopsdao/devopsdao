import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/participants_list.dart';
import 'package:devopsdao/custom_widgets/payment.dart';
import 'package:devopsdao/custom_widgets/select_menu.dart';
import 'package:devopsdao/custom_widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
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

import '../custom_widgets/data_loading_dialog.dart';

import 'dart:ui' as ui;

import 'package:rive/rive.dart' as rive;

class TaskDialog extends StatefulWidget {
  final String fromPage;
  final String taskAddress;
  const TaskDialog(
      {Key? key, required this.taskAddress, required this.fromPage})
      : super(key: key);

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
    // if (tasksServices.tasksCustomerSelection[widget.taskAddress] != null) {
    //   task = tasksServices.tasksCustomerSelection[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerProgress[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerProgress[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerComplete[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerComplete[widget.taskAddress]!;
    // }
    if (tasksServices.tasks[widget.taskAddress] != null) {
      task = tasksServices.tasks[widget.taskAddress]!;
      if (task != null) {
        print('taskAddress: ${widget.taskAddress}');
        print('fromPage: ${widget.fromPage}');
        return TaskInformationDialog(
            fromPage: widget.fromPage, task: task, shimmerEnabled: false);
      }
    }
    // return TaskInformationDialog(
    //     fromPage: widget.fromPage, task: task, shimmerEnabled: true);

    return const AppDataLoadingDialogWidget();
  }
}

class TaskInformationDialog extends StatefulWidget {
  // final int taskCount;
  final String fromPage;
  final Task task;
  final bool shimmerEnabled;
  const TaskInformationDialog({
    Key? key,
    // required this.taskCount,
    required this.fromPage,
    required this.task,
    required this.shimmerEnabled,
  }) : super(key: key);

  @override
  _TaskInformationDialogState createState() => _TaskInformationDialogState();
}

class _TaskInformationDialogState extends State<TaskInformationDialog> {
  late Task task;
  int backButtonShowIcon = 1;
  String backgroundPicture = "assets/images/niceshape.png";

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    Task task = widget.task;
    String fromPage = widget.fromPage;

    final double maxDialogWidth = interface.maxDialogWidth;
    task = widget.task;
    final double borderRadius = interface.borderRadius;

    if (widget.fromPage == 'customer') {
      backgroundPicture = "assets/images/cross.png";
    } else if (widget.fromPage == 'performer') {
      backgroundPicture = "assets/images/cyrcle.png";
    } else if (widget.fromPage == 'audit') {
      backgroundPicture = "assets/images/cross.png";
    }

    if (fromPage == 'tasks') {
      interface.dialogProcess = {
        'name': 'newOnTasks',
        'buttonName': 'Participate',
        'labelMessage': 'Why you are the best Performer?'
      };
      interface.dialogPages = {
        'main': 0,
        'description' : 1
      };
    } else if (task.taskState == 'new' && fromPage == 'customer') {
      interface.dialogProcess = {
        'name': 'newOnCustomer',
        'buttonName': 'Select performer',
        'labelMessage': 'Why you have selected this Performer?'
      };
      interface.dialogPages = {
        'topup': 0,
        'main': 1,
        'description' : 2,
        'select' : 3,
      };
    } else if (task.taskState == 'agreed' &&
        (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'agreedOnPerformer',
        'buttonName': 'Start the task',
        'labelMessage': 'Summarize your implementation plans'
      };
      interface.dialogPages = {
        'topup': 0,
        'main': 1,
        'description' : 2,
        'chat' : 3,
      };
    } else if (task.taskState == 'progress' &&
        (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'progressOnPerformer',
        'buttonName': 'Review',
        'labelMessage': 'Tell about your work to review'
      };
      interface.dialogPages = {
        'topup': 0,
        'main': 1,
        'description' : 2,
        'chat' : 3,
      };
    } else if (task.taskState == 'review' &&
        (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'reviewOnCustomer',
        'buttonName': 'Sign Review',
        'labelMessage': 'Write your request for review to the Customer'
      };
      interface.dialogPages = {
        'topup': 0,
        'main': 1,
        'description' : 2,
        'chat' : 3,
      };
    } else if ((task.taskState == 'progress' || task.taskState == 'review') &&
        (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'auditRequested',
        'buttonName': 'Take audit',
        'labelMessage': ''
      };
      interface.dialogPages = {
        'topup': 0,
        'main': 1,
        'description' : 2,
        'chat' : 3,
      };
    } else if (task.taskState == 'review' &&
        (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'auditRequested',
        'buttonName': 'Take audit',
        'labelMessage': ''
      };
      interface.dialogPages = {
        'main': 0,
        'description' : 1,
        'chat' : 2,
      };
    } else if (task.taskState == 'audit' && task.auditState == 'requested') {
      interface.dialogProcess = {
        'name': 'auditPerforming',
        'buttonName': 'In favor of',
        'labelMessage': 'Conclude your Audit decision reasoning'
      };
      interface.dialogPages = {
        'main': 0,
        'description' : 1,
        'select' : 2,
        'chat' : 3
      };
    } else if (task.taskState == 'audit' && task.auditState == 'performing') {
      interface.dialogProcess = {
        'name': 'auditFinished',
        'buttonName': '-',
        'labelMessage': 'Conclude your Audit decision reasoning'
      };
      interface.dialogPages = {
        'main': 0,
        'description' : 1,
        'chat' : 2,
      };
    } else if (task.taskState == 'completed') {
      interface.dialogProcess = {
        'name': 'completedState',
        'buttonName': '-',
        'labelMessage': 'Write your thanks message to the Customer'
      };
      interface.dialogPages = {
        'main': 0,
        'description' : 1,
        'chat' : 2,
      };
    } else if (task.taskState == 'canceled') {
      interface.dialogProcess = {
        'name': 'canceledState',
        'buttonName': '-',
        'labelMessage': 'Write your thanks message to the Customer'
      };
      interface.dialogPages = {
        'main': 0,
        'description' : 1,
        'chat' : 2,
      };
    }


    // init first page in dialog:
    if (interface.dialogPages['main'] != null) {
      interface.pageDialogViewNumber = interface.dialogPages['main']!;
      interface.dialogPagesController = PageController(initialPage: interface.dialogPages['main']!);
      print(interface.dialogPages);
    } else {
      print('Initial page in dialog not set! Defaul is 0');
      interface.pageDialogViewNumber = 0;
      interface.dialogPagesController = PageController(initialPage: 0);
    }

    bool shimmerEnabled = widget.shimmerEnabled;

    return LayoutBuilder(builder: (context, constraints) {
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
          // print('keyboardSize: $keyboardSize');
          // print('screenHeightSizeNoKeyboard: $screenHeightSizeNoKeyboard');
          // print('screenHeightSize: $screenHeightSize');
          // print('constraints.maxHeight: $constraints.maxHeight');

          return WillPopScope(
            onWillPop: () async => false,
            child: Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                              interface.dialogPagesController.animateToPage(
                                  interface.dialogPages['main']!,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.ease);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              height: 30,
                              width: 30,
                              child: Row(
                                children: <Widget>[
                                  if (interface.pageDialogViewNumber > 1)
                                    const Expanded(
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 30,
                                      ),
                                    ),
                                  if (interface.pageDialogViewNumber == 0)
                                    const Expanded(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: 30,
                                      ),
                                    ),
                                ],
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
                                            padding:
                                                EdgeInsets.only(right: 5.0),
                                            child: Icon(
                                              Icons.copy,
                                              size: 20,
                                              color: Colors.black26,
                                            ),
                                          )),
                                          TextSpan(
                                            text: task.title,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () async {
                                Clipboard.setData(ClipboardData(
                                        text:
                                            'https://dodao.dev/index.html#/${widget.fromPage}/${task.taskAddress.toString()}'))
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
                                          message:
                                              'Task URL copied to your clipboard!',
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
                            interface.pageDialogViewNumber = interface.dialogPages['main'] ?? 0; // reset page to *main*
                            Navigator.pop(context);
                            RouteInformation routeInfo = RouteInformation(
                                location: '/${widget.fromPage}');
                            Beamer.of(context)
                                .updateRouteInformation(routeInfo);
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
                        screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      );
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

  DialogPages(
      {Key? key,
      // required this.buttonName,
      required this.borderRadius,
      required this.task,
      required this.fromPage,
      required this.topConstraints,
      required this.shimmerEnabled,

      required this.screenHeightSize,
        required this.screenHeightSizeNoKeyboard})
      : super(key: key);

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
        //   interface.pageDialogViewNumber == 1)
        //     ? const RightBlockedScrollPhysics() : null,
        // physics: BouncingScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        controller: interface.dialogPagesController,
        onPageChanged: (number) {
          interface.pageDialogViewNumber = number;
          tasksServices.myNotifyListeners();
          // print(number);
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
          if (interface.dialogPages.containsKey('topup'))
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
                    Payment(
                        purpose: 'topup', innerWidth: innerWidth,
                        borderRadius: widget.borderRadius
                    ),
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
                              tasksServices.addTokens(task.taskAddress,
                                  interface.tokensEntered, task.nanoId);
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
          if (interface.dialogPages.containsKey('main'))
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
                        interface.dialogPagesController.animateToPage(
                            interface.dialogPages['description']!,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: Container(

                        // height: MediaQuery.of(context).size.width * .08,
                        // width: MediaQuery.of(context).size.width * .57
                        width: innerWidth,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                        ),
                        child: ListBody(
                          children: <Widget>[
                            // RichText(
                            //     text: TextSpan(
                            //         style: DefaultTextStyle.of(context)
                            //             .style
                            //             .apply(fontSizeFactor: 1.0),
                            //         children: <TextSpan>[
                            //           const TextSpan(
                            //               text: 'id: \n',
                            //               style: TextStyle(fontWeight: FontWeight.bold)),
                            //           TextSpan(text: task.nanoId)
                            //         ])),
                            // Container(
                            //   padding: const EdgeInsets.all(6),
                            //   child: Text(
                            //     task.title,
                            //     textAlign: TextAlign.center,
                            //     style:
                            //     const TextStyle(fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            LayoutBuilder(
                                builder: (context, constraints) {
                                  final span = TextSpan(
                                    text: task.description,
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.0),
                                  );
                                  final tp = TextPainter(text: span, maxLines: 3, textDirection: ui.TextDirection.ltr);
                                  tp.layout(maxWidth: constraints.maxWidth);
                                  final numLines = tp.computeLineMetrics().length;

                                  // final tp =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
                                  // tp.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width
                                  // print(tp.didExceedMaxLines);
                                  return LimitedBox(
                                    maxHeight: tp.didExceedMaxLines ? tp.height + 26: tp.height + 12,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [

                                        Container(
                                            padding: const EdgeInsets.all(6.0),
                                            // padding: const EdgeInsets.all(3),
                                            child: RichText(
                                              maxLines: 3,
                                                text: span)
                                        ),
                                        if(tp.didExceedMaxLines)
                                          Container(
                                            alignment: Alignment.center,
                                              height: 14,
                                              width: constraints.maxWidth,
                                              decoration:  const BoxDecoration(
                                                color: Colors.orangeAccent,
                                                borderRadius: BorderRadius.only(
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
                                                        style: DefaultTextStyle.of(context)
                                                            .style
                                                            .apply(fontSizeFactor: 0.8, color: Colors.white),
                                                      ),
                                                      const WidgetSpan(
                                                        child: Icon(Icons.forward, size: 13, color: Colors.white),
                                                      ),
                                                    ],

                                                  )
                                              )
                                          ),
                                      ],
                                    ),
                                  );
                                }),





                            // ************************ AUDITOR ROLE ************************** //
                            // ************************ EMPTY ************************** //
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(height: 14),


                  if (task.taskState == "audit" &&
                      (fromPage == 'customer' ||
                          fromPage == 'performer' ||
                          tasksServices.hardhatDebug == true))

                    Container(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                            width: innerWidth,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                            ),
                            child: Column(
                              children: [

// ********************** CUSTOMER ROLE ************************* //



                                // ****************** PERFORMER AND CUSTOMER ROLE ******************* //
                                // *************************** AUDIT ******************************** //

                                if (task.auditState == "requested" ||
                                        tasksServices.hardhatDebug == true)
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text:
                                                  'Warning, this contract on Audit state \n'
                                                      'Please choose auditor: ',
                                                  style: TextStyle(
                                                      height: 2,
                                                      fontWeight: FontWeight.bold)),
                                            ])),
                                  ),
                                if (task.auditState == "performing" ||
                                        tasksServices.hardhatDebug == true)
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Your request is being resolved \n'
                                                      'Your auditor: \n',
                                                  style: TextStyle(
                                                      height: 2,
                                                      fontWeight: FontWeight.bold)),
                                              TextSpan(
                                                  text: task.auditor.toString(),
                                                  style: DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(fontSizeFactor: 0.7))
                                            ])),
                                  ),
                                if (  task.auditState == "requested" ||
                                        tasksServices.hardhatDebug == true)
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(8.0),
                                    child: ParticipantList(
                                      listType: 'audit',
                                      obj: task,
                                    ),
                                  ),
                              ],
                            )
                        ),
                      ),
                    ),


                  if (task.taskState == 'completed' &&
                      (fromPage == 'customer' ||
                          tasksServices.hardhatDebug == true))


                    Container(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          width: innerWidth,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.0),
                                      children: const <TextSpan>[
                                        TextSpan(
                                          text: 'Rate the task:',
                                          style: TextStyle(
                                              height: 2,
                                              fontWeight: FontWeight.bold)),
                                      ])),
                              ),

                              Container(
                                padding: const EdgeInsets.all(1.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: const [
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
                          )
                        ),
                      ),
                    ),




                  if (task.taskState == "new" &&
                      task.participants.isNotEmpty &&
                      (fromPage == 'customer' || tasksServices.hardhatDebug == true)
                  // && task.participants.isNotEmpty
                  )
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
                              Container(
                                padding: const EdgeInsets.all(6),
                                child: RichText(
                                    text: TextSpan(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 1.0),
                                        children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Choose contractor: ',
                                          style: TextStyle(
                                              height: 1,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                              ),

                              // Badge(
                              //   // position: BadgePosition.topEnd(top: 10, end: 10),
                              //   badgeContent: Container(
                              //     width: 17,
                              //     height: 17,
                              //     alignment: Alignment.center,
                              //     child: Text(task.participants.length.toString(),
                              //         style: const TextStyle(
                              //             fontWeight: FontWeight.bold, color: Colors.white)),
                              //   ),
                              //   badgeColor: (() {
                              //     if (task.taskState == "new") {
                              //       return Colors.redAccent;
                              //     } else if (task.taskState == "audit" &&
                              //         widget.fromPage != "auditor") {
                              //       return Colors.blueGrey;
                              //     } else if (widget.fromPage == "auditor") {
                              //       return Colors.green;
                              //     } else {
                              //       return Colors.white;
                              //     }
                              //   }()),
                              //   animationDuration: const Duration(milliseconds: 300),
                              //   animationType: BadgeAnimationType.scale,
                              //   shape: BadgeShape.circle,
                              //   borderRadius: BorderRadius.circular(5),
                              //   // child: Icon(Icons.settings),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // const SizedBox(height: 14),
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
                                child: ListBody(
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 1.0),
                                        children: <TextSpan>[
                                      TextSpan(
                                          text: '${task.contractValue} DEV \n',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(fontSizeFactor: 1.0)),
                                      TextSpan(
                                          text: '${task.contractValueToken} aUSDC',
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(fontSizeFactor: 1.0))
                                    ])),
                              ],
                            )),
                            if (fromPage == 'customer' ||
                                tasksServices.hardhatDebug == true)
                              TaskDialogButton(
                                padding: 6.0,
                                inactive: false,
                                buttonName: 'Topup',
                                buttonColorRequired: Colors.lightBlue.shade600,
                                callback: () {
                                  interface.dialogPagesController.animateToPage(
                                      interface.dialogPages['topup'] ?? 99,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.ease);
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) => AlertDialog(
                                  //           title: const Text('Topup contract'),
                                  //           // backgroundColor: Colors.black,
                                  //           content: const Payment(
                                  //             purpose: 'topup',
                                  //           ),
                                  //           actions: [
                                  //             TextButton(
                                  //               onPressed: () {
                                  //                 tasksServices.addTokens(
                                  //                     task.taskAddress,
                                  //                     interface.tokensEntered,
                                  //                     task.nanoId);
                                  //                 Navigator.pop(context);
                                  //
                                  //                 showDialog(
                                  //                     context: context,
                                  //                     builder: (context) =>
                                  //                         WalletAction(
                                  //                           nanoId: task.nanoId,
                                  //                           taskName: 'addTokens',
                                  //                         ));
                                  //               },
                                  //               style: TextButton.styleFrom(
                                  //                   primary: Colors.white,
                                  //                   backgroundColor: Colors.green),
                                  //               child: const Text('Topup contract'),
                                  //             ),
                                  //             TextButton(
                                  //                 child: const Text('Close'),
                                  //                 onPressed: () =>
                                  //                     context.beamToNamed('/tasks')
                                  //                 // Navigator.pop(context),
                                  //                 ),
                                  //           ],
                                  //         )
                                  // );
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
                  if (tasksServices.publicAddress != null &&
                    tasksServices.validChainID &&
                    ((interface.dialogProcess['buttonName'] == 'Participate' &&
                        fromPage == 'tasks') ||
                    interface.dialogProcess['buttonName'] == 'Start the task' ||
                    interface.dialogProcess['buttonName'] == 'Review' ||
                    interface.dialogProcess['buttonName'] == 'In favor of' ||
                    interface.dialogProcess['buttonName'] == 'Sign Review'))
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
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
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
                              interface.taskMessage =
                                  messageForStateController!.text;
                            },

                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  interface.dialogPagesController.animateToPage(
                                      interface.dialogPages['chat'] ?? 99,
                                      duration: const Duration(milliseconds: 600),
                                      curve: Curves.ease);
                                },
                                icon: const Icon(Icons.chat),
                                // focusColor: Colors.black  ,
                                highlightColor: Colors.grey,
                                // disabledColor: Colors.red,
                                hoverColor: Colors.transparent,
                                color: Colors.blueAccent,
                                // splashColor: Colors.black,
                              ),
                              labelText: interface.dialogProcess['labelMessage'],
                              labelStyle: const TextStyle(
                                  fontSize: 17.0, color: Colors.black54),
                              hintText: '[Enter your message here..]',
                              hintStyle: const TextStyle(
                                  fontSize: 14.0, color: Colors.black54),
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

                  if (task.taskState == 'completed' &&
                      (fromPage == 'performer' ||
                          tasksServices.hardhatDebug == true) &&
                      (task.contractValue != 0 || task.contractValueToken != 0))
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
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                          child: SelectNetworkMenu(object: task),
                        ),
                      ),
                    ),

                  // ChooseWalletButton(active: true, buttonName: 'wallet_connect', borderRadius: widget.borderRadius,),
                  const Spacer(),

                  DialogButtonSetOnFirstPage(
                      task: task,
                      fromPage: fromPage,
                      width: innerWidth,
                      enableRatingButton: enableRatingButton)
                ],
              ),
            ),
          ),
          // Shimmer.fromColors(
          //     baseColor: Colors.grey[300]!,
          //     highlightColor: Colors.grey[100]!,
          //     enabled: shimmerEnabled,
          //     child:
          if (interface.dialogPages.containsKey('description'))
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
                            interface.dialogPagesController.animateToPage(
                                interface.dialogPages['chat'] ?? 99,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          child: Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: widget.screenHeightSizeNoKeyboard - 220,
                                    minHeight: 40
                                ),
                                child: SingleChildScrollView(
                                  child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      // height: MediaQuery.of(context).size.width * .08,
                                      // width: MediaQuery.of(context).size.width * .57
                                      width: innerWidth,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(widget.borderRadius),
                                      ),
                                      child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: RichText(
                                              text: TextSpan(
                                                  style: DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(fontSizeFactor: 1.0),
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
                                    text: TextSpan(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 1.0),
                                        children: <TextSpan>[
                                      const TextSpan(
                                          text: 'Created: ',
                                          style: TextStyle(
                                              height: 2,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: DateFormat('MM/dd/yyyy, hh:mm a')
                                              .format(task.createTime),
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .apply(fontSizeFactor: 1.0))
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
                                    borderRadius:
                                        BorderRadius.circular(widget.borderRadius),
                                  ),
                                  child: ListBody(children: <Widget>[
                                    GestureDetector(
                                      onTap: () async {
                                        Clipboard.setData(ClipboardData(
                                            text: task.contractOwner.toString() ))
                                            .then((_) {
                                          Flushbar(
                                              icon: const Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              message:
                                              '${task.contractOwner.toString()} copied to your clipboard!',
                                              duration: const Duration(seconds: 2),
                                              backgroundColor: Colors.blueAccent,
                                              shouldIconPulse: false)
                                              .show(context);
                                        });
                                      },

                                      child: RichText(

                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children:[
                                                const WidgetSpan(
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.only(right: 5.0),
                                                      child: Icon(
                                                        Icons.copy,
                                                        size: 16,
                                                        color: Colors.black26,
                                                      ),
                                                    )),

                                            const TextSpan(

                                                text: 'Contract owner: \n',
                                                style: TextStyle(
                                                    height: 1,
                                                    fontWeight: FontWeight.bold)),

                                            TextSpan(
                                                text: task.contractOwner.toString(),
                                                style: DefaultTextStyle.of(context)
                                                    .style
                                                    .apply(fontSizeFactor: 0.7))
                                          ])),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Clipboard.setData(ClipboardData(
                                            text: task.taskAddress.toString() ))
                                            .then((_) {
                                          Flushbar(
                                              icon: const Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              message:
                                              '${task.taskAddress.toString()} copied to your clipboard!',
                                              duration: const Duration(seconds: 2),
                                              backgroundColor: Colors.blueAccent,
                                              shouldIconPulse: false)
                                              .show(context);
                                        });
                                      },

                                      child:  RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children:[
                                                const WidgetSpan(
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.only(right: 5.0),
                                                      child: Icon(
                                                        Icons.copy,
                                                        size: 16,
                                                        color: Colors.black26,
                                                      ),
                                                    )),
                                            const TextSpan(
                                                text: 'Contract address: \n',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: task.taskAddress.toString(),
                                                style: DefaultTextStyle.of(context)
                                                    .style
                                                    .apply(fontSizeFactor: 0.7))
                                          ])),
                                    ),
                                    if(task.participant != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                    GestureDetector(
                                      onTap: () async {
                                        Clipboard.setData(ClipboardData(
                                            text: task.participant.toString() ))
                                            .then((_) {
                                          Flushbar(
                                              icon: const Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              message:
                                              '${task.participant.toString()} copied to your clipboard!',
                                              duration: const Duration(seconds: 2),
                                              backgroundColor: Colors.blueAccent,
                                              shouldIconPulse: false)
                                              .show(context);
                                        });
                                      },
                                      child: RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children:[
                                                const WidgetSpan(
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.only(right: 5.0),
                                                      child: Icon(
                                                        Icons.copy,
                                                        size: 16,
                                                        color: Colors.black26,
                                                      ),
                                                    )),
                                                const TextSpan(
                                                    text: 'Performer: \n',
                                                    style: TextStyle(
                                                        height: 2,
                                                        fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: task.participant.toString(),
                                                    style: DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(fontSizeFactor: 0.7))
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
                  if ((fromPage == 'performer' ||
                      fromPage == 'customer' ||
                      tasksServices.hardhatDebug == true) &&
                      (task.taskState == "progress" || task.taskState == "review")
                      // && task.contractOwner != tasksServices.publicAddress
                  )
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


                              //

                              showDialog(
                                context: context,
                                builder: (context) => RequestAuditDialog(who: fromPage, task: task)
                              );
                            },
                          ),
                        ],
                      ),
                    )

                ],
              ),
            ),
          ),
          if (interface.dialogPages.containsKey('select'))
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxInternalWidth,
                  maxHeight: widget.screenHeightSizeNoKeyboard,
                  // maxHeight: widget.screenHeightSize
                ),
                child: Container(
                  width: innerWidth,
                  child: Column(
                    children: [
                      ListBody(

                        children: <Widget>[
                          Material(


                            elevation: 10,
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                            child: Container(

                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  Container(

                                    alignment: Alignment.topLeft,
                                    child: RichText(

                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text: 'Choose contractor: ',
                                                  style: TextStyle(
                                                      height: 1,
                                                      fontWeight: FontWeight.bold)),
                                            ])),
                                  ),
                                  if (task.participants.isEmpty)
                                    RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text: 'Participants not applied to your Task yet. ',
                                                  style: TextStyle(
                                                      height: 2,)),
                                            ])),
                                  ParticipantList(
                                    listType: fromPage,
                                    obj: task,
                                  ),

                                ],
                              ),
                            ),
                          ),
                          if(interface.selectedUser['address'] != null)

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 0.0),
                            child: Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(widget.borderRadius),
                              child: Container(

                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  children: [
                                    Container(

                                      alignment: Alignment.topLeft,
                                      child: RichText(

                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Some information about ${interface.selectedUser['address']}',
                                                    style: TextStyle(
                                                        height: 1,
                                                        )),
                                              ])),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),



                        ],
                      ),
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
                              inactive: interface.selectedUser['address'] == null ? true : false,
                              buttonName: interface.dialogProcess['buttonName'] ?? 'null: no name',
                              buttonColorRequired: Colors.lightBlue.shade600,
                              callback: () {
                                setState(() {
                                  task.justLoaded = false;
                                });
                                tasksServices.taskStateChange(task.taskAddress,
                                    EthereumAddress.fromHex(interface.selectedUser['address']!), fromPage, task.nanoId);
                                Navigator.pop(context);
                                RouteInformation routeInfo =
                                const RouteInformation(location: '/customer');
                                Beamer.of(context).updateRouteInformation(routeInfo);

                                showDialog(
                                    context: context,
                                    builder: (context) => WalletAction(
                                      nanoId: task.nanoId,
                                      taskName: 'taskStateChange',
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
          ),

          if (interface.dialogPages.containsKey('chat'))
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
                              borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                            ),
                            child:
                            ChatPage(task: task, tasksServices: tasksServices)
                        ),
                      )
                  ),
                )
            ),
        ],
      );
    });
  }
}

class DialogButtonSetOnFirstPage extends StatefulWidget {
  final Task task;
  final String fromPage;
  final double width;
  // final String message;
  final bool enableRatingButton;

  const DialogButtonSetOnFirstPage(
      {Key? key,
      required this.task,
      required this.fromPage,
      required this.width,
      // required this.message,
      required this.enableRatingButton})
      : super(key: key);

  @override
  _DialogButtonSetState createState() => _DialogButtonSetState();
}

class _DialogButtonSetState extends State<DialogButtonSetOnFirstPage> {
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    Task task = widget.task;
    String fromPage = widget.fromPage;
    double innerWidth = widget.width;
    // String message = interface.taskMessage.text;
    bool enableRatingButton = widget.enableRatingButton;

    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
      width: innerWidth + 8,
      child: Row(
        // direction: Axis.horizontal,
        // crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          // ##################### ACTION BUTTONS PART ######################## //
          // ************************ NEW (EXCHANGE) ************************** //
          if (fromPage == 'tasks')
            TaskDialogButton(
              inactive: (task.contractOwner != tasksServices.publicAddress ||
                          tasksServices.hardhatDebug == true) &&
                      tasksServices.validChainID &&
                      tasksServices.publicAddress != null
                  ? false
                  : true,
              buttonName: 'Participate',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskParticipate(task.taskAddress, task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                RouteInformation routeInfo =
                    const RouteInformation(location: '/tasks');
                Beamer.of(context).updateRouteInformation(routeInfo);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskParticipate',
                        ));
              },
            ),
          // ********************** PERFORMER BUTTONS ************************* //
          if (task.taskState == "agreed" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Start the task',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(
                    task.taskAddress, task.participant, 'progress', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                RouteInformation routeInfo =
                    const RouteInformation(location: '/performer');
                Beamer.of(context).updateRouteInformation(routeInfo);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskStateChange',
                        ));
              },
            ),
          if (task.taskState == "progress" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Review',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(
                    task.taskAddress, task.participant, 'review', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                RouteInformation routeInfo =
                    const RouteInformation(location: '/performer');
                Beamer.of(context).updateRouteInformation(routeInfo);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskStateChange',
                        ));
              },
            ),

          if (task.taskState == "completed" &&
              (fromPage == 'performer' || tasksServices.hardhatDebug == true)
              )
            // WithdrawButton(object: task),
            TaskDialogButton(
              inactive: (task.contractValue != 0 || task.contractValueToken != 0) ? false : true,
              buttonName: 'Withdraw',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.withdrawToChain(task.taskAddress, task.nanoId);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'withdrawToChain',
                        ));
              },
              task: task,
            ),

          // *********************** CUSTOMER BUTTONS *********************** //
          // if (fromPage == 'customer' || tasksServices.hardhatDebug == true)
          //   TaskDialogButton(
          //     inactive: false,
          //     buttonName: 'Topup',
          //     buttonColorRequired: Colors.lightBlue.shade600,
          //     callback: () {
          //       showDialog(
          //           context: context,
          //           builder: (context) => AlertDialog(
          //             title: const Text('Topup contract'),
          //             // backgroundColor: Colors.black,
          //             content: const Payment(
          //               purpose: 'topup',
          //             ),
          //             actions: [
          //               TextButton(
          //                 onPressed: () {
          //                   tasksServices.addTokens(task.taskAddress,
          //                       interface.tokensEntered, task.nanoId);
          //                   Navigator.pop(context);
          //
          //                   showDialog(
          //                       context: context,
          //                       builder: (context) => WalletAction(
          //                         nanoId: task.nanoId,
          //                         taskName: 'addTokens',
          //                       ));
          //                 },
          //                 style: TextButton.styleFrom(
          //                     primary: Colors.white,
          //                     backgroundColor: Colors.green),
          //                 child: const Text('Topup contract'),
          //               ),
          //               TextButton(
          //                   child: const Text('Close'),
          //                   onPressed: () => context.beamToNamed('/tasks')
          //                 // Navigator.pop(context),
          //               ),
          //             ],
          //           ));
          //     },
          //   ),

          if (task.taskState == 'review' &&
              (fromPage == 'customer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Sign Review',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(task.taskAddress,
                    task.participant, 'completed', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                // context.beamToNamed('/customer');
                Navigator.pop(context);
                RouteInformation routeInfo =
                    const RouteInformation(location: '/customer');
                Beamer.of(context).updateRouteInformation(routeInfo);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskStateChange',
                        ));
              },
            ),
          if (task.taskState == 'completed' &&
              (fromPage == 'customer' || tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Rate task',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                (task.rating == 0 && enableRatingButton)
                    ? () {
                        setState(() {
                          task.justLoaded = false;
                        });
                        // tasksServices.rateTask(
                        //     task.taskAddress, ratingScore, task.nanoId);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                                  nanoId: task.nanoId,
                                  taskName: 'rateTask',
                                ));
                      }
                    : null;
              },
            ),

          // ************************* AUDITOR BUTTONS ************************ //
          if ((fromPage == 'auditor' || tasksServices.hardhatDebug == true) &&
              task.auditState == 'requested')
            TaskDialogButton(
              inactive: false,
              buttonName: 'Take audit',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskAuditParticipate(
                    task.taskAddress, task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskAuditParticipate',
                        ));
              },
            ),

          if ((fromPage == 'auditor' || tasksServices.hardhatDebug == true) &&
              task.auditState == 'performing')
            TaskDialogButton(
              inactive: false,
              buttonName: 'In favor of Customer',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskAuditDecision(
                    task.taskAddress, 'customer', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskAuditDecision',
                        ));
              },
            ),
          if ((fromPage == 'auditor' || tasksServices.hardhatDebug == true) &&
              task.auditState == 'performing')
            TaskDialogButton(
              inactive: false,
              buttonName: 'In favor of Performer',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskAuditDecision(
                    task.taskAddress, 'performer', task.nanoId,
                    message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskAuditDecision',
                        ));
              },
            ),

          // ************************ ALL ROLES BUTTONS ********************** //
          // TextButton(
          //     child: const Text('Close'),
          //     onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class RateAnimatedWidget extends StatefulWidget {
  final Task? task;
  const RateAnimatedWidget({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  _RateAnimatedWidgetState createState() => _RateAnimatedWidgetState();
}

class _RateAnimatedWidgetState extends State<RateAnimatedWidget> {
  @override
  Widget build(BuildContext context) {

    rive.SMINumber? rating;

    void _onRiveInit(rive.Artboard artboard) {
      final rive.StateMachineController? controller =
          rive.StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
        // onStateChange: (stateMachineName, animationName) {
        //   print(stateMachineName);
        //   print(animationName);
        //   print(rating!.value);
        // },
      );
      artboard.addController(controller!);
      // rating = controller.findInput<double>('Rating') as SMINumber;
    }

    // void hitBump() => debugPrint("${rating!.value}");
    void hitBump() => print('test');
    return SizedBox.fromSize(
        // dimension: 200,
        size: const Size.fromHeight(60),
        // constraints: const BoxConstraints.expand(),
        child: GestureDetector(
          onTap: hitBump,
          child: rive.RiveAnimation.asset(
            'assets/rive_animations/rating_animation.riv',
            fit: BoxFit.contain,
            alignment: Alignment.center,
            onInit: _onRiveInit,
          ),
        ));
  }
}

class TaskDialogButton extends StatefulWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final Task? task;
  final bool inactive;
  final double? padding;
  const TaskDialogButton(
      {Key? key,
      required this.buttonName,
      required this.buttonColorRequired,
      required this.callback,
      required this.inactive,
      this.task,
      this.padding})
      : super(key: key);

  @override
  _TaskDialogButtonState createState() => _TaskDialogButtonState();
}

class _TaskDialogButtonState extends State<TaskDialogButton> {
  late Color buttonColor;
  late Color textColor = Colors.white;
  late bool _buttonState = true;
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    final Size widthTextSize = (TextPainter(
            text: TextSpan(
                text: widget.buttonName,
                style: TextStyle(fontSize: 18, color: textColor)),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: ui.TextDirection.ltr)
          ..layout())
        .size;
    buttonColor = widget.buttonColorRequired;

    if (widget.inactive == true) {
      textColor = Colors.white;
      buttonColor = Colors.grey;
      _buttonState = false;
    } else {
      _buttonState = true;
    }

    // // this check for WITHDRAW button:
    // if (widget.task != null) {
    //   if (widget.task!.contractValue != 0) {
    //     _buttonState = true;
    //   } else if (widget.task!.contractValueToken != 0) {
    //     if (widget.task!.contractValueToken > tasksServices.transferFee ||
    //         tasksServices.destinationChain == 'Moonbase') {
    //       _buttonState = true;
    //     } else {
    //       textColor = Colors.white;
    //       buttonColor = Colors.grey;
    //       _buttonState = false;
    //     }
    //   }
    // }

    late double? padding = 10.0;
    if (widget.padding != null) {
      padding = widget.padding;
    }

    return Expanded(
      child: Container(
        width: widthTextSize.width + 100,
        padding: const EdgeInsets.all(4.0),
        child: Material(
          elevation: 9,
          borderRadius: BorderRadius.circular(6),
          color: buttonColor,
          child: InkWell(
            onTap: _buttonState ? widget.callback : null,
            child: Container(
              padding: EdgeInsets.all(padding!),
              // height: 40.0,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.buttonName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class RequestAuditDialog extends StatefulWidget {
  final String who;
  final Task task;
  const RequestAuditDialog(
      {Key? key,
        required this.who,
        required this.task
      })
      : super(key: key);

  @override
  _RequestAuditDialogState createState() => _RequestAuditDialogState();
}

class _RequestAuditDialogState extends State<RequestAuditDialog> {
  late String warningText;
  late String link;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final Task task = widget.task;

    if (widget.who == 'customer') {
      warningText = 'Are you sure you want to start the Audit process? You will have to top-up the contract with 10% from the Task price, totaling: 10 USDC. For more information:';
      link = 'https://docs.dodao.dev/audit_process.html#customer';
    } else if (widget.who == 'performer') {
      warningText = 'Are you sure you want to start the Audit process? Auditor will receive 10% from the funds allocated to the task, totaling: 10 USDC. For more information:';
      link = 'https://docs.dodao.dev/audit_process.html#performer';
    }


    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: SizedBox(
        height: 340,
        width: 350,

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.warning_amber,
                  color: Colors.black45,
                  size: 110,
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                  text: TextSpan(
                      style: DefaultTextStyle
                          .of(context)
                          .style
                          .apply(fontSizeFactor: 1.1),
                      children: <TextSpan>[
                        TextSpan(

                          text: warningText,
                        ),

                      ])
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        //MediaQuery.of(context).size.width * .08,
                        // width: halfWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black54//                   <--- border width here
                          ),
                        ),
                        child: const Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: InkWell(

                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          task.justLoaded = false;
                        });
                        tasksServices.taskStateChange(
                            task.taskAddress, task.participant, 'audit', task.nanoId,
                            message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                        showDialog(
                            context: context,
                            builder: (context) => WalletAction(
                              nanoId: task.nanoId,
                              taskName: 'taskStateChange',
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
                            stops: [0, 0.6, 1],
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
