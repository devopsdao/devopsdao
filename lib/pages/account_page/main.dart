import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webthree/webthree.dart';

import 'account_transition_effect.dart';
import '../../blockchain/accounts.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../widgets/badgetab.dart';

class AccountsTabs extends StatefulWidget {
  const AccountsTabs({
    super.key,
  });

  @override
  State<AccountsTabs> createState() => _AccountsTabsState();
}

class _AccountsTabsState extends State<AccountsTabs> {
  late Map<String, Account> accountsList = {};
  late Map<String, Account> accountsBlackList = {};
  int tabIndex = 0;
  List<Account> filteredAccounts = [];
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption = SortOption.completedTasks;
  bool _isAscending = false;

  Future<void> getAccountsList() async {
    final tasksServices = Provider.of<TasksServices>(context, listen: false);
    accountsList = await tasksServices.getAccountsData(defaultListType: 'regular_list', requestedAccountsList: []);
    accountsBlackList = await tasksServices.getAccountsData(defaultListType: 'black_list', requestedAccountsList: []);
    filteredAccounts = _sortAccounts(accountsList.values.toList());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAccountsList();
  }

  List<Account> filterAccountsList(String query) {
    query = query.toLowerCase();
    return _sortAccounts(
      accountsList.values.toList().where((account) {
        final nickName = account.nickName.toLowerCase();
        final about = account.about.toLowerCase();
        final walletAddress = account.walletAddress.hex.toLowerCase();
        return nickName.contains(query) || about.contains(query) || walletAddress.contains(query);
      }).toList(),
    );
  }

