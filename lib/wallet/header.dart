
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';

class WalletDialogHeader extends StatefulWidget {
  late PageController pageController;

  WalletDialogHeader({Key? key,
    required this.pageController
  }) : super(key: key);

  @override
  _WalletDialogHeaderState createState() => _WalletDialogHeaderState();
}

class _WalletDialogHeaderState extends State<WalletDialogHeader> {
  bool disableBackButton = true;

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    if (interface.pageWalletViewNumber == 0) {
      disableBackButton = true;
    } else {
      if (tasksServices.walletConnectedMM || tasksServices.walletConnectedWC) {
        disableBackButton = true;
      } else {
        disableBackButton = false;
      }
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
      width: 400,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: !disableBackButton ? InkWell(
              onTap: () {
                widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
              },
              borderRadius: DodaoTheme.of(context).borderRadius,
              child: Container(
                padding: const EdgeInsets.all(0.0),
                height: 30,
                width: 30,
                child: const Row(
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ) : null,
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Connect Wallet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              if (tasksServices.walletConnectedMM) {
                interface.pageWalletViewNumber = 1;
              } else if (tasksServices.walletConnectedWC) {
                interface.pageWalletViewNumber = 2;
              } else {
                interface.pageWalletViewNumber = 0;
              }
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(0.0),
              height: 30,
              width: 30,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(6),
              // ),
              child: const Row(
                children: <Widget>[
                  Expanded(
                    child: Icon(
                      Icons.close,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
