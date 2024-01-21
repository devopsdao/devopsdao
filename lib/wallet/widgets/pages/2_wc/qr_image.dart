import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../model_view/wc_model.dart';
import '../../shared/network_selection.dart';

class QrCodeImage extends StatelessWidget {
  final double screenHeightSizeNoKeyboard;
  final double qrSize;
  const QrCodeImage({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.qrSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletConnectUri = context.select((WCModelView vm) => vm.state.walletConnectUri);

    return SizedBox(
      height: screenHeightSizeNoKeyboard - 190,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                TextSpan(text: 'Scan QR or select network'),
              ])),
          NetworkSelection(
            qrSize: qrSize, walletName: 'wc',
          ),
          const SizedBox(
            height: 8,
          ),
          if (walletConnectUri.isNotEmpty)
            QrImageView(
              padding: const EdgeInsets.all(0),
              data: walletConnectUri,
              size: qrSize,
              gapless: false,
              backgroundColor: Colors.white,
            ),
        ],
      ),
    );
  }
}