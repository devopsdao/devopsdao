import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../wallet/model_view/wallet_model.dart';
import '../wallet/model_view/mm_model.dart';
import '../wallet/services/wallet_service.dart';
import '../widgets/badgetab.dart';
import '../task_dialog/main.dart';
import '../widgets/loading.dart';
import '../widgets/tags/main.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/tag_open_container.dart';
import '../task_item/task_item.dart';
import '../config/flutter_flow_animations.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

import 'package:webthree/credentials.dart';
import '../widgets/tags/wrapped_chip.dart';

class AuditorPageWidget extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const AuditorPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _AuditorPageWidgetState createState() => _AuditorPageWidgetState();
}

class _AuditorPageWidgetState extends State<AuditorPageWidget> with TickerProviderStateMixin {
  int tabIndex = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) {
              // interface.mainDialogContext = context;
              return TaskDialogBeamer(
                taskAddress: widget.taskAddress,
                fromPage: 'auditor',
              );
            });
      });
    }

    // init customerTagsList to show tag '+' button:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var searchServices = context.read<SearchServices>();
      searchServices.selectTagListOnTasksPages(page: 'auditor', initial: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    var tasksServices = context.watch<TasksServices>();
    var interface = context.read<InterfaceServices>();
    var searchServices = context.read<SearchServices>();
    // final allowedChainId = context.select((WalletModel vm) => vm.state.allowedChainId);
    final walletService = WalletService();

    Map tabs = {
      "requested": 0,
      "performing": 1,
      "finished": 2,
    };

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      tabIndex = tabs[task!.auditState];
    }

    void resetFilters() async {
      if (tabIndex == 0) {
        tasksServices.resetFilter(
          taskList: tasksServices.tasksAuditPending,
          tagsMap: searchServices.auditorTagsList,
        );
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(
          taskList: tasksServices.tasksAuditApplied,
          tagsMap: searchServices.auditorTagsList,
        );
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(
          taskList: tasksServices.tasksAuditWorkingOn,
          tagsMap: searchServices.auditorTagsList,
        );
      } else if (tabIndex == 3) {
        tasksServices.resetFilter(
          taskList: tasksServices.tasksAuditComplete,
          tagsMap: searchServices.auditorTagsList,
        );
      }
    }

    if (searchServices.searchKeywordController.text.isEmpty) {
      resetFilters();
    }

    if (listenWalletAddress != null && WalletService.allowedChainId) {}

    return Scaffold(
      key: scaffoldKey,
      drawer: SideBar(controller: SidebarXController(selectedIndex: 4, extended: true)),
      appBar: AppBarWithSearchSwitch(
        // automaticallyImplyLeading: false,
        appBarBuilder: (context) {
          return AppBar(
            title: Text(
              'Auditor',
              style: DodaoTheme.of(context).title2.override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 20,
                  ),
            ),
            actions: [
              // AppBarSearchButton(),
              IconButton(
                onPressed: AppBarWithSearchSwitch.of(context)?.startSearch,
                icon: const Icon(Icons.search),
              ),
              if (tasksServices.platform == 'web' || tasksServices.platform == 'linux') const LoadButtonIndicator(),
            ],
          );
        },
        searchInputDecoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(fontFamily: 'Inter', fontSize: 18.0, color: Colors.white),
          // suffixIcon: Icon(
          //   Icons.tag,
          //   color: Colors.grey[300],
          // ),
        ),

        onChanged: (searchKeyword) {
          if (tabIndex == 0) {
            tasksServices.runFilter(
              taskList: tasksServices.tasksAuditPending,
              tagsMap: searchServices.auditorTagsList,
              enteredKeyword: searchKeyword,
            );
          } else if (tabIndex == 1) {
            tasksServices.runFilter(
              taskList: tasksServices.tasksAuditApplied,
              tagsMap: searchServices.auditorTagsList,
              enteredKeyword: searchKeyword,
            );
          } else if (tabIndex == 2) {
            tasksServices.runFilter(
              taskList: tasksServices.tasksAuditWorkingOn,
              tagsMap: searchServices.auditorTagsList,
              enteredKeyword: searchKeyword,
            );
          } else if (tabIndex == 3) {
            tasksServices.runFilter(
              taskList: tasksServices.tasksAuditComplete,
              tagsMap: searchServices.auditorTagsList,
              enteredKeyword: searchKeyword,
            );
          }
        },
        customTextEditingController: searchServices.searchKeywordController,
        centerTitle: false,
        elevation: 2,
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
        child: SizedBox(
          width: interface.maxStaticGlobalWidth,
          child: DefaultTabController(
            length: 4,
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
                      searchServices.searchKeywordController.clear();
                      tabIndex = index;
                      resetFilters();
                    },
                    tabs: [
                      Tab(
                        child: BadgeTab(
                          taskCount: tasksServices.tasksAuditPending.length,
                          tabText: 'Pending',
                        ),
                      ),
                      Tab(
                        child: BadgeTab(
                          taskCount: tasksServices.tasksAuditApplied.length,
                          tabText: 'Applied',
                        ),
                      ),
                      Tab(
                        child: BadgeTab(
                          taskCount: tasksServices.tasksAuditWorkingOn.length,
                          tabText: 'Working',
                        ),
                      ),
                      Tab(
                        child: BadgeTab(
                          taskCount: tasksServices.tasksAuditComplete.length,
                          tabText: 'Completed',
                        ),
                      ),
                    ],
                  ),
                  Consumer<SearchServices>(builder: (context, model, child) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: model.auditorTagsList.entries.map((e) {
                              return WrappedChip(
                                key: ValueKey(e.value),
                                item: MapEntry(e.key, NftCollection(selected: false, name: e.value.name, bunch: e.value.bunch)),
                                page: 'auditor',
                                selected: e.value.selected,
                                tabIndex: tabIndex,
                                wrapperRole: e.value.name == '#' ? WrapperRole.hashButton : WrapperRole.onPages,
                              );
                            }).toList()),
                      ),
                    );
                  }),
                  tasksServices.isLoading
                      ? const LoadIndicator()
                      : const Expanded(
                          child: TabBarView(
                            children: [
                              PendingTabWidget(tabName: 'pending'),
                              PendingTabWidget(tabName: 'applied'),
                              PendingTabWidget(tabName: 'working'),
                              PendingTabWidget(tabName: 'done'),
                            ],
                          ),
                        ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class PendingTabWidget extends StatefulWidget {
  final String tabName;

  const PendingTabWidget({
    Key? key,
    required this.tabName,
  }) : super(key: key);

  @override
  _PendingTabWidgetState createState() => _PendingTabWidgetState();
}

class _PendingTabWidgetState extends State<PendingTabWidget> {
  late bool loadingIndicator = false;
  // late Map<EthereumAddress, Task> obj;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    List objList = tasksServices.filterResults.values.toList();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          tasksServices.isLoadingBackground = true;
          tasksServices.fetchTasksPerformer(listenWalletAddress!);
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: objList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: TaskTransition(
                fromPage: 'auditor',
                task: tasksServices.filterResults.values.toList()[index],
              )
            );
          },
        ),
      ),
    );
  }
}
