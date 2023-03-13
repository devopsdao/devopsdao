import 'package:dodao/account_dialog/pages/0_main.dart';
import 'package:dodao/account_dialog/pages/2_chat.dart';
import 'package:dodao/account_dialog/pages/temp_closeup.dart';
import 'package:dodao/account_dialog/pages/1_cv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/accounts.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../widgets/chat/main.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class AccountPages extends StatelessWidget {
  final Account account;
  final String fromPage;
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;
  // bool shimmerEnabled;

  const AccountPages({
    Key? key,
    required this.account,
    required this.fromPage,
    // required this.shimmerEnabled,
    required this.screenHeightSize,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;
      return PageView(
        scrollDirection: Axis.horizontal,
        controller: interface.accountsDialogPagesController,
        onPageChanged: (number) {
          Provider.of<InterfaceServices>(context, listen: false).updateAccountsDialogPageNum(number);
        },
        children: <Widget>[
          AccountMainPage(
            screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
            screenHeightSize: screenHeightSize,
            innerPaddingWidth: innerPaddingWidth,
            account: account,
          ),
          // AccountCloseUpPage(
          //   innerPaddingWidth: innerPaddingWidth,
          //   account: account,
          //   borderRadius: interface.borderRadius,
          //   fromPage: fromPage,
          // ),
          AccountsChatPage(
            innerPaddingWidth: innerPaddingWidth,
            account: account,
          ),
          AccountCvPage(
            screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
            innerPaddingWidth: innerPaddingWidth,
            account: account,
            fromPage: fromPage,
          ),

          // if (interface.dialogCurrentState['pages'].containsKey('chat'))
          //   ChatPage(
          //     task: task,
          //     innerPaddingWidth: innerPaddingWidth)
        ],
      );
    });
  }
}
