import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../widgets/choose_wallet_button.dart';

class WalletSelectConnection extends StatelessWidget {
  final double innerPaddingWidth;
  final PageController pageController;

  const WalletSelectConnection(
      {Key? key,  required this.innerPaddingWidth, required this.pageController,})  : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    return Column(
      children: [
        const SizedBox(height: 30),
        Material(
          color: DodaoTheme.of(context).walletBackgroundColor,
          elevation: DodaoTheme.of(context).elevation,
          borderRadius: DodaoTheme.of(context).borderRadius,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: innerPaddingWidth,
            decoration: BoxDecoration(
              color: DodaoTheme.of(context).walletBackgroundColor,
              borderRadius: DodaoTheme.of(context).borderRadius,
              border: DodaoTheme.of(context).borderGradient,
            ),
            child: Text('By connecting a wallet, you agree to Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),

        const Spacer(),
        if (tasksServices.platform == 'web' && tasksServices.mmAvailable)
          ChooseWalletButton(
            active: tasksServices.platform == 'web' && tasksServices.mmAvailable ? true : false,
            buttonFunction: 'metamask',
            buttonWidth: innerPaddingWidth,
            callback: () {
              interface.walletButtonPressed = 'metamask';
              pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              tasksServices.initComplete ? tasksServices.connectWalletMM() : null;
            },
          ),
        if (tasksServices.platform == 'web' && tasksServices.mmAvailable)
          const SizedBox(height: 12),
        ChooseWalletButton(
          active: true,
          buttonFunction: 'wallet_connect',
          buttonWidth: innerPaddingWidth,
          callback: () {
            interface.walletButtonPressed = 'wallet_connect';
            pageController.animateToPage(2, duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
            tasksServices.initComplete ? tasksServices.connectWalletWCv2(false, tasksServices.allowedChainIds[tasksServices.defaultNetwork]!) : null;
          },
        ),
        const Spacer(),
      ],
    );
  }
}