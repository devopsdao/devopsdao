
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late Map<String, Account> accountsRawList = {};
  int tabIndex = 0;

  Future<void> getAccountsList() async {
    final tasksServices = Provider.of<TasksServices>(context, listen: false);
    accountsList = await tasksServices.getAccountsData(await tasksServices.getAccountsList());
    accountsRawList = await tasksServices.getAccountsData(await tasksServices.getRawAccountsList());

    setState((){
      accountsList = accountsList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAccountsList();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.read<InterfaceServices>();
    // var searchServices = context.read<SearchServices>();

    return SizedBox(
      width: interface.maxStaticGlobalWidth,
      child: DefaultTabController(
        length: 2,
        initialIndex: tabIndex,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              TabBar(
                labelColor: DodaoTheme.of(context).primaryText,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                indicatorColor: DodaoTheme.of(context).tabIndicator,
                indicatorWeight: 3,
                onTap: (index) {
                  // searchServices.searchKeywordController.clear();
                  tabIndex = index;
                  // resetFilters();
                },
                tabs: [
                  Tab(
                    child: BadgeTab(
                      taskCount: accountsList.length,
                      tabText: 'Active',
                    ),
                  ),
                  const Tab(
                    child: BadgeTab(
                      taskCount: 99,
                      tabText: 'Banned',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height: 16,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    RefreshIndicator(
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
                    RefreshIndicator(
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
                  ],
                ),
              ),

              // Consumer<SearchServices>(builder: (context, model, child) {
              //   return Padding(
              //     padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16),
              //     child: Container(
              //       alignment: Alignment.topLeft,
              //       child: Wrap(
              //           alignment: WrapAlignment.start,
              //           direction: Axis.horizontal,
              //           children: model.auditorTagsList.entries.map((e) {
              //             return WrappedChip(
              //               key: ValueKey(e.value),
              //               item: MapEntry(e.key, NftCollection(selected: false, name: e.value.name, bunch: e.value.bunch)),
              //               page: 'auditor',
              //               selected: e.value.selected,
              //               tabIndex: tabIndex,
              //               wrapperRole: e.value.name == '#' ? WrapperRole.hashButton : WrapperRole.onPages,
              //             );
              //           }).toList()),
              //     ),
              //   );
              // }),
              // tasksServices.isLoading
              //     ? const LoadIndicator()
              //     : const Expanded(
              //   child: TabBarView(
              //     children: [
              //       PendingTabWidget(tabName: 'pending'),
              //       PendingTabWidget(tabName: 'applied'),
              //       PendingTabWidget(tabName: 'working'),
              //       PendingTabWidget(tabName: 'done'),
              //     ],
              //   ),
              // ),
            ],
          );
        }),
      ),
    );
  }
}
