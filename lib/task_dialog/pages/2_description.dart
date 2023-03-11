import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/flutter_flow_util.dart';
import '../widget/dialog_button_widget.dart';
import '../widget/request_audit_alert.dart';

class DescriptionPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final String fromPage;
  final Task task;

  const DescriptionPage({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
    required this.task,
    required this.fromPage,
  }) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double maxStaticInternalDialogWidth = interface.maxStaticInternalDialogWidth;
    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;

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
                                  width: innerPaddingWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(interface.borderRadius),
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: RichText(
                                          text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: <TextSpan>[
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
                                        text: task.contractOwner.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
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
                                              message: '${task.taskAddress} copied to your clipboard!',
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
                                    TextSpan(text: task.taskAddress.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                  ])),
                                ),
                                if (task.performer != EthereumAddress.fromHex('0x0000000000000000000000000000000000000000'))
                                  GestureDetector(
                                    onTap: () async {
                                      Clipboard.setData(ClipboardData(text: task.performer.toString())).then((_) {
                                        Flushbar(
                                                icon: const Icon(
                                                  Icons.copy,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                message: '${task.performer.toString()} copied to your clipboard!',
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
                                      TextSpan(text: task.performer.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
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
                                      TextSpan(text: task.auditor.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
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
                  width: innerPaddingWidth + 8,
                  child: Row(
                    children: [
                      TaskDialogButton(
                        inactive: false,
                        buttonName: 'Request audit',
                        buttonColorRequired: Colors.orangeAccent.shade700,
                        callback: () {
                          showDialog(context: context, builder: (context) => RequestAuditDialog(who: widget.fromPage, task: task));
                        },
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
