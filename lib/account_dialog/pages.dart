import 'package:devopsdao/account_dialog/pages/0_main.dart';
import 'package:devopsdao/account_dialog/pages/1_closeup.dart';
import 'package:devopsdao/account_dialog/pages/2_cv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/accounts.dart';
import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../widgets/chat/main.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class AccountPages extends StatelessWidget {
  // final String buttonName;
  final Account account;
  final String fromPage;
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;
  // bool shimmerEnabled;

  const AccountPages({
    Key? key,
    // required this.buttonName,
    required this.account,
    required this.fromPage,
    // required this.shimmerEnabled,
    required this.screenHeightSize,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;
      // print (dialogConstraints.maxWidth);

      return PageView(
        scrollDirection: Axis.horizontal,

        // pageSnapping: false,
        // physics: ((
        //   fromPage == 'tasks' ||
        //   fromPage == 'auditor' ||
        //   fromPage == 'performer') &&
        //   interface.di6666Num == 1)
        //     ? const RightBlockedScrollPhysics() : null,
        // physics: BouncingScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        controller: interface.dialogPagesController,
        onPageChanged: (number) {
          Provider.of<InterfaceServices>(context, listen: false).updateDialogPageNum(number);
        },
        children: <Widget>[
            AccountMainPage(
              screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
              screenHeightSize: screenHeightSize,
              innerPaddingWidth: innerPaddingWidth,
              account: account,
            ),
            AccountCloseUpPage(
              innerPaddingWidth: innerPaddingWidth,
              account: account,
              borderRadius: interface.borderRadius,
              fromPage: fromPage,
            ),
            AccountCvPage(
              screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
              innerPaddingWidth: innerPaddingWidth,
              account: account,
              fromPage: fromPage,),
          // if (interface.dialogCurrentState['pages'].containsKey('select'))
          //   SelectionPage(screenHeightSize: widget.screenHeightSize, innerPaddingWidth: innerPaddingWidth, task: task),
          //
          // if (interface.dialogCurrentState['pages'].containsKey('chat'))
          //   ChatPage(
          //     task: task,
          //     innerPaddingWidth: innerPaddingWidth)
        ],
      );
    });
  }
}

