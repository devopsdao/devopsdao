import 'package:another_flushbar/flushbar.dart';
import 'package:devopsdao/custom_widgets/participants_list.dart';
import 'package:devopsdao/custom_widgets/payment.dart';
import 'package:devopsdao/custom_widgets/select_menu.dart';
import 'package:devopsdao/custom_widgets/wallet_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

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

import 'package:rive/rive.dart';

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
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    task = widget.task;
    final double borderRadius = interface.borderRadius;

    if (widget.fromPage == 'customer') {
      backgroundPicture = "assets/images/cross.png";
    } else if (widget.fromPage == 'performer') {
      backgroundPicture = "assets/images/cyrcle.png";
    } else if (widget.fromPage == 'audit') {
      backgroundPicture = "assets/images/cross.png";
    }

    // if (interface.pageDialogViewNumber == interface.dialogPages['main']) {
    //   backButtonShowIcon = true;
    // } else {
    //   backButtonShowIcon = false;
    // }

    bool shimmerEnabled = widget.shimmerEnabled;

    return LayoutBuilder(builder: (context, constraints) {
      // print('max:  ${constraints.maxHeight}');
      // print('max * : ${constraints.maxHeight * .65}');
      // print(constraints.minWidth);
      return StatefulBuilder(
        builder: (context, setState) {
          // ****** Count Screen size with keyboard and without ***** ///
          final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
          final double screenSizeNoKeyboard = constraints.maxHeight - 120;
          // < 400 ? 330
          // : constraints.maxHeight - 140;
          final double screenSize = screenSizeNoKeyboard - keyboardSize;
          // print('keyboardSize: $keyboardSize');
          // print('screenSizeNoKeyboard: $screenSizeNoKeyboard');
          // print('screenSize: $screenSize');
          // print('constraints.maxHeight: $constraints.maxHeight');

          return WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
              child: Dialog(
                insetPadding: const EdgeInsets.all(20),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: 400,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: InkWell(
                            onTap: () {
                              interface.tasksController.animateToPage(
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
                                  if (interface.pageDialogViewNumber ==
                                          interface
                                              .dialogPages['description'] ||
                                      interface.pageDialogViewNumber ==
                                          interface.dialogPages['chat'])
                                    const Expanded(
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 30,
                                      ),
                                    ),
                                  if (interface.pageDialogViewNumber ==
                                      interface.dialogPages['topup'])
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
                            child: InkWell(
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
                            interface.pageDialogViewNumber = 1; // reset page to *main*
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
                    height: screenSize,
                    // width: constraints.maxWidth * .8,
                    // height: 550,
                    width: 400,
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
  bool shimmerEnabled;

  DialogPages(
      {Key? key,
      // required this.buttonName,
      required this.borderRadius,
      required this.task,
      required this.fromPage,
      required this.topConstraints,
      required this.shimmerEnabled})
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

    interface.taskMessage = messageForStateController!.text;

    Task task = widget.task;
    String fromPage = widget.fromPage;
    bool shimmerEnabled = widget.shimmerEnabled;

    if (task.taskState == 'new' && fromPage == 'tasks') {
      interface.dialogProcess = {
        'name': 'newOnTasks',
        'buttonName': 'Participate',
        'labelMessage': 'Why you are the best Performer?'
      };
    } else if (task.taskState == 'new' && fromPage == 'customer') {
      interface.dialogProcess = {
        'name': 'newOnCustomer',
        'buttonName': '-',
        'labelMessage': 'Why you have selected this Performer?'
      };
    } else if (task.taskState == 'agreed' &&
        (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'agreedOnPerformer',
        'buttonName': 'Start the task',
        'labelMessage': 'Summarize your implementation plans'
      };
    } else if (task.taskState == 'progress' &&
        (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'progressOnPerformer',
        'buttonName': 'Review',
        'labelMessage': 'Tell about your work to review'
      };
    } else if (task.taskState == 'review' &&
        (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogProcess = {
        'name': 'reviewOnCustomer',
        'buttonName': 'Sign Review',
        'labelMessage': 'Write your request for review to the Customer'
      };
    } else if (task.taskState == 'audit' && task.auditState == 'requested') {
      interface.dialogProcess = {
        'name': 'auditRequested',
        'buttonName': 'Take audit',
        'labelMessage': ''
      };
    } else if (task.taskState == 'audit' && task.auditState == 'performing') {
      interface.dialogProcess = {
        'name': 'auditPerforming',
        'buttonName': 'In favor of',
        'labelMessage': 'Conclude your Audit decision reasoning'
      };
    } else if (task.taskState == 'audit' && task.auditState == 'finished') {
      interface.dialogProcess = {
        'name': 'auditFinished',
        'buttonName': '-',
        'labelMessage': 'Conclude your Audit decision reasoning'
      };
    } else if (task.taskState == 'completed') {
      interface.dialogProcess = {
        'name': 'completedState',
        'buttonName': '-',
        'labelMessage': 'Write your thanks message to the Customer'
      };
    } else if (task.taskState == 'canceled') {
      interface.dialogProcess = {
        'name': 'canceledState',
        'buttonName': '-',
        'labelMessage': 'Write your thanks message to the Customer'
      };
    }

    // if (task.taskState == 'new' && fromPage == 'tasks') {
    //   messageHint = 'Write why you are the best Performer for this task';
    // } else if (task.taskState == 'new' && fromPage == 'customer') {
    //   messageHint = 'Write why you have selected this Performer';
    // } else if (task.taskState == 'agreed') {
    //   messageHint = 'Write about your implementation plans';
    // } else if (task.taskState == 'progress') {
    //   messageHint = 'Write your request for review to the Customer';
    // } else if (task.taskState == 'review') {
    //   messageHint = 'Write your review signature notes to the Performer';
    // } else if (task.taskState == 'audit' && task.auditState == 'requested') {
    //   messageHint = 'Write your request for audit to the Auditor';
    // } else if (task.taskState == 'audit' && task.auditState == 'performing') {
    //   messageHint = 'Write a tip for your selected Auditor';
    // } else if (task.taskState == 'audit' && task.auditState == 'finished') {
    //   messageHint = 'Write your Audit decision reasoning';
    // } else if (task.taskState == 'completed') {
    //   messageHint = 'Write your thanks message to the Customer';
    // } else if (task.taskState == 'canceled') {
    //   messageHint = 'Write your thanks message to the Perfomer';
    // }
    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerWidth = dialogConstraints.maxWidth - 50;
      // print (dialogConstraints.maxWidth);

      return PageView(
        scrollDirection: Axis.horizontal,
        // pageSnapping: false,
        // physics: BouncingScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        controller: interface.tasksController,
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
          Column(
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
          Column(
            children: [
              // const SizedBox(height: 50),
              Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: GestureDetector(
                    onTap: () {
                      interface.tasksController.animateToPage(
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
                                  maxHeight: tp.didExceedMaxLines ? 79: 65,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                      Container(
                                          padding: const EdgeInsets.all(7.0),
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



                          // ********************** CUSTOMER ROLE ************************* //

                          if (task.taskState == 'completed' &&
                              (fromPage == 'customer' ||
                                  tasksServices.hardhatDebug == true))
                            Container(
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

                          if (task.taskState == 'completed' &&
                              (fromPage == 'customer' ||
                                  tasksServices.hardhatDebug == true))
                            Container(
                              padding: const EdgeInsets.all(8.0),
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

                          // ****************** PERFORMER AND CUSTOMER ROLE ******************* //
                          // *************************** AUDIT ******************************** //

                          if (task.taskState == "audit" &&
                              task.auditState == "requested" &&
                              (fromPage == 'customer' ||
                                  fromPage == 'performer' ||
                                  tasksServices.hardhatDebug == true))
                            Container(
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
                          if (task.taskState == "audit" &&
                              task.auditState == "performing" &&
                              (fromPage == 'customer' ||
                                  fromPage == 'performer' ||
                                  tasksServices.hardhatDebug == true))
                            Container(
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
                          if (task.taskState == "audit" &&
                              task.auditState == "requested" &&
                              (fromPage == 'customer' ||
                                  fromPage == 'performer' ||
                                  tasksServices.hardhatDebug == true))
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              child: ParticipantList(
                                listType: 'audit',
                                obj: task,
                              ),
                            ),

                          // ************************ AUDITOR ROLE ************************** //
                          // ************************ EMPTY ************************** //
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 14),

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
                        borderRadius: // Shimmer.fromColors(
                            //     baseColor: Colors.grey[300]!,
                            //     highlightColor: Colors.grey[100]!,
                            //     enabled: shimmerEnabled,
                            //     child:
                            BorderRadius.circular(widget.borderRadius),
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
                          ParticipantList(
                            listType: 'customer',
                            obj: task,
                          ),
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
                              interface.tasksController.animateToPage(
                                  interface.dialogPages['topup']!,
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
                  (interface.dialogProcess['buttonName'] != '-'))
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
                              interface.tasksController.animateToPage(
                                  interface.dialogPages['chat']!,
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

              DialogButtonSet(
                  task: task,
                  fromPage: fromPage,
                  width: innerWidth,
                  enableRatingButton: enableRatingButton)
            ],
          ),
          // Shimmer.fromColors(
          //     baseColor: Colors.grey[300]!,
          //     highlightColor: Colors.grey[100]!,
          //     enabled: shimmerEnabled,
          //     child:
          Column(
            children: [
              Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: GestureDetector(
                      onTap: () {
                        interface.tasksController.animateToPage(
                            interface.dialogPages['chat']!,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: Column(
                        children: [
                          Container(
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
                                RichText(
                                    text: TextSpan(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 1.0),
                                        children: <TextSpan>[
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
                                RichText(
                                    text: TextSpan(
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 1.0),
                                        children: <TextSpan>[
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
              const SizedBox(height: 14),
            ],
          ),
          Container(
              padding: const EdgeInsets.all(12),
              child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                      padding: const EdgeInsets.all(6.0),
                      // height: MediaQuery.of(context).size.height * .58,
                      height: widget.topConstraints.maxHeight,
                      // width: MediaQuery.of(context).size.width * .57
                      width: innerWidth,
                      // height: 540,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                      ),
                      child:
                          ChatPage(task: task, tasksServices: tasksServices))))
        ],
      );
    });
  }
}

class DialogButtonSet extends StatefulWidget {
  final Task task;
  final String fromPage;
  final double width;
  // final String message;
  final bool enableRatingButton;

  const DialogButtonSet(
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

class _DialogButtonSetState extends State<DialogButtonSet> {
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
                    message: interface.taskMessage);
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
                    message: interface.taskMessage);
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
                    message: interface.taskMessage);
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
              (fromPage == 'performer' || tasksServices.hardhatDebug == true) &&
              (task.contractValue != 0 || task.contractValueToken != 0))
            // WithdrawButton(object: task),
            TaskDialogButton(
              inactive: false,
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
                    message: interface.taskMessage);
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

          // **************** CUSTOMER AND PERFORMER BUTTONS ****************** //
          // ************************* AUDIT REQUEST ************************* //
          if ((fromPage == 'performer' ||
                  fromPage == 'customer' ||
                  tasksServices.hardhatDebug == true) &&
              (task.taskState == "progress" || task.taskState == "review"))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Request audit',
              buttonColorRequired: Colors.orangeAccent.shade700,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(
                    task.taskAddress, task.participant, 'audit', task.nanoId,
                    message: interface.taskMessage);
                Navigator.pop(context);

                showDialog(
                    context: context,
                    builder: (context) => WalletAction(
                          nanoId: task.nanoId,
                          taskName: 'taskStateChange',
                        ));
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
                    message: interface.taskMessage);
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
                    message: interface.taskMessage);
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
                    message: interface.taskMessage);
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
    var tasksServices = context.watch<TasksServices>();

    SMINumber? rating;

    void _onRiveInit(Artboard artboard) {
      final StateMachineController? controller =
          StateMachineController.fromArtboard(
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
        size: const Size.fromHeight(100),
        // constraints: const BoxConstraints.expand(),
        child: GestureDetector(
          onTap: hitBump,
          child: RiveAnimation.asset(
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
    }

    // this check for WITHDRAW button:
    if (widget.task != null) {
      if (widget.task!.contractValue != 0) {
        _buttonState = true;
      } else if (widget.task!.contractValueToken != 0) {
        if (widget.task!.contractValueToken > tasksServices.transferFee ||
            tasksServices.destinationChain == 'Moonbase') {
          _buttonState = true;
        } else {
          textColor = Colors.white;
          buttonColor = Colors.grey;
          _buttonState = false;
        }
      }
    }

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
