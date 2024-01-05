import 'package:dodao/blockchain/chain_presets/chains_presets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/apis/web3app/web3app.dart';

import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../model_view/metamask_model.dart';
import '../../model_view/wallet_model.dart';
import '../../model_view/wc_model.dart';

class NetworkSelection extends StatefulWidget {
  final double qrSize;
  final String walletName;
  const NetworkSelection({
    Key? key,
    required this.qrSize,
    required this.walletName,
  }) : super(key: key);

  @override
  State<NetworkSelection> createState() => _NetworkSelectionState();
}

class _NetworkSelectionState extends State<NetworkSelection> {
  @override
  Widget build(BuildContext context) {
    WCModelView wcModelView = context.read<WCModelView>();
    WalletModel walletModel = context.read<WalletModel>();
    MetamaskModel metamaskModel = context.read<MetamaskModel>();
    TasksServices tasksServices = Provider.of<TasksServices>(context, listen: false);
    int selectedChainIdOnApp;
    widget.walletName == 'wc'
        ? selectedChainIdOnApp = wcModelView.state.selectedChainIdOnApp
        : selectedChainIdOnApp = metamaskModel.state.selectedChainIdOnMMApp;

    return Column(
      children: [
        SizedBox(
          width: widget.qrSize,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isExpanded: true,
              value: ChainPresets.chains[selectedChainIdOnApp]!.chainName ,
              icon: const Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: DodaoTheme.of(context).taskBackgroundColor,
              style: Theme.of(context).textTheme.bodySmall,
              // hint: Text('Choose token ($dropdownValue)'),
              underline: Container(
                height: 2,
                color: Colors.deepOrange,
              ),
              onChanged: (String? value) async {
                int chainId = walletModel.getNetworkChainId(value!);
                if (widget.walletName == 'wc') {
                  wcModelView.setSelectedChainIdOnApp(chainId);
                  if (walletModel.state.walletConnected) {
                    // do nothing if you are on the same network:
                    if (chainId == walletModel.state.chainId) { return; }
                    await wcModelView.onNetworkChangeInMenu(value);
                  } else {
                    walletModel.onWalletReset();
                    await wcModelView.onCreateWalletConnection(context);
                  }
                } else if (widget.walletName == 'metamask') {
                  metamaskModel.setSelectedChainIdOnApp(chainId);
                  if (walletModel.state.walletConnected) {
                    // do nothing if you are on the same network:
                    if (chainId == walletModel.state.chainId) { return; }
                    await metamaskModel.onSwitchNetworkMM(tasksServices, walletModel, chainId);
                  } else {
                    await metamaskModel.onCreateMetamaskConnection(tasksServices, walletModel, context);
                  }
                }
              },
              items: ChainPresets.chains.entries.map<DropdownMenuItem<String>>(
                (e) {
                  return DropdownMenuItem<String>(
                    value: e.value.chainName,
                    child: Text(e.value.chainName),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
