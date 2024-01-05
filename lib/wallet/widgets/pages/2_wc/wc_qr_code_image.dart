import 'dart:async';

import 'package:dodao/wallet/widgets/main/pages.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/theme.dart';
import '../../../model_view/wc_model.dart';
import '../../../services/wc_service.dart';
import '../../shared/network_selection.dart';

class WcQrCodeTabImage extends StatelessWidget {
  final double screenHeightSizeNoKeyboard;
  final double qrSize;
  const WcQrCodeTabImage({
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
        // crossAxisAlignment: CrossAxisAlignment.center,
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
          // if (walletConnectUri.isEmpty)
          //   Shimmer.fromColors(
          //     baseColor: DodaoTheme.of(context).shimmerBaseColor,
          //     highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
          //     child: Container(
          //       height: widget.qrSize,
          //       width: widget.qrSize,
          //       color: Colors.white,
          //     ),
          //   ),
        ],
      ),
    );
  }
}