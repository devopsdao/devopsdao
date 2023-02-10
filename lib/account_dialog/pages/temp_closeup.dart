import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task.dart';
import '../../blockchain/task_services.dart';
import '../../flutter_flow/theme.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/select_menu.dart';
import '../buttons.dart';

import 'dart:ui' as ui;

import '../fab_buttons.dart';
import '../widget/dialog_button_widget.dart';

class AccountCloseUpPage extends StatefulWidget {
  final double innerPaddingWidth;
  final Account account;
  final double borderRadius;
  final String fromPage;


  const AccountCloseUpPage(
      {Key? key,
        required this.innerPaddingWidth,
        required this.account,
        required this.borderRadius,
        required this.fromPage,
      })
      : super(key: key);

  @override
  _AccountCloseUpPageState createState() => _AccountCloseUpPageState();
}

class _AccountCloseUpPageState extends State<AccountCloseUpPage> {

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

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Account account = widget.account;
    final String fromPage = widget.fromPage;


    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageForStateController!.text = interface.taskMessage;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                elevation: 10,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: GestureDetector(
                  onTap: () {
                    // interface.accountsDialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                    //     duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    // tasksServices.myNotifyListeners();
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.width * .08,
                    // width: MediaQuery.of(context).size.width * .57
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final text = TextSpan(
                        text: account.about,
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
                                          // interface.accountsDialogPagesController.animateToPage(
                                              // interface.dialogCurrentState['pages']['description'] ?? 99,
                                              // duration: const Duration(milliseconds: 400),
                                              // curve: Curves.ease);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Icon(Icons.info_outline_rounded, size: 22, color: Colors.white),
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
              Container(
                padding: const EdgeInsets.only(top: 14.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                      width: innerPaddingWidth,
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
                            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: const []),
                          ),
                        ],
                      )),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 14.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: innerPaddingWidth,
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
                    width: innerPaddingWidth,
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
                                          text: '?? DEV \n', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0)),
                                      TextSpan(
                                          text: '?? aUSDC',
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

                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // ********* Text Input ************ //
              Container(
                padding: const EdgeInsets.only(top: 14.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    // constraints: const BoxConstraints(maxHeight: 500),
                    padding: const EdgeInsets.all(8.0),
                    width: innerPaddingWidth,
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
                        labelText: 'labelMessage',
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
                      style: DodaoTheme.of(context).bodyText1.override(
                        fontFamily: 'Inter',
                        color: Colors.black87,
                        lineHeight: null,
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      // floatingActionButtonAnimator:  NoScalingAnimation(),
      // floatingActionButton: Padding(
      //   // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
      //   padding: const EdgeInsets.only(right: 13, left: 46),
      //   child: SetsOfFabButtons(task: task, fromPage: fromPage, )
      // ),
    );
  }
}