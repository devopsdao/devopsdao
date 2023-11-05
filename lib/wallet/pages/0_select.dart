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
            buttonWidth: innerPaddingWidth, pageController: pageController,
          ),
        if (tasksServices.platform == 'web' && tasksServices.mmAvailable) const SizedBox(height: 12),
          ChooseWalletButton(
            active: true,
            buttonFunction: 'wallet_connect',
            buttonWidth: innerPaddingWidth, pageController: pageController,
          ),
        const Spacer(),
      ],
    );
  }
}