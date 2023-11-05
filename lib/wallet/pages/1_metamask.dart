import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../widgets/choose_wallet_button.dart';
import '../widgets/wallet_connect_button.dart';

class MetamaskPage extends StatelessWidget {
  final double innerPaddingWidth;

  const MetamaskPage(
      {Key? key,  required this.innerPaddingWidth, })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    return  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (interface.whichWalletButtonPressed == 'metamask')
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          firstChild: Container(
            height: 130,
            width: 130,
            padding: const EdgeInsets.all(18.0),
            child: SvgPicture.asset(
              'assets/images/metamask-icon2.svg',
            ),
          ),
          secondChild: const Padding(
            padding: EdgeInsets.all(18.0),
          ),
          crossFadeState: !tasksServices.walletConnectedMM ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      if (tasksServices.walletConnectedMM) const SizedBox(height: 20),
      if (tasksServices.walletConnectedMM)
        Center(
          child: Material(
            elevation: DodaoTheme.of(context).elevation,
            borderRadius: DodaoTheme.of(context).borderRadius,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: innerPaddingWidth,
              decoration: BoxDecoration(
                borderRadius: DodaoTheme.of(context).borderRadius,
              ),
              child: const Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'You are now connected to Metamask, to completely disconnect please use Metamask menu --> connected sites.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      const SizedBox(height: 20),
      if (interface.whichWalletButtonPressed == 'metamask')
        WalletConnectButton(
          buttonFunction: 'metamask',
          callback: () {
          },
        ),
      const SizedBox(height: 30),
    ]);
  }
}