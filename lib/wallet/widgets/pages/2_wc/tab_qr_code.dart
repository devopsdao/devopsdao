import 'dart:async';

import 'package:dodao/wallet/widgets/main/pages.dart';
import 'package:dodao/wallet/widgets/pages/2_wc/wc_qr_code_image.dart';
import 'package:dodao/wallet/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/flutter_flow_util.dart';
import '../../../../config/theme.dart';
import '../../../../pages/home_page.dart';
import '../../../../widgets/icon_image.dart';
import '../../../../widgets/utils/platform.dart';
import '../../../model_view/wallet_model.dart';
import '../../../model_view/wc_model.dart';
import '../../../services/wallet_service.dart';
import '../../../services/wc_service.dart';
import '../../shared/network_selection.dart';

class WcQrCodeTab extends StatelessWidget {

  final double screenHeightSizeNoKeyboard;
  WcQrCodeTab({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  final _platform = PlatformAndBrowser();
  final double _qrSize = 200;

  @override
  Widget build(BuildContext context) {
    WCModelView wcModelView = context.watch<WCModelView>();
    WalletModel walletModel = context.read<WalletModel>();

    final Widget shimmer = Column(
      children: [
        Shimmer.fromColors(
          baseColor: DodaoTheme.of(context).shimmerBaseColor,
          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
              TextSpan(text: 'Scan QR or select network'),
            ])
          ),
        ),
        Shimmer.fromColors(
          baseColor: DodaoTheme.of(context).shimmerBaseColor,
          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
          child: NetworkSelection(
            qrSize: _qrSize, walletName: 'wc',
          )
        ),
        const SizedBox(
          height: 8,
        ),
        Shimmer.fromColors(
          baseColor: DodaoTheme.of(context).shimmerBaseColor,
          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
          child: Container(
            height: _qrSize,
            width: _qrSize,
            color: Colors.white,
          ),
        ),
      ],
    );

    return AnimatedCrossFade(
      crossFadeState: wcModelView.wcCurrentState == WCScreenStatus.wcNotConnectedWithQrReady ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 700),
      sizeCurve: Curves.easeInOutQuart,

      /////// *********** Has URL ************ /////////
      firstChild: WcQrCodeTabImage(
        screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
        qrSize: _qrSize,
      ),

      /////// *********** NO URL ************ /////////
      secondChild: SizedBox(
        height: screenHeightSizeNoKeyboard - 190,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (wcModelView.wcCurrentState == WCScreenStatus.loadingQr)
              shimmer,
            if (wcModelView.wcCurrentState == WCScreenStatus.loadingWc)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 46.0),
                    child: Text(
                      // 'Performing connection with \n${wcModelView.chainNameOnWCWallet}',
                      'Performing connection to\n${walletModel.getNetworkChainName(wcModelView.state.selectedChainIdOnApp)} \nCheck wallet for further information\n',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  LoadingAnimationWidget.prograssiveDots(
                    size: 18,
                    color: DodaoTheme.of(context).primaryText,
                  ),

                  if (_platform.platform == 'mobile')
                  const Padding(
                    padding: EdgeInsets.only(top: 32.0),
                    child: GoToWalletButton(),
                  ),
                ],
              ),
            if (wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkNotMatch)
              Text(
                'Select desired network \nin your wallet',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkUnknown)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 46.0),
                    child: Text(
                      'Network on your wallet is not supported. \n Check wallet screen for further information\n',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_platform.platform == 'mobile')
                    const Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: GoToWalletButton(),
                    ),
                ],
              ),
            // if (wcModelView.wcCurrentState == WCScreenStatus.wcNotConnectedAddNetwork)
            //   Text(
            //     'Check wallet screen to add new network\n',
            //     style: Theme.of(context).textTheme.bodyMedium,
            //     textAlign: TextAlign.center,
            //   ),
            if (wcModelView.wcCurrentState == WCScreenStatus.error)
              Text(
                wcModelView.state.errorMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (wcModelView.wcCurrentState == WCScreenStatus.wcNotConnected)
              Text(
                'Press connect to generate a \nQR Code',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (walletModel.state.walletConnected && wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkMatch)
              Column(
                children: [
                Text(
                  'Current network: \n${walletModel.getNetworkChainName(wcModelView.state.selectedChainIdOnApp)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  height: 140,
                  child: const NetworkIconImage(
                    height: 80,
                  )),
                ],
              ),
            if (walletModel.state.walletConnected
                && wcModelView.wcCurrentState != WCScreenStatus.loadingWc
                && wcModelView.wcCurrentState != WCScreenStatus.wcNotConnectedAddNetwork
            )
              NetworkSelection(
                qrSize: _qrSize, walletName: 'wc',
              ),
          ],
        ),
      ),
    );
  }
}
