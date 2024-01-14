import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/wallet_action_dialog.dart';
import '../blockchain/accounts.dart';

class DeleteItemAlert extends StatefulWidget {
  final Task? task;
  final Account? account;
  const DeleteItemAlert({
    Key? key,
    this.task,
    this.account,
  }) : super(key: key);

  @override
  _DeleteItemAlertState createState() => _DeleteItemAlertState();
}

class _DeleteItemAlertState extends State<DeleteItemAlert> {
  late String warningText;
  late String title;
  late String link;
  late String who;

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

    if (widget.task != null) {
      final Task? object = widget.task;
      warningText = 'Task "${object?.title}" will be deleted';
      title = 'Are you sure you want to delete this Task?';
      who = 'task';
    } else if (widget.account != null) {
      final Account? object = widget.account;
      warningText = 'Account "${object?.nickName}" will be banned';
      title = 'Are you sure you want to ban this account?';
      who = 'account';
    }

    link = 'https://docs.dodao.dev/audit_process.html#customer';

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                          style: const TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.bold),
                          text: title,
                        ),
                      ])),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.black45,
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
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 1.0,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Colors.black45,
                      width: 1.0,
                    ),
                  ),
                  labelText: 'Few words about your decision',
                  labelStyle: const TextStyle(fontSize: 17.0, color: Colors.black54),
                  hintText: '[Enter your message here..]',
                  hintStyle: const TextStyle(fontSize: 14.0, color: Colors.black54),
                  // focusedBorder: const UnderlineInputBorder(
                  //   borderSide: BorderSide.none,
                  // ),
                ),
                style: DodaoTheme.of(context).bodyText1.override(
                      fontFamily: 'Inter',
                      color: Colors.black87,
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
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(width: 0.5, color: Colors.black54 //                   <--- border width here
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

                        if (widget.account != null) {
                          tasksServices.addAccountToBlacklist(widget.account!.walletAddress);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => const WalletActionDialog(
                                nanoId: 'addAccountToBlacklist',
                                actionName: 'addAccountToBlacklist',
                              ));

                        } else if (widget.task != null) {
                          tasksServices.addTaskToBlackList(widget.task!.taskAddress, widget.task!.nanoId);
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => WalletActionDialog(
                                nanoId: widget.task!.nanoId,
                                actionName: 'addTaskToBlackList',
                              ));
                        }
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
