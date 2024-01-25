import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../../widgets/icon_image.dart';
import '../../../model_view/mm_model.dart';
import '../../../model_view/wallet_model.dart';
import '../../shared/network_selection.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({
    super.key,
    required this.innerPaddingWidth,
  });
  final double _qrSize = 200;
  final double innerPaddingWidth;

  @override
  Widget build(BuildContext context) {
    final listenWalletSelected = context.select((MetamaskModel vm) => vm.state.mmScreenStatus);
    final listenErrorMessage = context.select((MetamaskModel vm) => vm.state.errorMessage);
    WalletModel walletModel = context.watch<WalletModel>();
    return Column(
      children: [
        if (listenWalletSelected == MMScreenStatus.mmNotConnected)
          Column(
            children: [
              Container(
                height: 130,
                width: 130,
                padding: const EdgeInsets.all(18.0),
                child: SvgPicture.asset(
                  'assets/images/metamask-icon2.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: NetworkSelection(
                  qrSize: _qrSize, walletName: 'metamask',
                ),
              ),
            ],
          ),

        if (listenWalletSelected == MMScreenStatus.mmConnectedNetworkMatch )
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(15.0),
                  height: 140,
                  child: const NetworkIconImage(
                    height: 80,
                  )),
              Text(
                'Current network: \n${walletModel.getNetworkChainName(walletModel.state.chainId!)}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:const EdgeInsets.only(top: 16.0),
                child: NetworkSelection(
                  qrSize: _qrSize, walletName: 'metamask',
                ),
              ),
            ],
          ),

        if (listenWalletSelected == MMScreenStatus.mmConnectedNetworkNotMatch)
          Column(
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
                'Network on your wallet is not supported. \n Check screen for further information\n',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:const EdgeInsets.only(top: 16.0),
                child: NetworkSelection(
                  qrSize: _qrSize, walletName: 'metamask',
                ),
              ),
            ],
          ),
        if (listenWalletSelected == MMScreenStatus.error)
          Column(
            children: [
              Text(
                listenErrorMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:const EdgeInsets.only(top: 16.0),
                child: NetworkSelection(
                  qrSize: _qrSize, walletName: 'metamask',
                ),
              ),
            ],
          ),
        if (listenWalletSelected == MMScreenStatus.rejected)
          Column(
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
                'User rejected',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:const EdgeInsets.only(top: 16.0),
                child: NetworkSelection(
                  qrSize: _qrSize, walletName: 'metamask',
                ),
              ),
            ],
          ),

        // Text(
        //   walletModel.myTest,
        //   style: Theme.of(context).textTheme.bodyMedium,
        //   textAlign: TextAlign.center,
        // ),
      ],
    );
  }
}
