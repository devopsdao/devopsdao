import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blockchain/chain_presets/chains_presets.dart';
import '../wallet/model_view/wallet_model.dart';
import '../wallet/services/wc_service.dart';

class NetworkIconImage extends StatelessWidget {
  final double height;

  const NetworkIconImage({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    ChainPresets chainPresets = ChainPresets();
    final chainId = context.select((WalletModel vm) => vm.state.chainId);
    if (ChainPresets.chains.keys.contains(chainId)) {
      ChainInfo networkParams = chainPresets.readChainInfo(chainId!);
      return Image.asset(
        networkParams.chainIconLocally!,
        height: height,
        filterQuality: FilterQuality.medium,
      );
    } else {
      return Image.asset(
        ChainPresets.chains[5]!.chainIconLocally!,
        height: height,
        filterQuality: FilterQuality.medium,
      );
    }
  }
}
