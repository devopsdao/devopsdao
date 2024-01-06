import 'package:dodao/wallet/widgets/pages/0_select.dart';
import 'package:dodao/wallet/widgets/pages/1_metamask.dart';
import 'package:dodao/wallet/widgets/pages/2_wc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../blockchain/interface.dart';
import '../../model_view/wallet_model.dart';

class WalletDialogPages extends StatelessWidget {
  final PageController pageController;

  const WalletDialogPages({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletModel walletModel = context.read<WalletModel>();
    var interface = context.read<InterfaceServices>();
    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;
      final double screenHeightSizeNoKeyboard = (dialogConstraints.maxHeight);
      return PageView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (number) {
          if (interface.walletButtonPressed == 'wallet_connect' && number == 1) {
            return;
          }
          walletModel.onPageChanged(number);
        },
        children: <Widget>[
          WalletSelectConnection(innerPaddingWidth: innerPaddingWidth, pageController: pageController,),
          MetamaskPage(innerPaddingWidth: innerPaddingWidth,),
          WalletConnect(screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard, innerPaddingWidth: innerPaddingWidth,),
        ],
      );
    });
  }
}