  List<Account> _sortAccounts(List<Account> accounts) {
    switch (_sortOption) {
      case SortOption.nickname:
        accounts.sort((a, b) => _isAscending ? a.nickName.compareTo(b.nickName) : b.nickName.compareTo(a.nickName));
        break;
      case SortOption.walletAddress:
        accounts
            .sort((a, b) => _isAscending ? a.walletAddress.hex.compareTo(b.walletAddress.hex) : b.walletAddress.hex.compareTo(a.walletAddress.hex));
        break;
      case SortOption.customerTasks:
        accounts.sort((a, b) =>
            _isAscending ? a.customerTasks.length.compareTo(b.customerTasks.length) : b.customerTasks.length.compareTo(a.customerTasks.length));
        break;
      case SortOption.participantTasks:
        accounts.sort((a, b) => _isAscending
            ? a.participantTasks.length.compareTo(b.participantTasks.length)
            : b.participantTasks.length.compareTo(a.participantTasks.length));
        break;
      case SortOption.auditParticipantTasks:
        accounts.sort((a, b) => _isAscending
            ? a.auditParticipantTasks.length.compareTo(b.auditParticipantTasks.length)
            : b.auditParticipantTasks.length.compareTo(a.auditParticipantTasks.length));
        break;
      case SortOption.customerRating:
        accounts.sort((a, b) =>
            _isAscending ? a.customerRating.length.compareTo(b.customerRating.length) : b.customerRating.length.compareTo(a.customerRating.length));
        break;
      case SortOption.performerRating:
        accounts.sort((a, b) => _isAscending
            ? a.performerRating.length.compareTo(b.performerRating.length)
            : b.performerRating.length.compareTo(a.performerRating.length));
        break;
      case SortOption.agreedTasks:
        accounts.sort((a, b) => _isAscending
            ? a.performerAgreedTasks.length.compareTo(b.performerAgreedTasks.length)
            : b.performerAgreedTasks.length.compareTo(a.performerAgreedTasks.length));
        break;
      case SortOption.auditAgreed:
        accounts.sort(
            (a, b) => _isAscending ? a.auditAgreed.length.compareTo(b.auditAgreed.length) : b.auditAgreed.length.compareTo(a.auditAgreed.length));
        break;
      case SortOption.completedTasks:
        accounts.sort((a, b) => _isAscending
            ? a.performerCompletedTasks.length.compareTo(b.performerCompletedTasks.length)
            : b.performerCompletedTasks.length.compareTo(a.performerCompletedTasks.length));
        break;
    }
    return accounts;
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.read<InterfaceServices>();
    final listenRoleNfts = context.select((TasksServices vm) => vm.roleNfts);

    return SizedBox(
      width: interface.maxStaticGlobalWidth,
      child: DefaultTabController(
        length: 2,
        initialIndex: tabIndex,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              if (listenRoleNfts['governor'] > 0)
                TabBar(
                  labelColor: DodaoTheme.of(context).primaryText,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  indicatorColor: DodaoTheme.of(context).tabIndicator,
                  indicatorWeight: 3,
                  onTap: (index) async {
                    tabIndex = index;
                    if (tabIndex == 0) {
                      accountsList = await tasksServices.getAccountsData(defaultListType: 'regular_list', requestedAccountsList: []);
                      filteredAccounts = _sortAccounts(accountsList.values.toList());
                    } else if (tabIndex == 1) {
                      accountsBlackList = await tasksServices.getAccountsData(defaultListType: 'black_list', requestedAccountsList: []);
                      filteredAccounts = _sortAccounts(accountsBlackList.values.toList());
                    }
                    setState(() {});
                  },
                  tabs: [
                    Tab(
                      child: BadgeTab(
                        taskCount: accountsList.length,
                        tabText: 'Active',
                      ),
                    ),
                    Tab(
                      child: BadgeTab(
                        taskCount: accountsBlackList.length,
                        tabText: 'Banned',
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            filteredAccounts = filterAccountsList(value);
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by nickname, bio, or wallet address',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    PopupMenuButton<SortOption>(
                      initialValue: _sortOption,
                      onSelected: (SortOption option) {
                        setState(() {
                          _sortOption = option;
                          if (tabIndex == 0) {
                            filteredAccounts = _sortAccounts(accountsList.values.toList());
                          } else {
                            filteredAccounts = _sortAccounts(accountsBlackList.values.toList());
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return SortOption.values.map((SortOption option) {
                          return PopupMenuItem<SortOption>(
                            value: option,
                            child: Text(option.name),
                          );
                        }).toList();
                      },
                    ),
                    IconButton(
                      icon: Icon(_isAscending ? Icons.arrow_downward : Icons.arrow_upward),
                      onPressed: () {
                        setState(() {
                          _isAscending = !_isAscending;
                          if (tabIndex == 0) {
                            filteredAccounts = _sortAccounts(accountsList.values.toList());
                          } else {
                            filteredAccounts = _sortAccounts(accountsBlackList.values.toList());
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        await tasksServices.getAccountsData(defaultListType: 'regular_list', requestedAccountsList: []);
                        filteredAccounts = _sortAccounts(accountsList.values.toList());
                        setState(() {});
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: filteredAccounts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                            child: ClickOnAccountFromIndexedList(tabName: 'active', account: filteredAccounts[index], index: index),
                          );
                        },
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await tasksServices.getAccountsData(defaultListType: 'black_list', requestedAccountsList: []);
                        filteredAccounts = _sortAccounts(accountsBlackList.values.toList());
                        setState(() {});
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemCount: filteredAccounts.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                            child: ClickOnAccountFromIndexedList(
                              tabName: 'banned',
                              account: filteredAccounts[index],
                              index: index,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

enum SortOption {
  nickname('Sort by nickname'),
  walletAddress('Sort by wallet address'),
  customerTasks('Sort by customer tasks'),
  participantTasks('Sort by participant tasks'),
  auditParticipantTasks('Sort by audit participant tasks'),
  customerRating('Sort by customer rating'),
  performerRating('Sort by performer rating'),
  agreedTasks('Sort by agreed tasks'),
  auditAgreed('Sort by audit agreed'),
  completedTasks('Sort by completed tasks');

  final String name;
  const SortOption(this.name);
}
