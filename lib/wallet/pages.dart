import 'package:dodao/wallet/pages/0_select.dart';
import 'package:dodao/wallet/pages/1_metamask.dart';
import 'package:dodao/wallet/pages/2_wallet_connect.dart';
import 'package:dodao/wallet/pages/2_wallet_connect_sections/pairings_section.dart';
import 'package:dodao/wallet/walletconnectv2.dart';
import 'package:dodao/wallet/widgets/choose_wallet_button.dart';
import 'package:dodao/wallet/widgets/network_selection.dart';
import 'package:dodao/wallet/widgets/wallet_connect_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';

class WalletDialogPages extends StatelessWidget {
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;
  final PageController pageController;

  const WalletDialogPages({
    Key? key,
    required this.screenHeightSize,
    required this.screenHeightSizeNoKeyboard,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 60;
      return PageView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (number) {
          interface.pageWalletViewNumber = number;
          tasksServices.myNotifyListeners();
        },
        children: <Widget>[
          WalletSelectConnection(innerPaddingWidth: innerPaddingWidth, pageController: pageController,),
          MetamaskPage(innerPaddingWidth: innerPaddingWidth,),
          WalletConnectController(screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard, innerPaddingWidth: innerPaddingWidth,),
        ],
      );
    });
  }
}


