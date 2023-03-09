import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';

const List<String> selectToken = <String>['FTM', 'aUSDC'];

class Payment extends StatefulWidget {
  final String purpose;
  final double innerPaddingWidth;
  const Payment({
    Key? key,
    required this.purpose,
    required this.innerPaddingWidth,
  }) : super(key: key);

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

  late Debouncing debounceNotifyListener = Debouncing(duration: const Duration(milliseconds: 200));

  @override
  void initState() {
    super.initState();
    valueController = TextEditingController();
  }

  @override
  void dispose() {
    // Don't forget to dispose all of your controllers!
    valueController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    late double borderRadius = interface.borderRadius;
    late double innerPaddingWidth = widget.innerPaddingWidth;
    if (tasksServices.taskTokenSymbol == 'ETH') {
      dropdownValue = 'FTM';
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
      setBlackAndWhite = Colors.black54;
      setGrey = Colors.white;
    } else if (widget.purpose == 'topup') {
      setBlackAndWhite = Colors.black54;
      setGrey = Colors.white;
    } else {
      setBlackAndWhite = Colors.black;
      setGrey = Colors.grey;
    }

    return Column(
      children: [
        Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(9.0),
              width: innerPaddingWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          // height: widget.topConstraints.maxHeight - 200,
                          width: innerPaddingWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: TextFormField(
                            controller: valueController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.allow(RegExp(r'\d*\.?\d*')),
                            ],
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Value:',
                              labelStyle: TextStyle(fontSize: 17.0, color: setBlackAndWhite),
                              hintText: '[Please enter Task value]',
                              hintStyle: TextStyle(fontSize: 14.0, color: setBlackAndWhite),
                              // enabledBorder: const UnderlineInputBorder(
                              //   borderSide: BorderSide(
                              //     color:  Colors.white,
                              //     width: 1,
                              //   ),
                              //   borderRadius: BorderRadius.only(
                              //     topLeft: Radius.circular(4.0),
                              //     topRight: Radius.circular(4.0),
                              //   ),
                              // ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: DodaoTheme.of(context).bodyText1.override(
                                  fontFamily: 'Inter',
                                  color: setBlackAndWhite,
                                  lineHeight: 2,
                                ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onEditingComplete: () {
                              final dropdown = RegExp(dropdownValue);
                              if (!dropdown.hasMatch(valueController!.text)) {
                                valueController!.text = '${valueController!.text} $dropdownValue';
                              }
                            },
                            onTapOutside: (unknown) {
                              final dropdown = RegExp(dropdownValue);
                              if (!dropdown.hasMatch(valueController!.text)) {
                                valueController!.text = '${valueController!.text} $dropdownValue';
                              }
                              FocusScope.of(context).unfocus();
                            },
                            onChanged: (text) {
                              // print('First text field: $text');
                              text.replaceAll(RegExp("[ $dropdownValue]"), "");
                              setState(() {
                                interface.tokensEntered = double.parse(text);
                              });
                              debounceNotifyListener.debounce(() {
                                tasksServices.myNotifyListeners();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: SliderTheme(
                            data: SliderThemeData(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
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
                                  valueController!.text = '$value $dropdownValue';
                                  interface.tokensEntered = value;
                                });
                                debounceNotifyListener.debounce(() {
                                  tasksServices.myNotifyListeners();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // RichText(
                          //     text: TextSpan(
                          //         style: DefaultTextStyle.of(context)
                          //             .style
                          //             .apply(fontSizeFactor: 1.0, color: setBlackAndWhite),
                          //         children: const <TextSpan>[
                          //           TextSpan(
                          //               text: 'Select Token: ',
                          //               style: TextStyle(height: 2, fontWeight: FontWeight.bold)),
                          //         ])),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            borderRadius: BorderRadius.circular(borderRadius),
                            dropdownColor: setGrey,
                            style: TextStyle(color: setBlackAndWhite),
                            hint: Text('Choose token ($dropdownValue)'),
                            underline: Container(
                              height: 2,
                              color: setBlackAndWhite,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              if (value == 'FTM') {
                                tasksServices.taskTokenSymbol = 'ETH';
                              } else {
                                tasksServices.taskTokenSymbol = value!;
                              }
                              if (value == 'FTM') {
                                interface.tokensEntered = 0.0;
                                valueController!.text = '0.0 FTM';
                                _currentPriceValue = 0.0;
                                minPrice = devLowPrice;
                                maxPrice = devHighPrice;
                              } else {
                                interface.tokensEntered = 0.0;
                                valueController!.text = '0.0 aUSDC';
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
                    ),
                  )
                ],
              ),
            )),
        // if(widget.purpose == 'topup')
        //
      ],
    );
  }
}
