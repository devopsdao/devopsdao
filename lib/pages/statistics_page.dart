import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../navigation/appbar.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../wallet/model_view/wallet_model.dart';
import '../wallet/services/wallet_service.dart';
import '/blockchain/task_services.dart';
import 'package:flutter/material.dart';

import 'package:webthree/credentials.dart';

import 'account_page/main.dart';

class StatisticsPageFinal extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const StatisticsPageFinal({Key? key, this.taskAddress}) : super(key: key);

  @override
  _StatisticsPageFinalState createState() => _StatisticsPageFinalState();
}

class _StatisticsPageFinalState extends State<StatisticsPageFinal> {
  final _searchKeywordController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // if (widget.taskAddress != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //   });
    // }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    return Scaffold(
      key: scaffoldKey,
      // drawer: SideBar(controller: SidebarXController(selectedIndex: tasksServices.roleNfts['governor'] > 0 ? 4 : 5, extended: true)),
      appBar: const OurAppBar(
        title: 'Accounts',
        page: 'accounts',
        tabIndex: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          ),
        ),
        child: const AccountsTabs(),
      ),
    );
  }
}
