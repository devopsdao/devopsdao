import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../model_view/mm_model.dart';
import '../../../model_view/wallet_model.dart';

class ProcessScreen extends StatelessWidget {
  const ProcessScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final listenWalletSelected = context.select((MetamaskModel vm) => vm.state.mmScreenStatus);
    final listenChainIdOnMMWallet = context.select((MetamaskModel vm) => vm.state.selectedChainIdOnMMApp);
    WalletModel walletModel = context.read<WalletModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (listenWalletSelected == MMScreenStatus.loadingMetamask)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 130,
                width: 130,
                padding: const EdgeInsets.all(18.0),
                child: SvgPicture.asset(
                  'assets/images/metamask-icon2.svg',
                ),
              ),
              Text(
                'Performing connection to\n${walletModel.getNetworkChainName(listenChainIdOnMMWallet)} \n\nCheck wallet for further information\n',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              LoadingAnimationWidget.prograssiveDots(
                size: 18,
                color: DodaoTheme.of(context).primaryText,
              )
            ],
          ),

      ],
    );
  }
}
