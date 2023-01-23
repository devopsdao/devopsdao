import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task.dart';
import '../../blockchain/task_services.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../widgets/select_menu.dart';
import '../main_page_buttons.dart';

import 'dart:ui' as ui;

import '../widget/dialog_button_widget.dart';
import '../widget/rate_widget.dart';

class MainTaskPage extends StatefulWidget {
  final double innerWidth;
  final Task task;
  final double borderRadius;
  final String fromPage;


  const MainTaskPage(
      {Key? key,
        required this.innerWidth,
        required this.task,
        required this.borderRadius,
        required this.fromPage,
      })
      : super(key: key);

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

    final double maxInternalWidth = interface.maxInternalDialogWidth;
    final double innerWidth = widget.innerWidth;
    final Task task = widget.task;
    final String fromPage = widget.fromPage;


    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageForStateController!.text = interface.taskMessage;

    return ConstrainedBox(
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
                // tasksServices.myNotifyListeners();
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
                  final textHeight = TextPainter(text: text, maxLines: 5, textDirection: ui.TextDirection.ltr);
                  final oneLineHeight = TextPainter(text: text, maxLines: 1, textDirection: ui.TextDirection.ltr);
                  textHeight.layout(maxWidth: constraints.maxWidth);
                  oneLineHeight.layout(maxWidth: constraints.maxWidth);
                  final numLines = textHeight.computeLineMetrics().length;

                  // final textHeight =TextPainter(text:span,maxLines: 3,textDirection: TextDirection.ltr);
                  // textHeight.layout(maxWidth: MediaQuery.of(context).size.width); // equals the parent screen width
                  // print(tp.didExceedMaxLines);
                  return LimitedBox(
                    maxHeight: textHeight.didExceedMaxLines ? textHeight.height + 26 : (oneLineHeight.height * 5) + 12,
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
                                    child: RichText(maxLines: 5, text: text)),
                              ),

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
                              text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: const <TextSpan>[
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
                                text:
                                TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: const <TextSpan>[
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
                                      text: '${task.contractValue} DEV \n', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0)),
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


