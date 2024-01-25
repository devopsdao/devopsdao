import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/wallet_action_dialog.dart';

class RequestAuditDialog extends StatefulWidget {
  final String who;
  final Task task;
  const RequestAuditDialog({Key? key, required this.who, required this.task}) : super(key: key);

  @override
  _RequestAuditDialogState createState() => _RequestAuditDialogState();
}

class _RequestAuditDialogState extends State<RequestAuditDialog> {
  late String warningText;
  late String title;
  late String link;

  TextEditingController? messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final Task task = widget.task;

    title = 'Are you sure you want to start the Audit process?';

    if (widget.who == 'customer') {
      warningText = '';

      // warningText = 'You will have to top-up the contract with 10% from the Task price, totaling: 10 USDC. For more information:';
      link = 'https://docs.dodao.dev/audit_process.html#customer';
    } else if (widget.who == 'performer') {
      warningText = 'Auditor will receive 10% from the funds allocated to the task, totaling: 10 USDC. For more information:';
      link = 'https://docs.dodao.dev/audit_process.html#performer';
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: DodaoTheme.of(context).borderRadius,
      ),
      child: SizedBox(
        height: 440,
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      // style: DefaultTextStyle
                      //     .of(context)
                      //     .style
                      //     .apply(fontSizeFactor: 1.1),
                      children: <TextSpan>[
                        TextSpan(
                          style: TextStyle(color: DodaoTheme.of(context).primaryText, fontSize: 17, fontWeight: FontWeight.bold),
                          text: title,
                        ),
                      ])),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.warning_amber,
                  color: DodaoTheme.of(context).secondaryText,
                  size: 110,
                ),
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.1), children: <TextSpan>[
                    TextSpan(
                      text: warningText,
                    ),
                  ])),
              const Spacer(),
              TextFormField(
                controller: messageController,
                // onChanged: (_) => EasyDebounce.debounce(
                //   'messageForStateController',
                //   Duration(milliseconds: 2000),
                //   () => setState(() {}),
                // ),
                autofocus: false,
                obscureText: false,
                onTapOutside: (test) {
                  FocusScope.of(context).unfocus();
                  interface.taskMessage = messageController!.text;
                },

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 1.0,
                    ),
                  ),
                  labelText: interface.dialogCurrentState['secondLabelMessage'],
                  labelStyle: TextStyle(fontSize: 17.0, color: DodaoTheme.of(context).secondaryText),
                  hintText: '[Enter your message here..]',
                  hintStyle: TextStyle(fontSize: 14.0, color: DodaoTheme.of(context).secondaryText),
                  // focusedBorder: const UnderlineInputBorder(
                  //   borderSide: BorderSide.none,
                  // ),
                ),
                style: DodaoTheme.of(context).bodyText1.override(
                      fontFamily: 'Inter',
                      color: DodaoTheme.of(context).secondaryText,
                      lineHeight: null,
                    ),
                minLines: 2,
                maxLines: 3,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        interface.emptyTaskMessage();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        //MediaQuery.of(context).size.width * .08,
                        // width: halfWidth,
                        decoration: BoxDecoration(
                          borderRadius: DodaoTheme.of(context).borderRadius,
                          border: Border.all(
                              width: 0.5,
                              color: DodaoTheme.of(context).buttonTextColor
                              ),
                        ),
                        child: Text(
                          'Close',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: DodaoTheme.of(context).buttonTextColor ,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        Navigator.pop(context);
                        // Navigator.pop(interface.mainDialogContext);
                        interface.emptyTaskMessage();

                        setState(() {
                          task.loadingIndicator = true;
                        });
                        tasksServices.taskStateChange(task.taskAddress, task.performer, 'audit', task.nanoId,
                          message: messageController!.text.isEmpty ? null : messageController!.text);
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => WalletActionDialog(
                            nanoId: task.nanoId,
                            actionName: 'taskStateChange',
                          )
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 54.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: DodaoTheme.of(context).borderRadius,
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
