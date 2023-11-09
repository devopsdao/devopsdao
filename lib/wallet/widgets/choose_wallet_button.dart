import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';

class ChooseWalletButton extends StatefulWidget {
  final double buttonWidth;
  final bool active;
  final String buttonFunction;
  final VoidCallback callback;
  const ChooseWalletButton({Key? key,
    required this.active,
    required this.buttonFunction,
    required this.buttonWidth,
    required this.callback,
  })
      : super(key: key);

  @override
  _ChooseWalletButtonState createState() => _ChooseWalletButtonState();
}

class _ChooseWalletButtonState extends State<ChooseWalletButton> {
  late String assetName;
  late Color buttonColor = Colors.grey.shade600;
  late Widget customIcon;
  late Color textColor;

  @override
  Widget build(BuildContext context) {
    late String name;
    if (widget.buttonFunction == 'metamask') {
      name = 'Metamask';
      assetName = 'assets/images/metamask-icon2.svg';
      buttonColor = Colors.teal.shade700;
    } else if (widget.buttonFunction == 'wallet_connect') {
      name = 'Wallet Connect';
      assetName = 'assets/images/wc_logo.svg';
      buttonColor = Colors.purple.shade700;
    }
    if (widget.active) {
      customIcon = SvgPicture.asset(
        assetName,
      );
    } else {
      buttonColor = Colors.grey.shade700;
      customIcon = SvgPicture.asset(
        assetName,
        color: Colors.black54,
      );
    }

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      child: InkWell(
        onTap: widget.active ? widget.callback : null,
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 50.0, //MediaQuery.of(context).size.width * .08,
          width: widget.buttonWidth,
          decoration: BoxDecoration(
            borderRadius: DodaoTheme.of(context).borderRadius,
            color: DodaoTheme.of(context).walletBackgroundColor,
          ),
          child: Row(
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                // print(constraints);
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
                child: Text(name,
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

