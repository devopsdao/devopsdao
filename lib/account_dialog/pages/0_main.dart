import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../flutter_flow/theme.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/payment.dart';
import '../../widgets/tags/search_services.dart';
import '../../widgets/tags/wrapped_chip.dart';
import '../../widgets/wallet_action.dart';
import '../widget/dialog_button_widget.dart';

import 'dart:ui' as ui;

class AccountMainPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final double screenHeightSize;
  final Account account;

  const AccountMainPage({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
    required this.screenHeightSize,
    required this.account,
  }) : super(key: key);

  @override
  _AccountMainPageState createState() => _AccountMainPageState();
}

class _AccountMainPageState extends State<AccountMainPage> {
  TextEditingController? messageForStateController;

  @override
  void initState() {
    super.initState();
    messageForStateController = TextEditingController();
  }

  @override
  void dispose() {
    messageForStateController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Account account = widget.account;
    print(widget.screenHeightSize);

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;

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
                borderRadius: BorderRadius.circular(interface.borderRadius),
                child: GestureDetector(
                  onTap: () {
                    // interface.accountsDialogPagesController.animateToPage(interface.dialogCurrentState['pages']['description']!,
                    //     duration: const Duration(milliseconds: 300), curve: Curves.ease);
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.width * .08,
                    // width: MediaQuery.of(context).size.width * .57
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(interface.borderRadius),
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
                                          interface.accountsDialogPagesController
                                              .animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(Icons.arrow_forward_ios_rounded, size: 22, color: Colors.white),
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

              // ************ Show prices and topup part ******** //
              // if (!FocusScope.of(context).hasFocus)
              Container(
                padding: const EdgeInsets.only(top: 14.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(interface.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(interface.borderRadius),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: ListBody(
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: <TextSpan>[
                                  TextSpan(text: '?? FTM \n', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0)),
                                  TextSpan(text: '?? aUSDC', style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0))
                                ])),
                              ],
                            )),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),

              // ************ TAGS *********** //
              Container(
                padding: const EdgeInsets.only(top: 14.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(interface.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(interface.borderRadius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                              text: const TextSpan(style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87), children: <TextSpan>[
                            TextSpan(text: 'NFT collection:'),
                          ])),
                        ),
                        LayoutBuilder(builder: (context, constraints) {
                          final double width = constraints.maxWidth - 66;
                          return Row(
                            children: <Widget>[
                              Consumer<SearchServices>(builder: (context, model, child) {
                                // if (model.tempTagsList.isNotEmpty) {
                                //   return SizedBox(
                                //     width: width,
                                //     child: Wrap(
                                //         alignment: WrapAlignment.start,
                                //         direction: Axis.horizontal,
                                //         children: model.tempTagsList.map((e) {
                                //           return WrappedChip(
                                //               key: ValueKey(e),
                                //               theme: 'white',
                                //               item: e,
                                //               delete: true,
                                //               page: 'create'
                                //           );
                                //         }).toList()),
                                //   );
                                // } else {
                                return Row(
                                  children: <Widget>[
                                    // Container(
                                    //   padding: const EdgeInsets.all(2.0),
                                    //   child: const Icon(Icons.new_releases,
                                    //       size: 45, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                              children: const <TextSpan>[
                                            TextSpan(
                                                text: 'Empty :(',
                                                style: TextStyle(
                                                  height: 1,
                                                )),
                                          ])),
                                    ),
                                  ],
                                );
                                // }
                              }),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonAnimator: NoScalingAnimation(),
      floatingActionButton: Padding(
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: TaskDialogFAB(
          inactive: true,
          expand: true,
          buttonName: 'Do we need actions here?',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 160, // Keyboard shown?
          callback: () {
            // tasksServices.addTokens(
            //   task.taskAddress,
            //   interface.tokensEntered, task.nanoId,
            //   // message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            // );
            // Navigator.pop(context);
            // interface.emptyTaskMessage();
            //
            // showDialog(
            //     context: context,
            //     builder: (context) => WalletAction(
            //       nanoId: task.nanoId,
            //       taskName: 'addTokens',
            //     ));
          },
        ),
      ),
    );
  }
}
