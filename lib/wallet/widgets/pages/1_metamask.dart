import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../model_view/mm_model.dart';
import '../../model_view/wallet_model.dart';
import '../shared/choose_wallet_button.dart';
import '../shared/buttons.dart';
import '1_metamask/main.dart';

class MetamaskPage extends StatefulWidget {
  final double innerPaddingWidth;


  const MetamaskPage({
    Key? key,
    required this.innerPaddingWidth,
  }) : super(key: key);


  @override
  State<MetamaskPage> createState() => _MetamaskPageState();
}

class _MetamaskPageState extends State<MetamaskPage> {

  // @override
  // void initState() {
  //   MetamaskProvider metamaskProvider = context.read<MetamaskProvider>();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     metamaskProvider.onCreateMetamaskConnection(context);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    MetamaskModel metamaskModel = context.read<MetamaskModel>();
    var tasksServices = context.read<TasksServices>();
    var walletModel = context.read<WalletModel>();
    final listenWalletConnected = context.select((WalletModel vm) => vm.state.walletConnected);
    final listenAllowedChainId = context.select((WalletModel vm) => vm.state.allowedChainId);

    late String buttonText;
    if (listenWalletConnected && listenAllowedChainId) {
      buttonText = 'Disconnect';
    } else if (listenWalletConnected && !listenAllowedChainId) {
      buttonText = 'Switch network';
    } else if (!listenWalletConnected) {
      buttonText = 'Connect';
    }

    return interface.walletButtonPressed == 'metamask' ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        MetamaskMainScreen(innerPaddingWidth: widget.innerPaddingWidth),

      const SizedBox(height: 50),
        // if(listenWalletConnected)
        WalletActionButton(
          buttonName: buttonText,
          // buttonFunction: 'metamask',
          callback: () async {
            if (!listenWalletConnected) {
              await metamaskModel.onCreateMetamaskConnection(tasksServices, walletModel, context);
            } else if (listenWalletConnected && !listenAllowedChainId) {
              // await metamaskModel.onSwitchNetworkMM(context);
            } else if (listenWalletConnected && listenAllowedChainId) {
              await metamaskModel.onDisconnectButtonPressed(tasksServices, walletModel);
            }
          },
        ),
      const SizedBox(height: 30),
    ]) : const Center();
  }
}


