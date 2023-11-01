import 'package:dodao/wallet/pages.dart';
import 'package:flutter/material.dart';
import '../blockchain/interface.dart';
import '../config/theme.dart';
import 'header.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';

class WalletDialog extends StatefulWidget {
  const WalletDialog({
    Key? key,
  }) : super(key: key);

  @override
  _WalletDialogState createState() => _WalletDialogState();
}

class _WalletDialogState extends State<WalletDialog> {
  String backgroundPicture = "assets/images/logo_half.png";
  late PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    if (tasksServices.walletConnectedWC || tasksServices.walletConnectedMM) {
      if (tasksServices.walletConnectedMM) {
        pageController = PageController(initialPage: 1);
      } else if (tasksServices.walletConnectedWC) {
        pageController = PageController(initialPage: 2);
      }
    } else {
      pageController = PageController(initialPage: 0);
    }

    if (tasksServices.closeWalletDialog) {
      Navigator.pop(context);
      tasksServices.closeWalletDialog = false;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return StatefulBuilder(builder: (context, setState) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        final double screenHeightSizeNoKeyboard = constraints.maxHeight * .7;
        final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: DodaoTheme.of(context).borderRadius,
          ),
          backgroundColor: DodaoTheme.of(context).walletBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: DodaoTheme.of(context).borderRadius,
              color: DodaoTheme.of(context).walletBackgroundColor,
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WalletDialogHeader(pageController: pageController),
                  Container(
                    height: screenHeightSize,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.cover, opacity: 0.6),
                    ),
                    child: WalletDialogPages(
                      pageController: pageController,
                      screenHeightSize: screenHeightSize,
                      screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
                    ),
                  ),
                  // Container(height: 10),
                ]),
          ),
        );
      });
    });
  }
}
