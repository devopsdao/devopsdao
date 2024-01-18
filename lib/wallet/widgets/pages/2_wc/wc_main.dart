
import 'package:dodao/wallet/widgets/pages/2_wc/tab_mobile_desktop.dart';
import 'package:dodao/wallet/widgets/pages/2_wc/tab_qr_code.dart';
import 'package:dodao/wallet/widgets/pages/2_wc/wc_action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../model_view/wc_model.dart';
import 'connect_disconnect_state.dart';

class WalletConnectMainScreen extends StatelessWidget {
  const WalletConnectMainScreen({
    super.key,
    required this.screenHeightSizeNoKeyboard,
  });

  final double screenHeightSizeNoKeyboard;

  @override
  Widget build(BuildContext context) {
    final listenMobile = context.select((WCModelView vm) => vm.state.mobile);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WcQrCodeTab(screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard),
        const Spacer(),
        // const ConnectDisconnectState(),
        const WCActionButton(),
        const SizedBox(height: 22),
      ],
    );






    // return DefaultTabController(
    //   length: 3,
    //   initialIndex: listenMobile ? 0 : 1,
    //   child: Column(
    //     children: [
    //       SizedBox(
    //         height: 30,
    //         child: TabBar(
    //           labelColor: DodaoTheme.of(context).secondaryText,
    //           indicatorColor: DodaoTheme.of(context).tabIndicator,
    //           unselectedLabelColor: Colors.grey,
    //           tabs: [
    //             Container(
    //               color: Colors.transparent,
    //               width: 120,
    //               child: Tab(
    //                   child: Text(listenMobile
    //                       ? 'Mobile'
    //                       : 'Desktop')),
    //             ),
    //             const SizedBox(
    //               width: 120,
    //               child: Tab(child: Text('QR Code')),
    //             ),
    //             const SizedBox(
    //               width: 120,
    //               child: Icon(Icons.settings),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: TabBarView(
    //           children: [
    //             // *********** Wallet Connect > Mobile tab ************ //
    //             WCMobileDesktopTab(
    //               listenMobile: listenMobile,
    //             ),
    //             // *********** Wallet Connect > QR Code tab  ************ //
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 WcQrCodeTab(screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard),
    //                 const Spacer(),
    //                 const ConnectDisconnectState(),
    //                 const WCActionButton(),
    //                 const SizedBox(height: 22),
    //               ],
    //             ),
    //             // *********** Wallet Connect > System info tab ************ //
    //             Column(
    //               children: [
    //                 // PairingsPage(web3App: WCService.web3App!),
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

