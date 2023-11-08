import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';

class WalletConnectButton extends StatefulWidget {
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
  _WalletConnectButtonState createState() => _WalletConnectButtonState();
}

class _WalletConnectButtonState extends State<WalletConnectButton> {

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    late String buttonText = '';

    if (tasksServices.walletConnectedWC && tasksServices.validChainIDWC && widget.buttonFunction == 'wallet_connect') {
      buttonText = 'Disconnect';
    } else if (tasksServices.walletConnectedWC && !tasksServices.validChainIDWC && widget.buttonFunction == 'wallet_connect') {
      buttonText = 'Switch network';
    } else if (!tasksServices.walletConnectedWC && widget.buttonFunction == 'wallet_connect' && (widget.buttonName == 'Refresh QR')) {
      buttonText = 'Refresh QR';
    } else if (!tasksServices.walletConnectedWC && widget.buttonFunction == 'wallet_connect' && (widget.buttonName == 'Connect')) {
      buttonText = 'Connect';
    } else if (tasksServices.walletConnectedMM && tasksServices.validChainIDMM && widget.buttonFunction == 'metamask') {
      buttonText = 'Disconnect';
    } else if (tasksServices.walletConnectedMM && !tasksServices.validChainIDMM && widget.buttonFunction == 'metamask') {
      buttonText = 'Switch network';
    } else if (!tasksServices.walletConnectedMM && widget.buttonFunction == 'metamask') {
      buttonText = 'Connect';
    }

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () async {
          widget.callback();
          if (widget.buttonFunction == 'metamask') {
            if (!tasksServices.walletConnectedMM) {
              tasksServices.initComplete ? await tasksServices.connectWalletMM() : null;
            } else if (tasksServices.walletConnectedMM && !tasksServices.validChainIDMM) {
              tasksServices.initComplete ? await tasksServices.switchNetworkMM() : null;
            } else if (tasksServices.walletConnectedMM && tasksServices.validChainIDMM) {
              tasksServices.initComplete ? await tasksServices.disconnectMM() : null;
              buttonText = 'Connect';
            }
          } else if (widget.buttonFunction == 'wallet_connect') {
            if (!tasksServices.walletConnectedWC) {
              tasksServices.initComplete ? await tasksServices.connectWalletWCv2(false, 0) : null;
            } else if (tasksServices.walletConnectedWC && !tasksServices.validChainIDWC) {
              tasksServices.initComplete ? await tasksServices.switchNetworkWC(tasksServices.chainId) : null;
            } else if (tasksServices.walletConnectedWC && tasksServices.validChainIDWC) {
              tasksServices.initComplete ? {await tasksServices.disconnectWCv2()} : null;
              // buttonName = 'Refresh QR';
            }
          }
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
                  buttonText,
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
