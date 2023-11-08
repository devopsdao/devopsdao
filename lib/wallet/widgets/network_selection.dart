import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';

class NetworkSelection extends StatefulWidget {
  final bool wConnected;
  final double qrSize;
  const NetworkSelection({
    Key? key,
    required this.wConnected,
    required this.qrSize,
  }) : super(key: key);

  @override
  _NetworkSelectionState createState() => _NetworkSelectionState();
}

class _NetworkSelectionState extends State<NetworkSelection> {

  late String dropdownValue = 'Dodao Tanssi Appchain';

  late Widget networkLogoImage = Image.asset(
    'assets/images/logo.png',
    height: 80,
    filterQuality: FilterQuality.medium,
  );

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();


    return Column(
      children: [
        if (widget.wConnected)
        Container(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Text(
            'Wrong network, please connect to one of the networks:',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(
          width: widget.wConnected ? null : widget.qrSize,
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              borderRadius: BorderRadius.circular(8),
              dropdownColor: DodaoTheme.of(context).taskBackgroundColor,
              style: Theme.of(context).textTheme.bodySmall,
              hint: Text('Choose token ($dropdownValue)'),
              underline: Container(
                height: 2,
                color: Colors.deepOrange,
              ),
              onChanged: (String? value)  {
                // This is called when the user selects an item.

                setState(() {
                  dropdownValue = value!;
                  networkLogoImage =  interface.networkLogo(tasksServices.allowedChainIds[value], Colors.white, 80);
                  interface.networkSelected = tasksServices.allowedChainIds[value]!;
                  if (widget.wConnected) {

                    tasksServices.walletConnectUri = '';
                    tasksServices.initComplete ? tasksServices.switchNetworkWC(interface.networkSelected) : null;
                    tasksServices.myNotifyListeners();
                  } else {
                    // tasksServices.initComplete ? tasksServices.switchNetworkWC() : null;
                    tasksServices.walletConnectUri = '';
                    tasksServices.initComplete ? tasksServices.connectWalletWCv2(false, interface.networkSelected) : null;
                    tasksServices.myNotifyListeners();
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
        if (widget.wConnected)
        const SizedBox(
          height: 30,
        ),
        if (tasksServices.interchainSelected.isNotEmpty && widget.wConnected)
          Container(
              padding: const EdgeInsets.all(4.0),
              height: 100,
              child: networkLogoImage
          ),
      ],
    );
  }
}
