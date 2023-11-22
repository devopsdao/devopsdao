import 'dart:async';

import 'package:dodao/wallet/pages.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/theme.dart';
import '../../wallet_service.dart';
import '../../widgets/network_selection.dart';

class WcQrCodeImage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double qrSize;
  final Function callConnectWallet;
  const WcQrCodeImage({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.qrSize,
    required this.callConnectWallet,
  }) : super(key: key);

  @override
  _WcQrCodeImageState createState() => _WcQrCodeImageState();
}

class _WcQrCodeImageState extends State<WcQrCodeImage> {
  late Timer _qrTimeout;
  final int _timeoutTicks = 0;
  final int _timeoutTimeInSeconds = 30;

  @override
  void initState() {
    _qrTimeout = Timer.periodic(Duration(seconds: _timeoutTimeInSeconds), (Timer t) => qrTimeout(t));
    super.initState();
  }

  @override
  void dispose() {
    if (_qrTimeout.isActive) {
      _qrTimeout.cancel();
    }
    print('wc_qr_code->timer cancel on dispose');
    super.dispose();
  }

  void qrTimeout(timer) {
    if (timer.tick > _timeoutTicks) {
      timer.cancel();
      setNotConnectedState();
      print('wc_qr_code->timer cancel');
      return;
    } else {
      print('wc_qr_code->timer tick: ${timer.tick}');
      widget.callConnectWallet();
    }
  }

  Future<void> setNotConnectedState() async {
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    if (walletProvider.wcCurrentState == WCStatus.wcNotConnectedWithQrReady) {
      await walletProvider.setWcState(state: WCStatus.wcNotConnected, tasksServices: tasksServices);
    }
  }

  @override
  Widget build(BuildContext context) {
    TasksServices tasksServices = context.read<TasksServices>();
    WalletProvider walletProvider = context.watch<WalletProvider>();

    if ( walletProvider.wcCurrentState == WCStatus.wcNotConnectedWithQrReady && !_qrTimeout.isActive) {
      print('wc_qr_code->timer start inside build');
      _qrTimeout = Timer.periodic(Duration(seconds: _timeoutTimeInSeconds), (Timer t) => qrTimeout(t));
    }



    return SizedBox(
      height: widget.screenHeightSizeNoKeyboard - 190,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                TextSpan(text: 'Scan QR or select network'),
              ])),
          NetworkSelection(
            qrSize: widget.qrSize,
            callConnectWallet: widget.callConnectWallet,
          ),
          const SizedBox(
            height: 8,
          ),
          if (walletProvider.walletConnectUri.isNotEmpty)
            QrImageView(
              padding: const EdgeInsets.all(0),
              data: walletProvider.walletConnectUri,
              size: widget.qrSize,
              gapless: false,
              backgroundColor: Colors.white,
            ),
          if (walletProvider.walletConnectUri.isEmpty)
            Shimmer.fromColors(
              baseColor: DodaoTheme.of(context).shimmerBaseColor,
              highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
              child: Container(
                height: widget.qrSize,
                width: widget.qrSize,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}