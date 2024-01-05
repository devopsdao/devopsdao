import 'package:beamer/beamer.dart';
import 'package:dodao/task_dialog/widget/auditor_decision_alert.dart';
import 'package:dodao/task_dialog/widget/dialog_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/accounts.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../task_item/delete_item_alert.dart';
import '../wallet/model_view/wallet_model.dart';
import '../widgets/wallet_action_dialog.dart';

class SetsOfFabButtonsForAccountDialog extends StatelessWidget {
  final Account account;

  // final String fromPage;

  SetsOfFabButtonsForAccountDialog({
    Key? key,
    required this.account,
    // required this.fromPage,
  }) : super(key: key);

  late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 1700));
  late bool inactiveButton = false;

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    final double buttonWidth = MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120; // Keyboard is here?
    final double buttonWidthLong = MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 160; // Keyboard is here?

    if (listenWalletAddress == account.walletAddress) {
      inactiveButton = true;
    }

    return Builder(builder: (context) {
      // ##################### Ban Action part ######################## //
      // ************************ BAN user ************************** //
      if (true) {
        return TaskDialogFAB(
          inactive: inactiveButton,
          expand: true,
          buttonName: 'Ban this address',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 160, // Keyboard shown?
          callback: () {
              showDialog(context: context, builder: (context) =>
                  DeleteItemAlert(account: account));
          },
        );
      } else if (false) {
        // ********************** remove Ban ************************* //
        return TaskDialogFAB(
          inactive: false,
          expand: true,
          buttonName: 'Remove Ban',
          buttonColorRequired: Colors.lightBlue.shade300,
          widthSize: buttonWidthLong,
          callback: () {

          },
        );
      } else {
        return const Center();
      }
    });
  }
}
