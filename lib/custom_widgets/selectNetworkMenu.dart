
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';

const List<String> selectNetwork = <String>['Moonbeam', 'Ethereum', 'Binance', 'Fantom', 'Avalanche', 'Polygon'];

class SelectNetworkMenu extends StatefulWidget {
  const SelectNetworkMenu({Key? key}) : super(key: key);

  @override
  State<SelectNetworkMenu> createState() => _SelectNetworkMenuState();
}

class _SelectNetworkMenuState extends State<SelectNetworkMenu> {
  String dropdownValue = selectNetwork.first;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

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
        DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          hint: Text('Choose network (${dropdownValue})'),
          underline: Container(
            height: 2,
            color: Colors.green,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
              tasksServices.getGasPrice('Moonbeam', value, tokenSymbol: 'DEV');
            });
          },
          items: selectNetwork.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        RichText(text: TextSpan(
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.9),
            children: <TextSpan>[
              TextSpan(
                  text: 'Gas Fee: ${tasksServices.gasPriceValue}',
                  style: const TextStyle(height: 1.8, fontWeight: FontWeight.bold)),
            ]
        )),
      ],
    );
  }
}