          // ********* GitHub pull/request Input ************ //
          if ( interface.dialogCurrentState['name'] == 'performer-progress' ||
              interface.dialogCurrentState['name'] == 'performer-review' ||
              tasksServices.hardhatDebug == true)
            Container(
              padding:  const EdgeInsets.only(top: 14.0),
              child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // maxWidth: maxInternalWidth,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: innerWidth,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(widget.borderRadius),
                      ),
                      child:  LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  alignment: Alignment.topLeft,
                                  child: const Text('Create a pull request with a following name: '),
                                ),
                                // Container(
                                //   padding: const EdgeInsets.all(5.0),
                                //   alignment: Alignment.topLeft,
                                //   child: Column(
                                //     children: [
                                //       const Text(
                                //         '#NNX-06 Fix glitches on chat page in Task dialog',
                                //         style: TextStyle(fontWeight: FontWeight.bold),
                                //       ),
                                //     ],
                                //   ),
                                // ),


                                GestureDetector(
                                  onTap: () async {
                                    Clipboard.setData(ClipboardData(text: '#NNX-06 Fix glitches on chat page in Task dialog')).then((_) {
                                      Flushbar(
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          message: 'Pull request name copied to your clipboard!',
                                          duration: const Duration(seconds: 2),
                                          backgroundColor: Colors.blueAccent,
                                          shouldIconPulse: false)
                                          .show(context);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.topLeft,
                                    child: RichText(
                                        text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: const [
                                          WidgetSpan(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 5.0),
                                              child: Icon(
                                                Icons.copy,
                                                size: 16,
                                                color: Colors.black26,
                                              ),
                                            )
                                          ),
                                          TextSpan(
                                            text: '#NNX-06 Fix glitches on chat page in Task dialog',
                                            style: TextStyle( fontWeight: FontWeight.bold)
                                          ),
                                        ])),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  alignment: Alignment.topLeft,
                                  child: const Text('In customer repository: '),
                                ),

                                Builder(
                                  builder: (context) {
                                    final Uri toLaunch =
                                    Uri(scheme: 'https', host: 'github.com', path: '/devopsdao/webthree');
                                    return Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.topLeft,
                                      child: GestureDetector(
                                        onTap:  () async {
                                          if (!await launchUrl(
                                            toLaunch,
                                            mode: LaunchMode.externalApplication,
                                          )) {
                                            throw 'Could not launch $toLaunch';
                                          }
                                        },
                                        child: RichText(
                                            text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                            children: [
                                              const WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 5.0),
                                                    child: Icon(
                                                      Icons.link,
                                                      size: 16,
                                                      color: Colors.black26,
                                                    ),
                                                  )
                                              ),

                                              TextSpan(
                                                  text: toLaunch.toString(),
                                                  style: const TextStyle( fontWeight: FontWeight.bold)
                                              ),
                                            ])),
                                      ),
                                    );
                                  }
                                ),


                                // TextFormField(
                                //   controller: pullRequestController,
                                //   autofocus: true,
                                //   obscureText: false,
                                //   onTapOutside: (test) {
                                //     FocusScope.of(context).unfocus();
                                //   },
                                //
                                //   decoration: InputDecoration(
                                //     labelText: 'Create a pull request with a following name:',
                                //     labelStyle:
                                //     const TextStyle(fontSize: 17.0, color: Colors.black54),
                                //     // hintText: '[Job description...]',
                                //     hintStyle:
                                //     const TextStyle(fontSize: 14.0, color: Colors.black54),
                                //     focusedBorder: const UnderlineInputBorder(
                                //       borderSide: BorderSide.none,
                                //     ),
                                //     enabledBorder: const UnderlineInputBorder(
                                //       borderSide: BorderSide.none,
                                //     ),
                                //     suffixIcon: IconButton(
                                //       onPressed: () async {
                                //         final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                //         setState(() {
                                //           pullRequestController!.text = '${clipboardData?.text}';
                                //         });
                                //       },
                                //       icon: const Icon(Icons.content_paste_outlined),
                                //       padding: const EdgeInsets.only(right: 12.0),
                                //       highlightColor: Colors.grey,
                                //       hoverColor: Colors.transparent,
                                //       color: Colors.blueAccent,
                                //       splashColor: Colors.black,
                                //     ),
                                //   ),
                                //   style: FlutterFlowTheme.of(context).bodyText1.override(
                                //     fontFamily: 'Poppins',
                                //     color: Colors.black54,
                                //     lineHeight: 1,
                                //   ),
                                //   minLines: 1,
                                //   maxLines: 1,
                                //   keyboardType: TextInputType.multiline,
                                //   onChanged:  (text) {
                                //
                                //     // debounceNotifyListener.debounce(() {
                                //     //   tasksServices.myNotifyListeners();
                                //     // });
                                //   },
                                // ),

                              ],
                            );
                          }
                      ),
                    ),
                  )
              ),
            ),

          // ********* GitHub pull/request Input ************ //
          if ( interface.dialogCurrentState['name'] == 'performer-review' ||
              tasksServices.hardhatDebug == true)
            Container(
              padding:  const EdgeInsets.only(top: 14.0),
              child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      // maxWidth: maxInternalWidth,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: innerWidth,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(widget.borderRadius),
                      ),
                      child:  LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  alignment: Alignment.topLeft,
                                  child: const Text('Pull request status:'),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                      text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children:  [
                                        const WidgetSpan(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 5.0),
                                              child: Icon(
                                                Icons.api,
                                                size: 16,
                                                color: Colors.black26,
                                              ),
                                            )
                                        ),
                                        interface.statusText
                                      ])),
                                ),

                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  alignment: Alignment.topLeft,
                                  child: const Text(
                                      '* Please wait until your pull request is merged in to '
                                      'the repository or till customer manually accepts Task completion:',
                                  style: TextStyle(fontSize: 10),),
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
                          }
                      ),
                    ),
                  )
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
          //             borderRadius: BorderRadius.circular(widget.borderRadius),
          //             child: Container(
          //                 // constraints: const BoxConstraints(maxHeight: 500),
          //                 padding: const EdgeInsets.all(5.0),
          //                 width: innerWidth,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(widget.borderRadius),
          //                 ),
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
          const Spacer(),

          DialogButtonSetOnFirstPage(task: task, fromPage: fromPage, width: innerWidth, )
        ],
      ),
    );
  }
}