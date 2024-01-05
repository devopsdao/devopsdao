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

class AccountsPage extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const AccountsPage({Key? key, this.taskAddress}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _searchKeywordController = TextEditingController();
  // final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late List<EthereumAddress> accountsAddressList;

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => TaskDialogBeamer(taskAddress: widget.taskAddress!, fromPage: 'accounts'));
      });
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   var tasksServices = context.read<TasksServices>();
    //   accountsAddressList = await tasksServices.getAccountsList();
    //   accountsList = await tasksServices.getAccountsData(accountsAddressList);
    // });
  }


  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  List<String> deleteItems = [];

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    // final allowedChainId = context.select((WalletModel vm) => vm.state.allowedChainId);
    // final walletService = WalletService();
    bool isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter(taskList: tasksServices.tasksNew, tagsMap: {});
    }
    if (listenWalletAddress != null && WalletService.allowedChainId) {
      isFloatButtonVisible = true;
    }
    //
    // void deleteItem(String id) async {
    //   setState(() {
    //     deleteItems.add(id);
    //   });
    //   Future.delayed(const Duration(milliseconds: 350)).whenComplete(() {
    //     setState(() {
    //       deleteItems.removeWhere((i) => i == id);
    //     });
    //   });
    // }

    // if (widget.index != null) {
    //   showDialog(
    //       context: context,
    //       builder: (context) => TaskDialogBeamer(index: widget.index!));
    // }
    // print('dfs ' + accountsList.values.toList().length.toString());
    return Scaffold(
      key: scaffoldKey,
      drawer: SideBar(controller: SidebarXController(selectedIndex: tasksServices.roleNfts['governor'] > 0 ? 4 : 5, extended: true)),
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
