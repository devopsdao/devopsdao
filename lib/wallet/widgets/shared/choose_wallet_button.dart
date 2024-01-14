import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';

class ChooseWalletButton extends StatelessWidget {
  final double buttonWidth;
  final bool active;
  final String buttonName;
  final VoidCallback callback;
  late Color buttonColor;
  final String assetPath;
  ChooseWalletButton({Key? key,
    required this.active,
    required this.buttonName,
    required this.buttonWidth,
    required this.callback,
    required this.buttonColor,
    required this.assetPath,
  })
      : super(key: key);

  late Widget customIcon;


  @override
  Widget build(BuildContext context) {
    if (active) {
      customIcon = SvgPicture.asset(
        assetPath,
      );
    } else {
      buttonColor = Colors.grey.shade700;
      customIcon = SvgPicture.asset(
        assetPath,
        color: Colors.black54,
      );
    }

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      child: InkWell(
        onTap: active ? callback : null,
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 50.0, //MediaQuery.of(context).size.width * .08,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: DodaoTheme.of(context).borderRadius,
            color: DodaoTheme.of(context).walletBackgroundColor,
          ),
          child: Row(
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.only(
                        topLeft: DodaoTheme.of(context).borderRadius.topLeft,
                        bottomLeft: DodaoTheme.of(context).borderRadius.bottomLeft,
                      ),
                    ),
                    child: Container(padding: const EdgeInsets.all(9.0), child: customIcon));
              }),
              Expanded(
                child: Text(buttonName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.apply(
                      color: DodaoTheme.of(context).secondaryText,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

