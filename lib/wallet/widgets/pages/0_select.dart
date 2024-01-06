import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';

import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../../widgets/utils/platform.dart';
import '../../model_view/wallet_model.dart';
import '../../services/wallet_service.dart';
import '../../model_view/metamask_model.dart';
import '../../model_view/wc_model.dart';
import '../../services/wc_service.dart';
import '../shared/choose_wallet_button.dart';

class WalletSelectConnection extends StatefulWidget {
  final double innerPaddingWidth;
  final PageController pageController;

  const WalletSelectConnection(
      {Key? key,  required this.innerPaddingWidth, required this.pageController,})  : super(key: key);

  @override
  State<WalletSelectConnection> createState() => _WalletSelectConnectionState();
}

class _WalletSelectConnectionState extends State<WalletSelectConnection> {
  @override
  Widget build(BuildContext context) {
    final PlatformAndBrowser platformAndBrowser = PlatformAndBrowser();
    WalletModel walletModel = context.read<WalletModel>();
    var interface = context.watch<InterfaceServices>();
    WCModelView wcModelView = context.watch<WCModelView>();
    MetamaskModel metamaskProvider = context.read<MetamaskModel>();
    var tasksServices = context.read<TasksServices>();


    return Column(
      children: [
        const Spacer(),
        Material(
          color: DodaoTheme.of(context).walletBackgroundColor,
          elevation: DodaoTheme.of(context).elevation,
          borderRadius: DodaoTheme.of(context).borderRadius,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: widget.innerPaddingWidth,
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
        if (platformAndBrowser.platform == 'web' && platformAndBrowser.metamaskAvailable)
          ChooseWalletButton(
            active: true,
            buttonName: 'Metamask',
            buttonWidth: widget.innerPaddingWidth,
            callback: () async {
              interface.walletButtonPressed = 'metamask';
              widget.pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
              // metamaskProvider.onCreateMetamaskConnection(context);
              // walletModel.onWalletReset();
              print(int.parse('0xd0da0'.substring(2), radix: 16));

              await metamaskProvider.onCreateMetamaskConnection(tasksServices, walletModel, context);
            },
            buttonColor: Colors.green.shade400,
            assetPath: 'assets/images/metamask-icon2.svg',
          ),
        if (platformAndBrowser.platform == 'web' && platformAndBrowser.metamaskAvailable)
          const SizedBox(height: 12),
        ChooseWalletButton(
          active: wcModelView.state.initComplete ? true : false,
          buttonName: 'Wallet Connect',
          buttonWidth: widget.innerPaddingWidth,
          callback: () async {
            interface.walletButtonPressed = 'wallet_connect';
            widget.pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
            // wcModelView.initComplete ? tasksServices.connectWalletWCv2(false, tasksServices.allowedChainIds[tasksServices.defaultNetwork]!) : null;
            // if (!WalletService.walletConnected && wcModelView.state.initComplete) {
            //
            //
            //
            // }
          },
          buttonColor: Colors.redAccent.shade100,
          assetPath: 'assets/images/wc_logo.svg',
        ),
        const Spacer(),
      ],
    );
  }
}