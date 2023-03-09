import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:webthree/credentials.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/flutter_flow_util.dart';
import '../widget/dialog_button_widget.dart';

class AccountCvPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final String fromPage;
  final Account account;


  const AccountCvPage(
      {Key? key,
        required this.screenHeightSizeNoKeyboard,
        required this.innerPaddingWidth,
        required this.account,
        required this.fromPage,
      })
      : super(key: key);

  @override
  _AccountCvPageState createState() => _AccountCvPageState();
}

class _AccountCvPageState extends State<AccountCvPage> {


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Account account = widget.account;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxStaticInternalDialogWidth,
          ),
          child: Column(
            children: [
              Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(interface.borderRadius),
                  child: GestureDetector(
                      onTap: () {
                        // interface.accountsDialogPagesController.animateToPage(
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
                                  width: innerPaddingWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(interface.borderRadius),
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: account.about,
                                                )
                                              ])))),
                            ),
                          ),
                          // const Spacer(),
                        ],
                      ))),

              // const SizedBox(height: 14),
              Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(interface.borderRadius),
                      child: GestureDetector(
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                              // height: MediaQuery.of(context).size.width * .08,
                              // width: MediaQuery.of(context).size.width * .57
                              width: innerPaddingWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(interface.borderRadius),
                              ),
                              child: ListBody(children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    Clipboard.setData(ClipboardData(text: account.walletAddress.toString())).then((_) {
                                      Flushbar(
                                          icon: const Icon(
                                            Icons.copy,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          message: '${account.walletAddress.toString()} copied to your clipboard!',
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
                                        const TextSpan(text: 'Account wallet address: \n', style: TextStyle(height: 1, fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: account.walletAddress.toString(),
                                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                      ])),
                                ),
                              ]))))),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}