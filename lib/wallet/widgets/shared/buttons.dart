import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../config/utils/util.dart';
import '../../../config/theme.dart';
import '../../../config/utils/platform.dart';
import '../../model_view/wc_model.dart';

class WalletActionButton extends StatelessWidget {
  // final String buttonFunction;
  final String buttonName;
  final VoidCallback callback;

  const WalletActionButton({
    Key? key,
    // required this.buttonFunction,
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


class GoToWalletButton extends StatelessWidget {
  final _platform = PlatformAndBrowser();
  GoToWalletButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WCModelView wcModelView = context.read<WCModelView>();

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () async {
          // launchURL('metamask://');
          // launchURL(wcModelView.state.walletConnectUri);
          if(_platform.platform == 'mobile') {
            await launchUrlString(
              'https://metamask.app.link/dapp',
              mode: LaunchMode.externalNonBrowserApplication,
            );
          } else {
            launchURL('wc:');
          }
        },


        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 80.0,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: DodaoTheme.of(context).borderRadius,
            gradient: const LinearGradient(
              colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
              stops: [0, 0.6, 1],
            ),
          ),
          child: const Text(
            'Go to wallet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}