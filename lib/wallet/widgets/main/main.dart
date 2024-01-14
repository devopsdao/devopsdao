import 'package:dodao/wallet/model_view/wallet_model.dart';
import 'package:dodao/wallet/widgets/main/pages.dart';
import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import 'header.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    WalletModel walletModel = context.read<WalletModel>();

    if (walletModel.state.walletSelected != WalletSelected.none) {
      if (walletModel.state.walletSelected == WalletSelected.metamask) {
        pageController = PageController(initialPage: 1);
      } else if (walletModel.state.walletSelected == WalletSelected.walletConnect) {
        pageController = PageController(initialPage: 2);
      }
    } else {
      pageController = PageController(initialPage: 0);
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
      final double screenHeightSizeNoKeyboard = (constraints.maxHeight * .75);
      final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
      return Dialog(
        insetPadding: const EdgeInsets.all(14),
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
                WalletDialogHeader(pageController: pageController,
                    walletModel: walletModel),
                Container(
                  height: screenHeightSize,
                  width: 450,
                  decoration: BoxDecoration(
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.cover, opacity: 0.6),
                  ),
                  child: WalletDialogPages(
                    pageController: pageController,
                  ),
                ),
                // Container(height: 10),
              ]),
        ),
      );
    });
  }
}
