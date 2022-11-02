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


class TaskDialog extends StatefulWidget {
  final String role;
  final String taskAddress;
  const TaskDialog({Key? key, required this.taskAddress, required this.role})
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
        print('role: ${widget.role}');
        return TaskInformationDialog(
            role: widget.role, task: task, shimmerEnabled: false);
      }
    }
    // return TaskInformationDialog(
    //     role: widget.role, task: task, shimmerEnabled: true);

    return const AppDataLoadingDialogWidget();
  }
}

class TaskInformationDialog extends StatefulWidget {
  // final int taskCount;
  final String role;
  final Task task;
  final bool shimmerEnabled;
  const TaskInformationDialog({
    Key? key,
    // required this.taskCount,
    required this.role,
    required this.task,
    required this.shimmerEnabled,
  }) : super(key: key);

  @override
  _TaskInformationDialogState createState() => _TaskInformationDialogState();
}

class _TaskInformationDialogState extends State<TaskInformationDialog> {
  late Task task;
  String backgroundPicture = "assets/images/niceshape.png";

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    task = widget.task;
    final double borderRadius = interface.borderRadius;

    if (widget.role == 'customer') {
      backgroundPicture = "assets/images/cross.png";
    } else if (widget.role == 'performer') {
      backgroundPicture = "assets/images/cyrcle.png";
    } else if (widget.role == 'audit') {
      backgroundPicture = "assets/images/cross.png";
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
          final double screenSizeNoKeyboard = constraints.maxHeight - 120 ;
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
                        Container(
                          width: 30,
                          child: InkWell(
                            onTap: () {
                              interface.TasksController.animateToPage(0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease);
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
                                      Icons.arrow_back,
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
                                Clipboard.setData(new ClipboardData(
                                        text:
                                            'https://dodao.dev/index.html#/${widget.role}/${task.taskAddress.toString()}'))
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
                            // print(widget.role);
                            // context.beamToNamed('/${widget.role}');
                            // context.beamBack();
                            Navigator.pop(context);
                            RouteInformation routeInfo =
                                RouteInformation(location: '/${widget.role}');
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
                      role: widget.role,
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
  final String role;
  final BoxConstraints topConstraints;
  bool shimmerEnabled;

  DialogPages(
      {Key? key,
      // required this.buttonName,
      required this.borderRadius,
      required this.task,
      required this.role,
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

    // interface.taskMessage = messageForStateController!.text;

    Task task = widget.task;
    String role = widget.role;
    bool shimmerEnabled = widget.shimmerEnabled;

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerWidth = dialogConstraints.maxWidth - 50;
      // print (dialogConstraints.maxWidth);
      return PageView(
        scrollDirection: Axis.horizontal,
        // pageSnapping: false,
        // physics: BouncingScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        controller: interface.TasksController,
        // onPageChanged: (number) {
        //   interface.pageWalletViewNumber = number;
        //   tasksServices.myNotifyListeners();
        //   // print(number);
        // },
        children: <Widget>[
          // Shimmer.fromColors(
          //   baseColor: Colors.grey[300]!,
          //   highlightColor: Colors.grey[100]!,
          //   enabled: shimmerEnabled,
          //   child:
          Column(
            children: [
              // const SizedBox(height: 50),
              Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: GestureDetector(
                    onTap: () {
                      interface.TasksController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
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
                          Container(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              task.title,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          Container(
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
                                  ]))),

                          // ********************** CUSTOMER ROLE ************************* //

                          if (task.taskState == 'completed' &&
                              (role == 'customer' ||
                                  tasksServices.hardhatDebug == true))
                            Container(
                              padding: const EdgeInsets.all(6),
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
                              (role == 'customer' ||
                                  tasksServices.hardhatDebug == true))
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RatingBar.builder(
                                    initialRating: 4,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemSize: 30.0,
                                    onRatingUpdate: (rating) {
                                      setState(() {
                                        enableRatingButton = true;
                                      });
                                      ratingScore = rating;
                                      tasksServices.myNotifyListeners();
                                    },
                                  ),
                                ]),

                          // ************************ PERFORMER ROLE ************************** //

                          if (task.taskState == 'completed' &&
                              (role == 'performer' ||
                                  tasksServices.hardhatDebug == true) &&
                              (task.contractValue != 0 ||
                                  task.contractValueToken != 0))
                            SelectNetworkMenu(object: task),

                          // ****************** PERFORMER AND CUSTOMER ROLE ******************* //
                          // *************************** AUDIT ******************************** //

                          if (task.taskState == "audit" &&
                              task.auditState == "requested" &&
                              (role == 'customer' ||
                                  role == 'performer' ||
                                  tasksServices.hardhatDebug == true))
                            RichText(
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
                          if (task.taskState == "audit" &&
                              task.auditState == "performing" &&
                              (role == 'customer' ||
                                  role == 'performer' ||
                                  tasksServices.hardhatDebug == true))
                            RichText(
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
                          if (task.taskState == "audit" &&
                              task.auditState == "requested" &&
                              (role == 'customer' ||
                                  role == 'performer' ||
                                  tasksServices.hardhatDebug == true))
                            ParticipantList(
                              listType: 'audit',
                              obj: task,
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
                  (role == 'customer' || tasksServices.hardhatDebug == true)
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
              if ((task.contractOwner != tasksServices.publicAddress ||
                      tasksServices.hardhatDebug == true) &&
                  tasksServices.publicAddress != null &&
                  tasksServices.validChainID &&
                  role == 'tasks')
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
                          interface.taskMessage = messageForStateController!.text;
                        },

                        decoration: const InputDecoration(
                          labelText: 'Tap to message',
                          labelStyle: TextStyle(
                              fontSize: 17.0, color: Colors.black54),
                          hintText: '[Enter your message here..]',
                          hintStyle: TextStyle(
                              fontSize: 15.0, color: Colors.black54),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                        style:
                            FlutterFlowTheme.of(context).bodyText1.override(
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
              // ChooseWalletButton(active: true, buttonName: 'wallet_connect', borderRadius: widget.borderRadius,),
              const Spacer(),

              DialogButtonSet(
                  task: task,
                  role: role,
                  width: innerWidth,
                  // message: messageForStateController!.text,
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
                        interface.TasksController.animateToPage(2,
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
            padding: const EdgeInsets.all(12  ),
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
  final String role;
  final double width;
  // final String message;
  final bool enableRatingButton;

  const DialogButtonSet(
      {Key? key,
        required this.task,
        required this.role,
        required this.width,
        // required this.message,
        required this.enableRatingButton
      })
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
    String role = widget.role;
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
          if ( role == 'tasks')
            TaskDialogButton(
              inactive: (task.contractOwner !=
                  tasksServices.publicAddress ||
                  tasksServices.hardhatDebug == true)
                  && tasksServices.validChainID &&
                  tasksServices.publicAddress != null ? false : true,
              buttonName: 'Participate',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskParticipate(
                    task.taskAddress, task.nanoId,
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
              (role == 'performer' ||
                  tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Start the task',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(task.taskAddress,
                    task.participant, 'progress', task.nanoId,
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
              (role == 'performer' ||
                  tasksServices.hardhatDebug == true))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Review',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(task.taskAddress,
                    task.participant, 'review', task.nanoId,
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
              (role == 'customer' ||
                  role == 'performer' ||
                  tasksServices.hardhatDebug == true) &&
              (task.contractValue != 0 ||
                  task.contractValueToken != 0))
          // WithdrawButton(object: task),
            TaskDialogButton(
              inactive: false,
              buttonName: 'Withdraw',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.withdrawToChain(
                    task.taskAddress, task.nanoId);
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
          if (role == 'customer' ||
              tasksServices.hardhatDebug == true)
            TaskDialogButton(
              inactive: false,
              buttonName: 'Topup',
              buttonColorRequired: Colors.lightBlue.shade600,
              callback: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Topup contract'),
                      // backgroundColor: Colors.black,
                      content: const Payment(
                        purpose: 'topup',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            tasksServices.addTokens(
                                task.taskAddress,
                                interface.tokensEntered,
                                task.nanoId);
                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) =>
                                    WalletAction(
                                      nanoId: task.nanoId,
                                      taskName: 'addTokens',
                                    ));
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green),
                          child: const Text('Topup contract'),
                        ),
                        TextButton(
                            child: const Text('Close'),
                            onPressed: () =>
                                context.beamToNamed('/tasks')
                          // Navigator.pop(context),
                        ),
                      ],
                    ));
              },
            ),

          if (task.taskState == 'review' &&
              (role == 'customer' ||
                  tasksServices.hardhatDebug == true))
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
              (role == 'customer' ||
                  tasksServices.hardhatDebug == true))
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
          if ((role == 'performer' ||
              role == 'customer' ||
              tasksServices.hardhatDebug == true) &&
              (task.taskState == "progress" ||
                  task.taskState == "review"))
            TaskDialogButton(
              inactive: false,
              buttonName: 'Request audit',
              buttonColorRequired: Colors.orangeAccent.shade700,
              callback: () {
                setState(() {
                  task.justLoaded = false;
                });
                tasksServices.taskStateChange(task.taskAddress,
                    task.participant, 'audit', task.nanoId,
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
          if ((role == 'auditor' ||
              tasksServices.hardhatDebug == true) &&
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

          if ((role == 'auditor' ||
              tasksServices.hardhatDebug == true) &&
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
          if ((role == 'auditor' ||
              tasksServices.hardhatDebug == true) &&
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


class TaskDialogButton extends StatefulWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final Task? task;
  final bool inactive;
  const TaskDialogButton(
      {Key? key,
        required this.buttonName,
        required this.buttonColorRequired,
        required this.callback,
        required this.inactive,
        this.task
      })
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
        text: TextSpan(text: widget.buttonName, style: TextStyle(fontSize: 18, color: textColor)),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: ui.TextDirection.ltr )
      ..layout()).size;
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
              padding: const EdgeInsets.all(10.0),
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
