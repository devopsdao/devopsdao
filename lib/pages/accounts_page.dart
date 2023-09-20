import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../account_dialog/account_transition_effect.dart';
import '../blockchain/accounts.dart';
import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../navigation/appbar.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/wrapped_chip.dart';
import '../widgets/tags/tag_open_container.dart';
import '/blockchain/task_services.dart';
import '/config/theme.dart';
import 'package:flutter/material.dart';

import 'package:webthree/credentials.dart';

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
  late Map<String, Account> accountsList = {};

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => TaskDialogBeamer(taskAddress: widget.taskAddress!, fromPage: 'accounts'));
      });
    }
    getAccountsList();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   var tasksServices = context.read<TasksServices>();
    //   accountsAddressList = await tasksServices.getAccountsList();
    //   accountsList = await tasksServices.getAccountsData(accountsAddressList);
    // });
  }

  Future<void> getAccountsList() async {
    final tasksServices = Provider.of<TasksServices>(context, listen: false);
    accountsList = await tasksServices.getAccountsData(await tasksServices.getAccountsList());

    setState((){
      accountsList = accountsList;

    });
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

    bool isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter(taskList: tasksServices.tasksNew, tagsMap: {});
    }
    if (tasksServices.publicAddress != null && tasksServices.validChainID) {
      isFloatButtonVisible = true;
    }

    void deleteItem(String id) async {
      setState(() {
        deleteItems.add(id);
      });
      Future.delayed(const Duration(milliseconds: 350)).whenComplete(() {
        setState(() {
          deleteItems.removeWhere((i) => i == id);
        });
      });
    }

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
        child: RefreshIndicator(
          onRefresh: () async {
            await tasksServices.getAccountsData(await tasksServices.getAccountsList());
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: accountsList.values.toList().length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                  child: ClickOnAccountFromIndexedList(
                    fromPage: 'accounts',
                    account: accountsList.values.toList()[index],
                  )
              );
            },
          ),
        ),
      ),
    );
  }
}
