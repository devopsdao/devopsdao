import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';

import '../../../../config/utils/platform.dart';
import '../../../model_view/wallet_model.dart';
import '../../../model_view/wc_model.dart';
import '../../shared/buttons.dart';

class WCActionButton extends StatefulWidget {
  const WCActionButton({
    super.key,
  });

  @override
  State<WCActionButton> createState() => _WCActionButtonState();
}

class _WCActionButtonState extends State<WCActionButton> {
  final _platformAndBrowser = PlatformAndBrowser();
  @override
  Widget build(BuildContext context) {
    WCModelView wcModelView = context.watch<WCModelView>();
    WalletModel walletModel = context.read<WalletModel>();
    return WalletActionButton(
      buttonName: wcModelView.state.walletButtonText,
      callback: () async {
        if ( // Refresh Qr, Connect:
            wcModelView.wcCurrentState == WCScreenStatus.disconnected ||
                wcModelView.wcCurrentState == WCScreenStatus.wcNotConnected ||
                wcModelView.wcCurrentState == WCScreenStatus.wcNotConnectedWithQrReady ||
                wcModelView.wcCurrentState == WCScreenStatus.error) {
          walletModel.onWalletReset();
          await wcModelView.onCreateWalletConnection(context);
          if (_platformAndBrowser.browserPlatform == 'ios') {
            launchUrlString(
              wcModelView.state.walletConnectUri,
              mode: LaunchMode.externalNonBrowserApplication,
            );
          }
        } else if ( //Disconnect
            wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkMatch ||
                wcModelView.wcCurrentState == WCScreenStatus.loadingQr ||
                wcModelView.wcCurrentState == WCScreenStatus.loadingWc ||
                wcModelView.wcCurrentState == WCScreenStatus.wcNotConnectedAddNetwork) {
          await walletModel.onWalletReset();
          await wcModelView.onWalletDisconnect();
        } else if ( //if chain does not match
            wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkNotMatch ||
                wcModelView.wcCurrentState == WCScreenStatus.wcConnectedNetworkUnknown) {
          await wcModelView.onSwitchNetwork(wcModelView.state.selectedChainIdOnApp);
        }
      },
    );
  }
}
