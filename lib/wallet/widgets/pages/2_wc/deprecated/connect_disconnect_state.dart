import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model_view/wallet_model.dart';

class ConnectDisconnectState extends StatelessWidget {
  const ConnectDisconnectState({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final listenWalletConnected = context.select((WalletModel vm) => vm.state.walletConnected);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Text(
        listenWalletConnected ? 'Wallet connected' : 'Wallet disconnected',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}