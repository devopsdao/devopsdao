import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/select_menu.dart';
import '../../widgets/tags/tags_old.dart';
import '../../widgets/tags/wrapped_chip.dart';
import '../buttons.dart';

import 'dart:ui' as ui;

import '../fab_buttons.dart';
import '../widget/dialog_button_widget.dart';
import '../widget/rate_widget.dart';

class MainTaskPage extends StatefulWidget {
  final double innerPaddingWidth;
  final Task task;
  final double borderRadius;
  final String fromPage;

  const MainTaskPage({
    Key? key,
    required this.innerPaddingWidth,
    required this.task,
    required this.borderRadius,
    required this.fromPage,
  }) : super(key: key);

  @override
  _MainTaskPageState createState() => _MainTaskPageState();
}

class _MainTaskPageState extends State<MainTaskPage> {
  TextEditingController? pullRequestController;
  TextEditingController? messageForStateController;

  @override
  void initState() {
    super.initState();
    pullRequestController = TextEditingController();
    messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    pullRequestController!.dispose();
    messageForStateController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    // if() {
    //
    // }

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;
    final String fromPage = widget.fromPage;

    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageForStateController!.text = interface.taskMessage;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxStaticInternalDialogWidth,
          ),
          child: Column(
            children: [
              // const SizedBox(height: 50),
              Material(
                elevation: DodaoTheme.of(context).elevation,
                borderRadius: DodaoTheme.of(context).borderRadius,
                child: GestureDetector(
                  onTap: () {
                    interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                        duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    // tasksServices.myNotifyListeners();
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.width * .08,
                    // width: MediaQuery.of(context).size.width * .57
                    width: innerPaddingWidth,
                    decoration: materialMainBoxDecoration,
                    child: LayoutBuilder(builder: (context, constraints) {
                      final text = TextSpan(
                        text: task.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                      final textHeight = TextPainter(text: text, maxLines: 5, textDirection: ui.TextDirection.ltr);
                      final oneLineHeight = TextPainter(text: text, maxLines: 1, textDirection: ui.TextDirection.ltr);
                      textHeight.layout(maxWidth: constraints.maxWidth);
                      oneLineHeight.layout(maxWidth: constraints.maxWidth);
                      final numLines = textHeight.computeLineMetrics().length;

                      // final textHeight =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
                      // textHeight.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width
                      // print(tp.didExceedMaxLines);
                      return LimitedBox(
                        maxHeight:
                            textHeight.didExceedMaxLines ? textHeight.height + 26 : (oneLineHeight.height * (numLines < 3 ? 3 : numLines)) + 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 12.0, 0.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                        padding: const EdgeInsets.all(6.0),
                                        // padding: const EdgeInsets.all(3),
                                        child: RichText(maxLines: 5, text: text)),
                                  ),

                                  // Container(
                                  //   width: 54,
                                  //   padding: const EdgeInsets.all(4.0),
                                  //   child: Material(
                                  //     elevation: 7,
                                  //     borderRadius: DodaoTheme.of(context).borderRadius,
                                  //     color: Colors.lightBlue.shade600,
                                  //     child: InkWell(
                                  //       onTap: () {
                                  //         interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description'] ?? 99,
                                  //             duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                  //       },
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(6.0),
                                  //         child: Icon(Icons.info_outline_rounded, size: 22, color: Colors.white),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  // Container(
                                  //   width: 38,
                                  //   height: 38,
                                  //   // padding: const EdgeInsets.all(2.0),
                                  //   decoration: BoxDecoration(
                                  //     gradient: DodaoTheme.of(context).smallButtonGradient,
                                  //     borderRadius: DodaoTheme.of(context).borderRadius,
                                  //     // boxShadow: [
                                  //     //   BoxShadow(
                                  //     //     color: Colors.grey.withOpacity(0.5),
                                  //     //     spreadRadius: 5,
                                  //     //     blurRadius: 7,
                                  //     //     offset: Offset(0, 3), // changes position of shadow
                                  //     //   ),
                                  //     // ],
                                  //
                                  //   ),
                                  //   child: IconButton(
                                  //     icon: const Icon(Icons.info_outline_rounded, size: 22, color: Colors.white),
                                  //     tooltip: 'Go to next page',
                                  //     onPressed: () {
                                  //       interface.dialogPagesController.animateToPage(
                                  //           interface.dialogCurrentState['pages']['description'] ?? 99,
                                  //           duration: const Duration(milliseconds: 400),
                                  //           curve: Curves.ease
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  // const SizedBox(
                                  //   width: ,
                                  // ),
                                  if (interface.dialogCurrentState['pages'].containsKey('widgets.chat'))
                                    // Container(
                                    //   width: 54,
                                    //   padding: const EdgeInsets.all(4.0),
                                    //   child: Material(
                                    //     elevation: 9,
                                    //     borderRadius: BorderRadius.circular(6),
                                    //     color: Colors.lightBlue.shade600,
                                    //     child: InkWell(
                                    //       onTap: () {
                                    //         interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['widgets.chat'] ?? 99,
                                    //             duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                    //       },
                                    //       child: Container(
                                    //         padding: EdgeInsets.all(6.0),
                                    //         decoration: BoxDecoration(
                                    //           borderRadius: BorderRadius.circular(6),
                                    //         ),
                                    //         child: Icon(Icons.chat_outlined, size: 22, color: Colors.white),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        gradient: DodaoTheme.of(context).smallButtonGradient,
                                        borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.chat_outlined, size: 18, color: Colors.white),
                                        tooltip: 'Go to chat page',
                                        onPressed: () {
                                          interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['widgets.chat'] ?? 99,
                                              duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                        },
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
                                    gradient: DodaoTheme.of(context).smallButtonGradient,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: DodaoTheme.of(context).borderRadius.bottomRight,
                                      bottomLeft: DodaoTheme.of(context).borderRadius.bottomLeft,
                                    ),
                                    // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                  ),
                                  child: RichText(
                                      text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Read more ',
                                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7, color: Colors.white),
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
              //       borderRadius: DodaoTheme.of(context).borderRadius,
              //       child: Container(
              //           width: innerPaddingWidth,
              //           decoration: BoxDecoration(
              //             borderRadius:
              //             DodaoTheme.of(context).borderRadius,
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
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                        padding: const EdgeInsets.only(top: 5.0),
                        width: innerPaddingWidth,
                        decoration: materialMainBoxDecoration,
                        child: Padding(
                          padding: DodaoTheme.of(context).inputEdge,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                    text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
                                  TextSpan(text: 'Rate the task:', style: Theme.of(context).textTheme.bodySmall),
                                ])),
                              ),
                              const RateAnimatedWidget(),
                            ],
                          ),
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
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
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
                                    const Text(
                                      'Warning, this contract on Audit state!',
                                    ),
                                    if (task.auditInitiator == tasksServices.publicAddress &&
                                        interface.dialogCurrentState['pages'].containsKey('select'))
                                      Text(
                                          'There '
                                          '${task.auditors.length == 1 ? 'is' : 'are'} '
                                          '${task.auditors.length.toString()} auditor'
                                          '${task.auditors.length == 1 ? '' : 's'}'
                                          ' waiting for your decision',
                                          style: const TextStyle(
                                              // height: 1.1,
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
                              if (task.auditInitiator == tasksServices.publicAddress && interface.dialogCurrentState['pages'].containsKey('select'))
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
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
                      child: ListBody(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(4.0),
                                child: const Icon(Icons.new_releases,
                                    size: 40, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: RichText(
                                      text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
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
                              ),
                              // TaskDialogButton(
                              //   padding: 6.0,
                              //   inactive: false,
                              //   buttonName: 'Select',
                              //   buttonColorRequired: Colors.orange,
                              //   callback: () {
                              //     interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                              //         duration: const Duration(milliseconds: 400), curve: Curves.ease);
                              //   },
                              // ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: DodaoTheme.of(context).smallButtonGradient,
                                    borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.monetization_on, size: 18, color: Colors.white),
                                    tooltip: 'Go to topup page',
                                    onPressed: () {
                                      interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['topup'] ?? 99,
                                          duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: DodaoTheme.of(context).smallButtonGradient,
                                    borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.person_search_rounded, size: 18, color: Colors.white),
                                    tooltip: 'Go to select page',
                                    onPressed: () {
                                      interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['select'] ?? 99,
                                          duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                    },
                                  ),
                                ),
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
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
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
                                    text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
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
              // Container(
              //   padding: const EdgeInsets.only(top: 14.0),
              //   child: Material(
              //     elevation: DodaoTheme.of(context).elevation,
              //     borderRadius: DodaoTheme.of(context).borderRadius,
              //     child: Container(
              //       padding: const EdgeInsets.all(10.0),
              //       width: innerPaddingWidth,
              //       decoration: materialMainBoxDecoration,
              //       child: Row(
              //         children: <Widget>[
              //           Expanded(
              //               flex: 2,
              //               child: Padding(
              //                 padding: const EdgeInsets.all(4.0),
              //                 child: ListBody(
              //                   children: <Widget>[
              //                     // RichText(
              //                     //     text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
              //                     //   TextSpan(
              //                     //     text: '${task.tokenBalances[0]} ${tasksServices.chainTicker} \n',
              //                     //   ),
              //                     //   TextSpan(
              //                     //     text: '${task.tokenBalances[0]} USDC',
              //                     //   )
              //                     // ])),
              //                   ],
              //                 ),
              //               )),
              //           const Spacer(),
              //           if ((fromPage == 'customer' && interface.dialogCurrentState['name'] != 'customer-completed') ||
              //               tasksServices.hardhatDebug == true)
              //             // TaskDialogButton(
              //             //   padding: 6.0,
              //             //   inactive: false,
              //             //   buttonName: 'Topup',
              //             //   buttonColorRequired: Colors.lightBlue.shade600,
              //             //   callback: () {
              //             //     interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['topup'] ?? 99,
              //             //         duration: const Duration(milliseconds: 400), curve: Curves.ease);
              //             //   },
              //             // ),
              //
              //             Container(
              //               width: 36,
              //               height: 36,
              //               decoration: BoxDecoration(
              //                 gradient: DodaoTheme.of(context).smallButtonGradient,
              //                 borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
              //               ),
              //               child: IconButton(
              //                 icon: const Icon(Icons.monetization_on, size: 18, color: Colors.white),
              //                 tooltip: 'Go to topup page',
              //                 onPressed: () {
              //                   interface.dialogPagesController.animateToPage(interface.dialogCurrentState['pages']['topup'] ?? 99,
              //                       duration: const Duration(milliseconds: 400), curve: Curves.ease);
              //                 },
              //               ),
              //             ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
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

              // ************ TAGS *********** //
              Container(
                padding: const EdgeInsets.only(top: 14.0),
                child: Material(
                  elevation: DodaoTheme.of(context).elevation,
                  borderRadius: DodaoTheme.of(context).borderRadius,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    width: innerPaddingWidth,
                    decoration: materialMainBoxDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RichText(
                              text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                            TextSpan(text: 'Tags and NFT attached:'),
                          ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: LayoutBuilder(builder: (context, constraints) {
                            final double width = constraints.maxWidth - 66;
                            // print (task.tokenBalances);
                            final List<TokenItem> tags = task.tags.map((name) => TokenItem(collection: true, name: name)).toList();
                            for (int i = 0; i < task.tokenNames.length; i++) {
                              for (var e in task.tokenNames[i]) {
                                if (task.tokenNames[i].first == 'ETH') {
                                  tags.add(TokenItem(collection: true, nft: false, balance: task.tokenBalances[i], name: e.toString()));
                                } else {
                                  if (task.tokenBalances[i] == 0) {
                                    tags.add(TokenItem(collection: true, nft: true, inactive: true, name: e.toString()));
                                  } else {
                                    tags.add(TokenItem(collection: true, nft: true, inactive: false, name: e.toString()));
                                  }
                                }
                              }
                            }

                            if (tags.isNotEmpty) {
                              return SizedBox(
                                width: width,
                                child: Wrap(
                                    alignment: WrapAlignment.start,
                                    direction: Axis.horizontal,
                                    children: tags.map((e) {
                                      return WrappedChip(
                                        key: ValueKey(e),
                                        item: MapEntry(
                                            e.name,
                                            NftCollection(
                                              selected: false,
                                              name: e.name,
                                              bunch: {
                                                BigInt.from(0):
                                                    TokenItem(name: e.name, nft: e.nft, inactive: e.inactive, balance: e.balance, collection: true)
                                              },
                                            )),
                                        page: 'tasks',
                                        selected: e.selected,
                                        wrapperRole: WrapperRole.selectNew,
                                      );
                                    }).toList()),
                              );
                            } else {
                              return Row(
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const <TextSpan>[
                                    TextSpan(
                                        text: 'Nothing here',
                                        style: TextStyle(
                                          height: 1,
                                        )),
                                  ])),
                                ],
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ********* Text Input ************ //
              if (interface.dialogCurrentState['name'] == 'tasks-new-logged' ||
                  interface.dialogCurrentState['name'] == 'performer-agreed' ||
                  interface.dialogCurrentState['name'] == 'performer-progress' ||
                  interface.dialogCurrentState['name'] == 'customer-review' ||
                  tasksServices.hardhatDebug == true)
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      // constraints: const BoxConstraints(maxHeight: 500),
                      padding: DodaoTheme.of(context).inputEdge,
                      width: innerPaddingWidth,
                      decoration: materialMainBoxDecoration,
                      child: TextFormField(
                        controller: messageForStateController,
                        // onChanged: (_) => EasyDebounce.debounce(
                        //   'messageForStateController',
                        //   Duration(milliseconds: 2000),
                        //   () => setState(() {}),
                        // ),
                        autofocus: true,
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
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          hintText: '[Enter your message here..]',
                          hintStyle: Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.6),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        minLines: 1,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ),

              // ********* GitHub pull/request Performer ************ //
              if ((interface.dialogCurrentState['name'] == 'performer-progress' ||
                      interface.dialogCurrentState['name'] == 'performer-review' ||
                      tasksServices.hardhatDebug == true) &&
                  task.repository.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            // maxWidth: maxStaticInternalDialogWidth,
                            ),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Column(
                              children: <Widget>[
                                if (interface.dialogCurrentState['name'] == 'performer-progress' ||
                                    interface.dialogCurrentState['name'] == 'performer-review' ||
                                    tasksServices.hardhatDebug == true)
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Create a pull request with the following name: ',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () async {
                                    // Clipboard.setData(ClipboardData(text: "dodao.dev/#/tasks/${task.taskAddress} task: ${task.title}")).then((_) {
                                    Clipboard.setData(ClipboardData(text: "dodao.dev/#/tasks/${task.taskAddress}")).then((_) {
                                      Flushbar(
                                              icon: Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: DodaoTheme.of(context).flushTextColor,
                                              ),
                                              message: 'Pull request name: dodao.dev/#/tasks/${task.taskAddress} copied to your clipboard!',
                                              duration: const Duration(seconds: 2),
                                              backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                              shouldIconPulse: false)
                                          .show(context);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.topLeft,
                                    child: Text.rich(
                                      TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                        WidgetSpan(
                                            child: Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.copy,
                                            size: 16,
                                            color: DodaoTheme.of(context).flushTextColor,
                                          ),
                                        )),
                                        TextSpan(text: "dodao.dev/#/tasks/${task.taskAddress}", style: const TextStyle(fontWeight: FontWeight.bold)
                                            // style: const TextStyle(fontWeight: FontWeight.w700)
                                            ),
                                      ]),

                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      // RichText(
                                      //     text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                      //   const WidgetSpan(
                                      //       child: Padding(
                                      //     padding: EdgeInsets.only(right: 5.0),
                                      //     child: Icon(
                                      //       Icons.copy,
                                      //       size: 16,
                                      //       color: Colors.black26,
                                      //     ),
                                      //   )),
                                      //   TextSpan(
                                      //       text: "dodao.dev/#/tasks/${task.taskAddress}",
                                      //       style: const TextStyle(
                                      //         overflow: TextOverflow.fade,
                                      //         )
                                      //       // style: const TextStyle(fontWeight: FontWeight.w700)
                                      //   ),
                                      // ])
                                    ),
                                  ),
                                ),
                                if (interface.dialogCurrentState['name'] == 'performer-progress' ||
                                    interface.dialogCurrentState['name'] == 'performer-review' ||
                                    tasksServices.hardhatDebug == true)
                                  Column(
                                    children: [
                                      Container(
                                        // padding: const EdgeInsets.only(top: 8),
                                        alignment: Alignment.topLeft,
                                        child: const Text('Repository to create a pull request in:'),
                                      ),
                                      Builder(builder: (context) {
                                        final Uri toLaunch = Uri.parse('https://github.com${widget.task.repository}');
                                        // final Uri toLaunch = Uri(scheme: 'https', host: 'github.com', path: '/devopsdao/webthree');
                                        return Container(
                                          padding: const EdgeInsets.all(8.0),
                                          alignment: Alignment.topLeft,
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (!await launchUrl(
                                                toLaunch,
                                                mode: LaunchMode.externalApplication,
                                              )) {
                                                throw 'Could not launch $toLaunch';
                                              }
                                            },
                                            child: RichText(
                                                text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                              WidgetSpan(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(right: 5.0),
                                                child: Icon(
                                                  Icons.link,
                                                  size: 16,
                                                  color: DodaoTheme.of(context).primaryText,
                                                ),
                                              )),
                                              TextSpan(text: toLaunch.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                            ])),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                if (interface.dialogCurrentState['name'] == 'performer-review' || tasksServices.hardhatDebug == true)
                                  Builder(builder: (context) {
                                    // late bool response = false;
                                    // late List response2 = [];
                                    late String status = '';
                                    late MaterialColor statusColor = Colors.yellow;
                                    if (tasksServices.witnetGetLastResult[2] == '') {
                                      status = '';
                                    } else if (tasksServices.witnetGetLastResult[2] == 'checking') {
                                      status = 'checking';
                                      statusColor = Colors.yellow;
                                    } else if (tasksServices.witnetGetLastResult[0] &&
                                        tasksServices.witnetGetLastResult[2] == 'Unknown error (0x30)') {
                                      status = '${tasksServices.witnetGetLastResult[2]}'; //request failed
                                    } else if (tasksServices.witnetGetLastResult[0] &&
                                        tasksServices.witnetGetLastResult[2] == 'Unknown error (0x70)') {
                                      status = 'Unknown error (0x70)'; //request failed
                                      statusColor = Colors.yellow;
                                    } else if (tasksServices.witnetGetLastResult[1] ||
                                        tasksServices.witnetGetLastResult[2] == 'WitnetErrorsLib: assertion failed') {
                                      status = 'no matching PR';
                                      statusColor = Colors.yellow;
                                    } else if (tasksServices.witnetGetLastResult[2] == 'closed') {
                                      status = 'PR merged';
                                      statusColor = Colors.green;
                                    } else if (tasksServices.witnetGetLastResult[2] == '(unmerged)') {
                                      status = 'PR open, not merged';
                                      statusColor = Colors.yellow;
                                    } else {
                                      status = 'error';
                                      statusColor = Colors.red;
                                    }

                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          // padding: const EdgeInsets.only(top: 8),
                                          alignment: Alignment.topLeft,
                                          child: const Text('Pull request status:'),
                                        ),

                                        // Row(
                                        //   children: [
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(4.0),
                                        //       child: GestureDetector(
                                        //         onTap: () async {
                                        //           tasksServices.checkWitnetResultAvailability(task.taskAddress);
                                        //         },
                                        //         child: Container(
                                        //             width: 76,
                                        //             height: 36,
                                        //             decoration: BoxDecoration(
                                        //               gradient: DodaoTheme.of(context).smallButtonGradient,
                                        //               borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                        //             ),
                                        //             child: const Center(
                                        //               child: Text(
                                        //                 'checkResult',
                                        //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                        //               ),
                                        //             )),
                                        //       ),
                                        //     ),
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(4.0),
                                        //       child: GestureDetector(
                                        //         onTap: () async {
                                        //           await tasksServices.getLastWitnetResult(task.taskAddress);
                                        //         },
                                        //         child: Container(
                                        //             width: 86,
                                        //             height: 36,
                                        //             decoration: BoxDecoration(
                                        //               gradient: DodaoTheme.of(context).smallButtonGradient,
                                        //               borderRadius: DodaoTheme.of(context).borderRadiusSmallIcon,
                                        //             ),
                                        //             child: const Center(
                                        //               child: Text(
                                        //                 'getLastWitnetResult',
                                        //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                        //               ),
                                        //             )),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                              text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                            WidgetSpan(
                                                child: Padding(
                                              padding: const EdgeInsets.only(right: 5.0),
                                              child: Icon(
                                                Icons.api,
                                                size: 16,
                                                color: DodaoTheme.of(context).primaryText,
                                              ),
                                            )),
                                            TextSpan(
                                                text: tasksServices.witnetPostResult,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: (() {
                                                    if (tasksServices.witnetPostResult == 'initialized request') {
                                                      return Colors.yellow;
                                                    } else if (tasksServices.witnetPostResult == 'request mined') {
                                                      return Colors.yellow;
                                                    } else if (tasksServices.witnetPostResult == 'request failed') {
                                                      return Colors.redAccent;
                                                    } else if (tasksServices.witnetPostResult == 'result available') {
                                                      return Colors.green;
                                                    } else {
                                                      return DodaoTheme.of(context).primaryText;
                                                    }
                                                  }()),
                                                )),
                                            if (tasksServices.witnetPostResult == 'initialized request')
                                              WidgetSpan(
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 3.0, right: 4.0),
                                                  // alignment: Alignment.bottomCenter,
                                                  // height: 23,
                                                  child: LoadingAnimationWidget.fourRotatingDots(
                                                    size: 15,
                                                    color: DodaoTheme.of(context).secondaryText,
                                                  ),
                                                ),
                                              ),
                                          ])),
                                        ),

                                        if (tasksServices.witnetPostResult == 'request mined' || tasksServices.witnetPostResult == 'result available')
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                            child: RichText(
                                                text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                              WidgetSpan(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(right: 5.0),
                                                child: Icon(
                                                  Icons.api,
                                                  size: 16,
                                                  color: DodaoTheme.of(context).primaryText,
                                                ),
                                              )),
                                              TextSpan(text: status, style: const TextStyle(fontWeight: FontWeight.bold)),
                                              if (status == 'checking')
                                                WidgetSpan(
                                                  child: Container(
                                                    padding: const EdgeInsets.only(left: 3.0, right: 4.0),
                                                    // alignment: Alignment,
                                                    // height: 20,
                                                    child: LoadingAnimationWidget.fourRotatingDots(
                                                      size: 15,
                                                      color: DodaoTheme.of(context).secondaryText,
                                                    ),
                                                  ),
                                                ),
                                            ])),
                                          ),

                                        // Container(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   alignment: Alignment.topLeft,
                                        //   child: RichText(
                                        //       text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: const [
                                        //     WidgetSpan(
                                        //         child: Padding(
                                        //       padding: EdgeInsets.only(right: 5.0),
                                        //       child: Icon(
                                        //         Icons.api,
                                        //         size: 16,
                                        //         color: Colors.black26,
                                        //       ),
                                        //     )),
                                        //     // TextSpan(text: response2[2], style: TextStyle(fontWeight: FontWeight.bold))
                                        //     // interface.statusText
                                        //   ])),
                                        // ),
                                        if (interface.dialogCurrentState['name'] == 'performer-review' || tasksServices.hardhatDebug == true)
                                          Container(
                                            padding: const EdgeInsets.only(top: 8),
                                            alignment: Alignment.topLeft,
                                            child: const Text(
                                              '* Please wait until your pull request is merged in to '
                                              'the repository or till customer manually accepts Task completion:',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),

                                        // Container(
                                        //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                        //   alignment: Alignment.topLeft,
                                        //   child: RichText(
                                        //       text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                        //           children: const [
                                        //             WidgetSpan(
                                        //                 child: Padding(
                                        //                   padding: EdgeInsets.only(right: 5.0),
                                        //                   child: Icon(
                                        //                     Icons.api,
                                        //                     size: 16,
                                        //                     color: Colors.black26,
                                        //                   ),
                                        //                 )
                                        //             ),
                                        //
                                        //             TextSpan(
                                        //                 text: 'Open',
                                        //                 style: TextStyle( fontWeight: FontWeight.bold)
                                        //             ),
                                        //           ])),
                                        // ),
                                        // Container(
                                        //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                        //   alignment: Alignment.topLeft,
                                        //   child: RichText(
                                        //       text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                        //           children: const [
                                        //             WidgetSpan(
                                        //                 child: Padding(
                                        //                   padding: EdgeInsets.only(right: 5.0),
                                        //                   child: Icon(
                                        //                     Icons.api,
                                        //                     size: 16,
                                        //                     color: Colors.black26,
                                        //                   ),
                                        //                 )
                                        //             ),
                                        //
                                        //             TextSpan(
                                        //                 text: 'Closed (merged)',
                                        //                 style: TextStyle( fontWeight: FontWeight.bold)
                                        //             ),
                                        //           ])),
                                        // ),
                                        // Container(
                                        //   padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                        //   alignment: Alignment.topLeft,
                                        //   child: RichText(
                                        //       text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                        //           children: const [
                                        //             WidgetSpan(
                                        //                 child: Padding(
                                        //                   padding: EdgeInsets.only(right: 5.0),
                                        //                   child: Icon(
                                        //                     Icons.api,
                                        //                     size: 16,
                                        //                     color: Colors.black26,
                                        //                   ),
                                        //                 )
                                        //             ),
                                        //
                                        //             TextSpan(
                                        //                 text: 'Closed (rejected)',
                                        //                 style: TextStyle( fontWeight: FontWeight.bold)
                                        //             ),
                                        //           ])),
                                        // )
                                      ],
                                    );
                                  }),
                              ],
                            );
                          }),
                        ),
                      )),
                ),

              // // ********* GitHub pull/request Status ************ //
              //
              //   Container(
              //     padding: const EdgeInsets.only(top: 14.0),
              //     child: Material(
              //         elevation: DodaoTheme.of(context).elevation,
              //         borderRadius: DodaoTheme.of(context).borderRadius,
              //         child: ConstrainedBox(
              //           constraints: const BoxConstraints(
              //               // maxWidth: maxStaticInternalDialogWidth,
              //               ),
              //           child: Center()
              //         )),
              //   ),

              // ********* GitHub pull/request Link Information ************ //
              if (((interface.dialogCurrentState['name'] == 'customer-new' ||
                          interface.dialogCurrentState['name'] == 'customer-progress' ||
                          interface.dialogCurrentState['name'] == 'customer-agreed' ||
                          // interface.dialogCurrentState['name'] == 'performer-new' ||
                          interface.dialogCurrentState['name'] == 'performer-agreed') &&
                      widget.task.repository.isNotEmpty) ||
                  tasksServices.hardhatDebug == true)
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                      elevation: DodaoTheme.of(context).elevation,
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            // maxWidth: maxStaticInternalDialogWidth,
                            ),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: innerPaddingWidth,
                          decoration: materialMainBoxDecoration,
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  alignment: Alignment.topLeft,
                                  child: const Text('Repository to create a pull request in:'),
                                ),

                                // Container(
                                //   padding: const EdgeInsets.all(8.0),
                                //   alignment: Alignment.topLeft,
                                //   child: RichText(
                                //       text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                //         const WidgetSpan(
                                //             child: Padding(
                                //               padding: EdgeInsets.only(right: 5.0),
                                //               child: Icon(
                                //                 Icons.api,
                                //                 size: 16,
                                //                 color: Colors.black26,
                                //               ),
                                //             )),
                                //         TextSpan(text: widget.task.repository, style: const TextStyle(fontWeight: FontWeight.bold))
                                //       ])),
                                // ),

                                GestureDetector(
                                  onTap: () async {
                                    Clipboard.setData(ClipboardData(text: 'https://github.com${widget.task.repository}')).then((_) {
                                      Flushbar(
                                              icon: Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: DodaoTheme.of(context).flushTextColor,
                                              ),
                                              message: 'https://github.com${widget.task.repository} copied to your clipboard!',
                                              duration: const Duration(seconds: 2),
                                              backgroundColor: DodaoTheme.of(context).flushForCopyBackgroundColor,
                                              shouldIconPulse: false)
                                          .show(context);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                        text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
                                      WidgetSpan(
                                          child: Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: Icon(
                                          Icons.copy,
                                          size: 16,
                                          color: DodaoTheme.of(context).flushTextColor,
                                        ),
                                      )),
                                      TextSpan(
                                          text: 'https://github.com${widget.task.repository}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ])),
                                  ),
                                ),

                                // Container(
                                //   padding: const EdgeInsets.only(top: 8),
                                //   alignment: Alignment.topLeft,
                                //   child: const Text(
                                //     '* this ',
                                //     style: TextStyle(fontSize: 10),
                                //   ),
                                // ),
                              ],
                            );
                          }),
                        ),
                      )),
                ),

              // ************** PERFORMER ROLE NETWORK CHOOSE *************** //

              // if ((task.tokenBalances[0] != 0 || task.tokenBalances[0] != 0) &&
              //     (interface.dialogCurrentState['name'] == 'performer-completed' || tasksServices.hardhatDebug == true))
              //   // if (task.taskState == 'completed' &&
              //   //     (fromPage == 'performer' ||
              //   //         tasksServices.hardhatDebug == true) &&
              //   //     (task.contractValue != 0 || task.contractValueToken != 0))
              //   Container(
              //     padding: const EdgeInsets.only(top: 14.0),
              //     child: Material(
              //       elevation: DodaoTheme.of(context).elevation,
              //       borderRadius: DodaoTheme.of(context).borderRadius,
              //       child: Container(
              //         // constraints: const BoxConstraints(maxHeight: 500),
              //         padding: const EdgeInsets.all(8.0),
              //         width: innerPaddingWidth,
              //         decoration: materialMainBoxDecoration,
              //         child: SelectNetworkMenu(object: task),
              //       ),
              //     ),
              //   ),

              // ChooseWalletButton(active: true, buttonName: 'wallet_connect', borderRadius: widget.borderRadius,),

              // if (tasksServices.interchainSelected.isNotEmpty)
              //   Container(
              //     padding: const EdgeInsets.only(right: 25.0, top: 14.0),
              //     child: Row(
              //       children: [
              //         const Spacer(),
              //         Container(
              //           width: 220,
              //           padding: const EdgeInsets.only(),
              //           child: Material(
              //             elevation: 10,
              //             borderRadius: DodaoTheme.of(context).borderRadius,
              //             child: Container(
              //                 // constraints: const BoxConstraints(maxHeight: 500),
              //                 padding: const EdgeInsets.all(5.0),
              //                 width: innerPaddingWidth,
              //                 decoration: materialMainBoxDecoration,
              //                 child: Column(
              //                   children: [
              //                     const Text('Interchain protocol:'),
              //                     Container(
              //                       padding: const EdgeInsets.all(2.0),
              //                       // width: 128,
              //                       child: interface.interchainImages[tasksServices.interchainSelected],
              //                     ),
              //                   ],
              //                 )),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // const Spacer(),

              // DialogButtonSetOnFirstPage(task: task, fromPage: fromPage, width: innerPaddingWidth, )
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButton: Padding(
          // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
          padding: const EdgeInsets.only(right: 13, left: 46),
          child: SetsOfFabButtons(
            task: task,
            fromPage: fromPage,
          )),
    );
  }
}
