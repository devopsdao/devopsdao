import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../model_view/wallet_model.dart';
import '../../model_view/wc_model.dart';
import '2_wc/main.dart';

class WalletConnect extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;

  const WalletConnect({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
  }) : super(key: key);

  @override
  State<WalletConnect> createState() => _WalletConnectState();
}

class _WalletConnectState extends State<WalletConnect> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      WCModelView wcModelView = context.read<WCModelView>();
      WalletModel walletModel = context.read<WalletModel>();
      if (!walletModel.state.walletConnected) {
        Future.delayed(
          const Duration(seconds: 1), () async {
          await wcModelView.onCreateWalletConnection(context);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
          child: Material(
            elevation: DodaoTheme.of(context).elevation,
            borderRadius: DodaoTheme.of(context).borderRadius,
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
              height: widget.screenHeightSizeNoKeyboard - 36,
              width: widget.innerPaddingWidth,
              decoration: BoxDecoration(
                borderRadius: DodaoTheme.of(context).borderRadius,
                border: DodaoTheme.of(context).borderGradient,
              ),
              child: WalletConnectMainScreen(screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard),
            ),
          ),
        ),
      ],
    );
  }
}
