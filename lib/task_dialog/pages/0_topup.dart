import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../config/utils/my_tools.dart';
import '../../widgets/value_input/widget/value_input.dart';
import '../../widgets/wallet_action_dialog.dart';
import '../widget/dialog_button_widget.dart';

class TopUpPage extends StatefulWidget {
  final double innerPaddingWidth;
  final double screenHeightSize;
  final Task task;


  const TopUpPage(
      {Key? key,
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
    // print(widget.screenHeightSize);

    //here we save the values, so that they are not lost when we go to other pages, they will reset on close or topup button:
    messageControllerForTopup!.text = interface.taskTopupMessage;

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,

      body: Container(
        // height: widget.screenHeightSize,
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: InterfaceSettings.maxStaticInternalDialogWidth,
            maxHeight: widget.screenHeightSize,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ValueInput(purpose: 'topup', innerPaddingWidth: innerPaddingWidth),
                // Container(
                //   padding: const EdgeInsets.only(top: 14.0),
                //   child: Material(
                //     elevation: DodaoTheme.of(context).elevation,
                //     borderRadius: DodaoTheme.of(context).borderRadius,
                //     child: Container(
                //       // constraints: const BoxConstraints(maxHeight: 500),
                //       padding: const EdgeInsets.all(8.0),
                //       width: innerPaddingWidth,
                //       decoration: materialMainBoxDecoration,
                //       child: TextFormField(
                //         controller: messageControllerForTopup,
                //         // onChanged: (_) => EasyDebounce.debounce(
                //         //   'messageForStateController',
                //         //   Duration(milliseconds: 2000),
                //         //   () => setState(() {}),
                //         // ),
                //         autofocus: false,
                //         obscureText: false,
                //         onTapOutside: (test) {
                //           // FocusScope.of(context).unfocus();
                //           interface.taskTopupMessage =
                //               messageControllerForTopup!.text;
                //         },
                //
                //         decoration: InputDecoration(
                //           labelText: 'Your message here..',
                //           labelStyle: Theme.of(context).textTheme.bodyMedium,
                //           hintText: '[Enter your message here..]',
                //           hintStyle:  Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
                //           focusedBorder: const UnderlineInputBorder(
                //             borderSide: BorderSide.none,
                //           ),
                //           enabledBorder: const UnderlineInputBorder(
                //             borderSide: BorderSide.none,
                //           ),
                //         ),
                //         style: DodaoTheme.of(context).bodyText1.override(
                //           fontFamily: 'Inter',
                //           color: Colors.black87,
                //           lineHeight: null,
                //         ),
                //         minLines: 1,
                //         maxLines: 5,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 65,
                // )
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
                barrierDismissible: false,
                context: context,
                builder: (context) => WalletActionDialog(
                  nanoId: task.nanoId,
                  actionName: 'addTokens',
                ));
          },
        ),
      ),
    );
  }
}