import 'package:dodao/wallet/model_view/wc_model.dart';
import 'package:dodao/wallet/widgets/pages/1_metamask/process_screen.dart';
import 'package:dodao/wallet/widgets/pages/1_metamask/select_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../model_view/mm_model.dart';
import '../../../model_view/wallet_model.dart';

class MetamaskMainScreen extends StatelessWidget {
  const MetamaskMainScreen({
    super.key,
    required this.innerPaddingWidth,

  });

  final double innerPaddingWidth;

  @override
  Widget build(BuildContext context) {
    final listenWalletSelected = context.select((MetamaskModel vm) => vm.state.mmScreenStatus);
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 400),
      firstChild: SelectScreen(innerPaddingWidth: innerPaddingWidth),
      secondChild: const ProcessScreen(),
      crossFadeState: listenWalletSelected == MMScreenStatus.mmNotConnected
      || listenWalletSelected == MMScreenStatus.mmConnectedNetworkMatch
      || listenWalletSelected == MMScreenStatus.mmConnectedNetworkNotMatch
      || listenWalletSelected == MMScreenStatus.error
      || listenWalletSelected == MMScreenStatus.rejected
      ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}