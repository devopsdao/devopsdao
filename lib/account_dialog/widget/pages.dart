import 'package:dodao/account_dialog/widget/pages/0_main.dart';
import 'package:dodao/account_dialog/widget/pages/1_cv.dart';
import 'package:dodao/account_dialog/widget/pages/2_chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class AccountDialogPages extends StatelessWidget {
  final Account account;
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;
  final String accountRole;

  const AccountDialogPages({
    Key? key,
    required this.accountRole,
    required this.account,
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
            accountRole: accountRole,
          ),
          AccountsChatPage(
            innerPaddingWidth: innerPaddingWidth,
            account: account,
          ),
          AccountCvPage(
            screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
            innerPaddingWidth: innerPaddingWidth,
            account: account,
          ),
        ],
      );
    });
  }
}
