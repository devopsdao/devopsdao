import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';

class TransportSelection extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;

  const TransportSelection({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  @override
  _TransportSelectionState createState() => _TransportSelectionState();
}

class _TransportSelectionState extends State<TransportSelection> {
  late String dropdownValue = 'axelar';

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    return SizedBox(
      height: widget.screenHeightSizeNoKeyboard - 210,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Column(
          children: [
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 2.0, right: 11),
                    child: const Icon(Icons.new_releases, size: 45, color: Colors.lightGreen), //Icon(Icons.forward, size: 13, color: Colors.white),
                  ),
                  Expanded(
                    flex: 2,
                    child: RichText(
                        text: TextSpan(style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0), children: const <TextSpan>[
                      TextSpan(
                        text: 'Connected to chain other than Moonbase-alpha. \nPlease select the interchain layer you want to use:',
                        // text: 'Connect with Moonbase-alpha or Hyperlane supported network',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ])),
                  ),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.all(30.0),
                child: DropdownButton(
                  isExpanded: true,
                  value: dropdownValue,
                  hint: Text('Choose transport ($dropdownValue)'),
                  items: const [
                    DropdownMenuItem(value: 'axelar', child: Text('axelar')),
                    DropdownMenuItem(value: 'hyperlane', child: Text('hyperlane')),
                    DropdownMenuItem(value: 'layerzero', child: Text('layerzero')),
                    DropdownMenuItem(value: 'wormhole', child: Text('wormhole')),
                  ],
                  underline: Container(
                    height: 2,
                    color: Colors.black26,
                  ),
                  onChanged: (String? value) {
                    tasksServices.interchainSelected = value!;
                    setState(() {
                      dropdownValue = value!;
                    });
                    // Navigator.pop(context);
                  },
                )),

            if (tasksServices.interchainSelected.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(4.0),
                height: 44,
                child: interface.interchainImages[tasksServices.interchainSelected],
              )
          ],
        ),
      ),
    );
  }
}
