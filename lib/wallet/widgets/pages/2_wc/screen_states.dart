import 'package:dodao/wallet/widgets/pages/2_wc/qr_image.dart';
import 'package:dodao/wallet/widgets/shared/buttons.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/theme.dart';
import '../../../../widgets/icon_image.dart';
import '../../../../config/utils/platform.dart';
import '../../../model_view/wallet_model.dart';
import '../../../model_view/wc_model.dart';
import '../../shared/network_selection.dart';

class WCStates extends StatelessWidget {

  final double screenHeightSizeNoKeyboard;
  WCStates({
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
      firstChild: QrCodeImage(
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
                  Container(
                    padding: const EdgeInsets.only(top: 36.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <TextSpan>[
                          const TextSpan(text: 'Performing connection to\n'),
                          TextSpan(text:
    '${walletModel.getNetworkChainName(wcModelView.state.selectedChainIdOnApp)} \n\n',
    style: const TextStyle(fontWeight: FontWeight.bold)),
    const TextSpan(text: 'Open your wallet to approve the connection request. '
    'Sometimes it requires going back to the wallet a couple times.',),
                        ],
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LoadingAnimationWidget.prograssiveDots(
                      size: 18,
                      color: DodaoTheme.of(context).primaryText,
                    ),
                  ),

                  if (_platform.platform == 'mobile'
                      || _platform.browserPlatform == 'android'
                      || _platform.browserPlatform == 'ios')
                  Padding(
                    padding: const EdgeInsets.all( 15.0),
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
                  if (_platform.platform == 'mobile'
                      || _platform.browserPlatform == 'android'
                      || _platform.browserPlatform == 'ios')
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: GoToWalletButton(),
                    ),
                ],
              ),
            if (wcModelView.wcCurrentState == WCScreenStatus.error)
              Text(
                wcModelView.state.errorMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (wcModelView.wcCurrentState == WCScreenStatus.disconnected)
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'Disconnected',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
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
                  'Connected \n${walletModel.getNetworkChainName(wcModelView.state.selectedChainIdOnApp)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                  if (walletModel.state.walletConnected && wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkMatch)
                    Container(
                      padding: const EdgeInsets.only(top: 2, left: 6, right: 6),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          // Text(
                          //   'Wallet address:',
                          //   style: Theme.of(context).textTheme.bodySmall,
                          //   textAlign: TextAlign.center,
                          // ),
                          Text(
                            walletModel.state.walletAddress.toString(),
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
