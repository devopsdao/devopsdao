import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';



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
  late List<String> selectToken = [];
  late String dropdownValue;
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      selectToken = <String>[tasksServices.chainTicker, 'aUSDC'];
      dropdownValue = selectToken.first;
    });
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
      // dropdownValue = tasksServices.taskTokenSymbol;
      dropdownValue = tasksServices.chainTicker;
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
    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );


    return Column(
      children: [
        Material(
            elevation: DodaoTheme.of(context).elevation,
            borderRadius: DodaoTheme.of(context).borderRadius,
            child: Container(
              decoration: materialMainBoxDecoration,
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
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                              hintText: '[Please enter Task value]',
                              hintStyle:  Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
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
                            style: Theme.of(context).textTheme.bodySmall,
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
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11, elevation: 6),
                              activeTrackColor: Colors.deepOrange,
                              inactiveTrackColor: Colors.grey.shade600,
                              trackHeight: 5.0,
                              thumbColor: Colors.white,


                            ),
                            child: Slider(

                              value: _currentPriceValue,
                              min: minPrice,
                              max: maxPrice,
                              divisions: 100,
                              // label: _currentPriceValue.toString(),
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
                          ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              // elevation: 6,
                              borderRadius: BorderRadius.circular(borderRadius),
                              dropdownColor: DodaoTheme.of(context).taskBackgroundColor,
                              style: Theme.of(context).textTheme.bodySmall,
                              // hint: Text('Choose token ($dropdownValue)'),
                              underline: Container(
                                height: 2,
                                color: Colors.deepOrange,
                              ),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                if (value == tasksServices.chainTicker) {
                                  tasksServices.taskTokenSymbol = 'ETH';
                                  // print('taskTokenSymbol changed to default value ${value!}');
                                } else {
                                  tasksServices.taskTokenSymbol = value!;
                                  // print('taskTokenSymbol changed to ${value!}');
                                }
                                if (value == tasksServices.chainTicker) {
                                  interface.tokensEntered = 0.0;
                                  // valueController!.text = '0.0 ${tasksServices.chainTicker}';
                                  valueController!.text = '0.0 ${tasksServices.chainTicker}';
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
