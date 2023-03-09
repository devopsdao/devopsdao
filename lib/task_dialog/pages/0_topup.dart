import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/my_tools.dart';
import '../../widgets/payment.dart';
import '../../widgets/wallet_action.dart';
import '../widget/dialog_button_widget.dart';

class TopUpPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final double screenHeightSize;
  final Task task;


  const TopUpPage(
      {Key? key,
        required this.screenHeightSizeNoKeyboard,
        required this.innerPaddingWidth,
        required this.screenHeightSize,
        required this.task,
      })
      : super(key: key);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  TextEditingController? messageControllerForTopup;

  @override
  void initState() {
    super.initState();
    messageControllerForTopup = TextEditingController();
  }

  @override
  void dispose() {
    messageControllerForTopup!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;
    print(widget.screenHeightSize);

    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageControllerForTopup!.text = interface.taskTopupMessage;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // height: widget.screenHeightSizeNoKeyboard,
        // height: widget.screenHeightSize,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: interface.maxStaticInternalDialogWidth,
            // maxHeight: widget.screenHeightSizeNoKeyboard,
            maxHeight: widget.screenHeightSize,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Payment(
                    purpose: 'topup', innerPaddingWidth: innerPaddingWidth),
                // const Spacer(),
                // Container(
                //   padding: const EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 16.0),
                //   width: innerPaddingWidth + 8,
                //   child: Row(
                //     // direction: Axis.horizontal,
                //     // crossAxisAlignment: WrapCrossAlignment.start,
                //     children: [
                //       TaskDialogButton(
                //         // padding: 8.0,
                //         inactive: interface.tokensEntered == 0.0 ? true : false,
                //         buttonName: 'Topup contract',
                //         buttonColorRequired: Colors.lightBlue.shade600,
                //         callback: () {
                //           tasksServices.addTokens(
                //             task.taskAddress,
                //             interface.tokensEntered, task.nanoId,
                //             // message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
                //           );
                //           Navigator.pop(context);
                //           interface.emptyTaskMessage();
                //
                //           showDialog(
                //               context: context,
                //               builder: (context) => WalletAction(
                //                 nanoId: task.nanoId,
                //                 taskName: 'addTokens',
                //               ));
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(interface.borderRadius),
                    child: Container(
                      // constraints: const BoxConstraints(maxHeight: 500),
                      padding: const EdgeInsets.all(8.0),
                      width: innerPaddingWidth,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(interface.borderRadius),
                      ),
                      child: TextFormField(
                        controller: messageControllerForTopup,
                        // onChanged: (_) => EasyDebounce.debounce(
                        //   'messageForStateController',
                        //   Duration(milliseconds: 2000),
                        //   () => setState(() {}),
                        // ),
                        autofocus: false,
                        obscureText: false,
                        onTapOutside: (test) {
                          // FocusScope.of(context).unfocus();
                          interface.taskTopupMessage =
                              messageControllerForTopup!.text;
                        },

                        decoration: const InputDecoration(
                          labelText: 'Your message here..',
                          labelStyle: TextStyle(
                              fontSize: 17.0, color: Colors.black54),
                          hintText: '[Enter your message here..]',
                          hintStyle: TextStyle(
                              fontSize: 14.0, color: Colors.black54),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: DodaoTheme.of(context).bodyText1.override(
                          fontFamily: 'Inter',
                          color: Colors.black87,
                          lineHeight: null,
                        ),
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 65,
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonAnimator:  NoScalingAnimation(),
      floatingActionButton: Padding(
        // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
        padding: const EdgeInsets.only(right: 13, left: 46),
        child: TaskDialogFAB(
          inactive: interface.tokensEntered == 0.0 ? true : false,
          expand: true,
          buttonName: 'Topup contract',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 160, // Keyboard shown?
          callback: () {
            tasksServices.addTokens(
              task.taskAddress,
              interface.tokensEntered, task.nanoId,
              // message: interface.taskMessage.isEmpty ? null : interface.taskMessage);
            );
            Navigator.pop(context);
            interface.emptyTaskMessage();

            showDialog(
                context: context,
                builder: (context) => WalletAction(
                  nanoId: task.nanoId,
                  taskName: 'addTokens',
                ));
          },
        ),
      ),
    );
  }
}