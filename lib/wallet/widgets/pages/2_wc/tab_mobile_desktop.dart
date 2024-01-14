import 'package:dodao/wallet/model_view/wc_model.dart';
import 'package:dodao/wallet/widgets/pages/2_wc/wc_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model_view/wallet_model.dart';

class WCMobileDesktopTab extends StatelessWidget {
  const WCMobileDesktopTab({
    super.key,
    required this.listenMobile,
  });

  final bool listenMobile;

  @override
  Widget build(BuildContext context) {
    final listenWalletConnected = context.select((WalletModel vm) => vm.state.walletConnected);

    return Stack(
      alignment: Alignment.center,
      children: [
        if (listenMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Text(
                  listenWalletConnected ? 'Wallet connected' : 'Wallet disconnected',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const WCActionButton(),
              const SizedBox(height: 22),
            ],
          ),
        if (!listenMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),
              RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                    TextSpan(text: 'Connect to Desktop Wallet'),
                  ])),
              const Spacer(),
              const WCActionButton(),
              const SizedBox(height: 22),
            ],
          ),
      ],
    );
  }
}
