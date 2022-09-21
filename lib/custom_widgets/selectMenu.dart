import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';

const List<String> selectNetwork = <String>[
  'Moonbase',
  'Ethereum',
  'Binance',
  'Fantom',
  'Avalanche',
  'Polygon'
];

// const List<String> selectToken = <String>['ETH', 'WETH', 'WDEV', 'aUSDC'];
const List<String> selectToken = <String>['ETH', 'aUSDC'];

class SelectNetworkMenu extends StatefulWidget {
  final Task object;
  const SelectNetworkMenu({Key? key, required this.object}) : super(key: key);

  @override
  State<SelectNetworkMenu> createState() => _SelectNetworkMenuState();
}

class _SelectNetworkMenuState extends State<SelectNetworkMenu> {
  String assetName = '';
  double asset = 0.0;
  String dropdownValue = selectNetwork.first;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    dropdownValue = tasksServices.destinationChain;
    // bool showMenu;
    String valueName = '';

    if(widget.object.contractValue != 0.0) {
      valueName = 'eth';
    } else if (widget.object.contractValueToken != 0.0) {
      valueName = 'ausdc';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // RichText(text: TextSpan(
        //     style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.9),
        //     children: <TextSpan>[
        //       TextSpan(
        //           text: 'Select network: ',
        //           style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
        //     ]
        // )),
        if(valueName == 'ausdc')
        DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          // hint: Text('Choose network (${dropdownValue})'),
          underline: Container(
            height: 2,
            color: Colors.green,
          ),
          onChanged: (String? value) {

            tasksServices.destinationChain = value!;

            if (value == 'Moonbase') {
              tasksServices.myNotifyListeners();
            }

            setState(() {
              dropdownValue = value;
              // tasksServices.getGasPrice('Moonbeam', value,
              //     tokenSymbol: dropdownValue);
              if (widget.object.contractValue > 0) {
                assetName = 'ETH';
                asset = widget.object.contractValue;
              } else if (widget.object.contractValueToken > 0 && dropdownValue != 'Moonbase') {
                assetName = 'uausdc';
                asset = widget.object.contractValueToken;
                tasksServices.getTransferFee(
                    sourceChainName: 'moonbeam',
                    destinationChainName: value.toLowerCase(),
                    assetDenom: assetName,
                    amountInDenom: 100000);
              }
            });
          },
          items: selectNetwork.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        if(valueName == 'ausdc')
          RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 0.9),
                children: <TextSpan>[
              if(dropdownValue != 'Moonbase')
              TextSpan(
                  text: 'Transfer fee to ${dropdownValue} is: ${tasksServices.transferFee}',
                  style: const TextStyle(
                      height: 1.8, fontWeight: FontWeight.bold)),
              if(widget.object.contractValueToken < tasksServices.transferFee && dropdownValue != 'Moonbase')
              TextSpan(
                  text: '\nFunds stored in the contract are less \nthan Axelar transaction fee: ',
                  style: const TextStyle(
                      height: 1.8, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            ])),
      ],
    );
  }
}

class SelectTokenMenu extends StatefulWidget {
  const SelectTokenMenu({Key? key}) : super(key: key);

  @override
  State<SelectTokenMenu> createState() => _SelectTokenMenuState();
}

class _SelectTokenMenuState extends State<SelectTokenMenu> {
  String dropdownValue = selectToken.first;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    dropdownValue = tasksServices.taskTokenSymbol;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 1.3, color: Colors.white),
                children: <TextSpan>[
              TextSpan(
                  text: 'Select Token: ',
                  style:
                      const TextStyle(height: 2, fontWeight: FontWeight.bold)),
            ])),
        DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          dropdownColor: Colors.blueGrey,
          style: const TextStyle(color: Colors.white),
          hint: Text('Choose token (${dropdownValue})'),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            tasksServices.taskTokenSymbol = value!;
            setState(() {
              dropdownValue = value;
            });
          },
          items: selectToken.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
