import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../wallet_service.dart';

class NetworkSelection extends StatefulWidget {
  final double qrSize;
  final Function callConnectWallet;
  const NetworkSelection({
    Key? key,
    required this.qrSize,
    required this.callConnectWallet,
  }) : super(key: key);

  @override
  _NetworkSelectionState createState() => _NetworkSelectionState();
}

class _NetworkSelectionState extends State<NetworkSelection> {

  late Widget networkLogoImage = Image.asset(
    'assets/images/logo.png',
    height: 80,
    filterQuality: FilterQuality.medium,
  );

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    WalletProvider walletProvider = context.watch<WalletProvider>();

    //Network chain matched check:
    bool networkChainsMatched;
    walletProvider.chainNameOnWallet == walletProvider.chainNameOnApp ? networkChainsMatched =true : networkChainsMatched =false;

    return Column(
      children: [
        SizedBox(
          width: tasksServices.walletConnectedWC ? null : widget.qrSize,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isExpanded: true,
              value: walletProvider.chainNameOnApp,
              icon: const Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: DodaoTheme.of(context).taskBackgroundColor,
              style: Theme.of(context).textTheme.bodySmall,
              // hint: Text('Choose token ($dropdownValue)'),
              underline: Container(
                height: 2,
                color: Colors.deepOrange,
              ),
              onChanged: (String? value)  {
                setState(() {
                  if (walletProvider.initComplete) {
                    networkLogoImage =  walletProvider.networkLogo(tasksServices.allowedChainIds[value], Colors.white, 80);
                    if (tasksServices.walletConnectedWC) {
                      walletProvider.walletConnectUri = '';
                      // tasksServices.chainId = walletProvider.chainIdOnWallet;
                      walletProvider.switchNetwork(tasksServices,tasksServices.allowedChainIds[walletProvider.chainNameOnWallet]!, tasksServices.allowedChainIds[value]!);
                    } else {
                      // tasksServices.chainId = tasksServices.allowedChainIds[value]!; //change default chainId
                      walletProvider.walletConnectUri = '';
                      widget.callConnectWallet();
                    }
                    // save selected Chain and notify listeners:
                    walletProvider.setSelectedNetworkName(value!);
                  }
                });
              },
              items: tasksServices.allowedChainIds.entries.map<DropdownMenuItem<String>>(
                    (e) {
                  return DropdownMenuItem<String>(
                    value: e.key,
                    child: Text(e.key),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        if (tasksServices.walletConnectedWC && networkChainsMatched && !walletProvider.unknownChainIdWC)
        const SizedBox(
          height: 30,
        ),
        if (tasksServices.walletConnectedWC && networkChainsMatched && !walletProvider.unknownChainIdWC)
          Container(
              padding: const EdgeInsets.all(15.0),
              height: 140,
              child: networkLogoImage
          ),
      ],
    );
  }
}
