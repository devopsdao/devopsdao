import 'dart:async';

import 'package:dodao/wallet/pages.dart';
import 'package:dodao/wallet/pages/2_wallet_connect_sections/qr_code_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/theme.dart';
import '../../wallet_service.dart';
import '../../widgets/network_selection.dart';

class WcQrCode extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final Function callConnectWallet;
  const WcQrCode({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.callConnectWallet,
  }) : super(key: key);

  @override
  _WcQrCodeState createState() => _WcQrCodeState();
}

class _WcQrCodeState extends State<WcQrCode> {
  // late Timer _qrTimeout;
  // final int _timeoutTicks = 8;
  // final int _timeoutTimeInSeconds = 20;
  final double _qrSize = 200;

  @override
  void initState() {
    // _qrTimeout = Timer.periodic(Duration(seconds: _timeoutTimeInSeconds), (Timer t) => qrTimeout(t));
    super.initState();
  }

  @override
  void dispose() {
    // _qrTimeout.cancel();
    // print('wc_qr_code->timer cancel on dispose');
    super.dispose();
  }

  // void qrTimeout(timer) {
  //   if (timer.tick > _timeoutTicks) {
  //     timer.cancel();
  //     setNotConnectedState();
  //     print('wc_qr_code->timer cancel');
  //     return;
  //   } else {
  //     print('wc_qr_code->timer tick: ${timer.tick}');
  //     widget.callConnectWallet();
  //   }
  // }

  // Future<void> setNotConnectedState() async {
  //   TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
  //   WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
  //   await walletProvider.setWcState(state: WCStatus.wcNotConnected, tasksServices: tasksServices);
  // }

  @override
  Widget build(BuildContext context) {
    TasksServices tasksServices = context.read<TasksServices>();
    WalletProvider walletProvider = context.watch<WalletProvider>();
    String networkNameOnApp = tasksServices.allowedChainIds.entries.firstWhere((e) => e.key == walletProvider.chainNameOnApp).key;
    //
    // if ((
    //     walletProvider.wcCurrentState == WCStatus.wcNotConnectedWithQrReady ||
    //     walletProvider.wcCurrentState == WCStatus.loadingQr
    // ) && !_qrTimeout.isActive) {
    //   print('wc_qr_code->timer start inside build');
    //   _qrTimeout = Timer.periodic(Duration(seconds: _timeoutTimeInSeconds), (Timer t) => qrTimeout(t));
    // }
    // if (_qrTimeout.tick > _timeoutTicks && _qrTimeout.isActive) {
    //   print('wc_qr_code->timer cancel inside build');
    //   _qrTimeout.cancel();
    //   setNotConnectedState();
    // }

    final Widget shimmer = Column(
      children: [
        RichText(
            text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
          TextSpan(text: '   '),
        ])),
        Shimmer.fromColors(
            baseColor: DodaoTheme.of(context).shimmerBaseColor,
            highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
            child: NetworkSelection(
              qrSize: _qrSize,
              callConnectWallet: () {},
            )),
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

    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedCrossFade(
        crossFadeState: walletProvider.wcCurrentState == WCStatus.wcNotConnectedWithQrReady ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        sizeCurve: Curves.easeInOutQuart,

        /////// *********** Has URL ************ /////////
        firstChild: WcQrCodeImage(
          screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,
          callConnectWallet: widget.callConnectWallet,
          qrSize: _qrSize,
        ),

        /////// *********** NO URL ************ /////////
        secondChild: SizedBox(
          height: widget.screenHeightSizeNoKeyboard - 190,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (walletProvider.wcCurrentState == WCStatus.loadingQr) shimmer,
              if (walletProvider.wcCurrentState == WCStatus.loadingWc)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Performing connection with \n$networkNameOnApp',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    LoadingAnimationWidget.prograssiveDots(
                      size: 18,
                      color: DodaoTheme.of(context).primaryText,
                    )
                  ],
                ),
              if (tasksServices.walletConnectedWC)
                NetworkSelection(
                  qrSize: 0,
                  callConnectWallet: widget.callConnectWallet,
                ),
              if (walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkNotMatch)
                Text(
                  'Select $networkNameOnApp\n network in your wallet',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              if (walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkUnknown)
                Text(
                  'Unfortunately, network is not supported. \nSelect $networkNameOnApp in your wallet',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

              if (walletProvider.wcCurrentState == WCStatus.error)
                Text(
                  'Opps... something went wrong, try again \n'
                  '${walletProvider.errorMessage}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              if (walletProvider.wcCurrentState == WCStatus.wcNotConnected)
                Text(
                  'Press connect to generate a \nQR Code',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              // if (walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkNotMatch)
              //   Container(
              //     padding: const EdgeInsets.only(top: 40.0),
              //     child: NetworkSelection(
              //       qrSize: qrSize,
              //       callConnectWallet: widget.callConnectWallet,
              //     ),
              //   ),
              if (tasksServices.walletConnectedWC && walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkMatch)
                Column(
                  children: [
                    Text(
                      'Current network: \n${networkNameOnApp}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    Container(
                        padding: const EdgeInsets.all(15.0),
                        height: 140,
                        child: walletProvider.networkLogo(tasksServices.allowedChainIds[walletProvider.chainNameOnApp], Colors.white, 80)),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
