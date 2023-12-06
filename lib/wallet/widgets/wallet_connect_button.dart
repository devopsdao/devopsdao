import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../metamask.dart';
import '../wallet_service.dart';

class WalletConnectButton extends StatelessWidget {
  final String buttonFunction;
  final String buttonName;
  final VoidCallback callback;

  const WalletConnectButton({
    Key? key,
    required this.buttonFunction,
    this.buttonName = '',
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () async {
          callback();
        },
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 38.0,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  buttonName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
