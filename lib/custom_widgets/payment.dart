import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_theme.dart';

const List<String> selectToken = <String>['DEV', 'aUSDC'];

class Payment extends StatefulWidget {
  final String purpose;
  const Payment({Key? key, required this.purpose}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController? valueController;
  String dropdownValue = selectToken.first;
  double _currentPriceValue = 0.0;
  double ausdcHighPrice = 25.0;
  double ausdcLowPrice = 0.0;
  double devHighPrice = 0.125;
  double devLowPrice = 0.0;
  late double minPrice;
  late double maxPrice;

  @override
  void initState() {
    super.initState();
    valueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    if (tasksServices.taskTokenSymbol == 'ETH') {
      dropdownValue = 'DEV';
      minPrice = devLowPrice;
      maxPrice = devHighPrice;
    } else {
      dropdownValue = tasksServices.taskTokenSymbol;
      minPrice = ausdcLowPrice;
      maxPrice = ausdcHighPrice;
    }

    late Color setBlackAndWhite;
    late Color setGrey;
    if (widget.purpose == 'create') {
      setBlackAndWhite = Colors.white;
      setGrey = Colors.blueGrey;
    } else {
      setBlackAndWhite = Colors.black;
      setGrey = Colors.grey;
    }

    return Column(
      children: [
        TextFormField(
          controller: valueController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(8),
            FilteringTextInputFormatter.allow(RegExp(r'\d*\.?\d*')),
          ],
          autofocus: true,
          obscureText: false,
          decoration: InputDecoration(
            labelText: 'Value:',
            labelStyle: TextStyle(fontSize: 17.0, color: setBlackAndWhite),
            hintText: '[Please enter the value]',
            hintStyle: TextStyle(fontSize: 15.0, color: setBlackAndWhite),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: setBlackAndWhite,
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: setBlackAndWhite,
                width: 1,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            ),
          ),
          style: FlutterFlowTheme.of(context).bodyText1.override(
                fontFamily: 'Poppins',
                color: setBlackAndWhite,
                lineHeight: 2,
              ),
          maxLines: 1,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            print('First text field: $text');
            setState(() {
              interface.tokensEntered = double.parse(text);
            });
          },
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 15),
          child: SliderTheme(
            data: SliderThemeData(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
              activeTrackColor: setBlackAndWhite,
              inactiveTrackColor: setBlackAndWhite,
              trackHeight: 5.0,
            ),
            child: Slider(
              value: _currentPriceValue,
              min: minPrice,
              max: maxPrice,
              divisions: 100,
              label: _currentPriceValue.toString(),
              onChanged: (double value) {
                setState(() {
                  _currentPriceValue = value;
                  valueController!.text = value.toString();
                  interface.tokensEntered = value;
                });
              },
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 1.3, color: setBlackAndWhite),
                    children: const <TextSpan>[
                  TextSpan(
                      text: 'Select Token: ',
                      style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                ])),
            DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              dropdownColor: setGrey,
              style: TextStyle(color: setBlackAndWhite),
              hint: Text('Choose token ($dropdownValue)'),
              underline: Container(
                height: 2,
                color: setBlackAndWhite,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                if (value == 'DEV') {
                  tasksServices.taskTokenSymbol = 'ETH';
                } else {
                  tasksServices.taskTokenSymbol = value!;
                }
                if (value == 'DEV') {
                  interface.tokensEntered = 0.0;
                  valueController!.text = '0.0';
                  _currentPriceValue = 0.0;
                  minPrice = devLowPrice;
                  maxPrice = devHighPrice;
                } else {
                  interface.tokensEntered = 0.0;
                  valueController!.text = '0.0';
                  _currentPriceValue = 0.0;
                  minPrice = ausdcLowPrice;
                  maxPrice = ausdcHighPrice;
                }
                setState(() {
                  dropdownValue = value!;
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
        ),
      ],
    );
  }
}
