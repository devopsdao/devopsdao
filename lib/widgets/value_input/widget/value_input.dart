import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:throttling/throttling.dart';

import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../../statistics/model_view/pending_model_view.dart';



class ValueInput extends StatefulWidget {
  final String purpose;
  final double innerPaddingWidth;
  const ValueInput({
    Key? key,
    required this.purpose,
    required this.innerPaddingWidth,
  }) : super(key: key);

  @override
  _ValueInputState createState() => _ValueInputState();
}

class _ValueInputState extends State<ValueInput> {
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
      TokenPendingModel tokenPendingModel = context.read<TokenPendingModel>();
      if (tokenPendingModel.state.valueOnWallet != 0.0) {
        devHighPrice = tokenPendingModel.state.valueOnWallet;
      }
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      selectToken = <String>[tasksServices.chainTicker, 'USDC'];
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
      dropdownValue = tasksServices.chainTicker;
      minPrice = devLowPrice;
      maxPrice = devHighPrice;
    } else {
      dropdownValue = tasksServices.taskTokenSymbol;
      minPrice = ausdcLowPrice;
      maxPrice = ausdcHighPrice;
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
                    flex: 8,
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
                              divisions: 50,
                              // label: _currentPriceValue.toString(),
                              onChanged: (double value) {
                                String inString = value.toStringAsFixed(6);
                                double roundedValue = double.parse(inString);

                                setState(() {
                                  _currentPriceValue = roundedValue;
                                  valueController!.text = '$roundedValue $dropdownValue';
                                  interface.tokensEntered = roundedValue;
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
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
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
                                  // interface.tokenSelected passing to create_job/main.dart to detect USDC token selection:
                                  interface.tokenSelected = value!;
                                  tasksServices.taskTokenSymbol = 'ETH';
                                  // print('taskTokenSymbol changed to default value ${value!}');
                                  interface.tokensEntered = 0.0;
                                  // valueController!.text = '0.0 ${tasksServices.chainTicker}';
                                  valueController!.text = '0.0 ${tasksServices.chainTicker}';
                                  _currentPriceValue = 0.0;
                                  minPrice = devLowPrice;
                                  maxPrice = devHighPrice;
                                } else {
                                  interface.tokenSelected = value!;
                                  tasksServices.taskTokenSymbol = value!;
                                  // print('taskTokenSymbol changed to ${value!}');
                                  interface.tokensEntered = 0.0;
                                  valueController!.text = '0.0 USDC';
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
