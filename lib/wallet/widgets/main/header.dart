
import 'package:dodao/wallet/services/wc_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../blockchain/interface.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../model_view/wallet_model.dart';
import '../../model_view/mm_model.dart';
import '../../model_view/wc_model.dart';

class WalletDialogHeader extends StatefulWidget {
  final PageController pageController;
  final WalletModel walletModel;

  const WalletDialogHeader({Key? key,
    required this.pageController, required this.walletModel
  }) : super(key: key);

  @override
  _WalletDialogHeaderState createState() => _WalletDialogHeaderState();
}

class _WalletDialogHeaderState extends State<WalletDialogHeader> {
  bool disableBackButton = true;

  @override
  Widget build(BuildContext context) {
    final currentWalletPage = context.select((WalletModel vm) => vm.state.currentWalletPage);
    if (currentWalletPage == 0) {
      disableBackButton = true;
    } else {
      if (widget.walletModel.state.walletSelected != WalletSelected.none) {
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
              if (widget.walletModel.state.walletSelected == WalletSelected.metamask) {
                widget.walletModel.onPageChanged(1);
              } else if (widget.walletModel.state.walletSelected == WalletSelected.walletConnect) {
                widget.walletModel.onPageChanged(2);
              } else {
                widget.walletModel.onPageChanged(0);
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
