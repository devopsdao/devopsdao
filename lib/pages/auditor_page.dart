import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:provider/provider.dart';

import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
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
  // String _searchKeyword = '';
  int tabIndex = 0;

  // _changeField() {
  //   setState(() =>_searchKeyword = _searchKeywordController.text);
  // }

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 1000,
      delay: 1000,
      hideBeforeAnimating: false,
      fadeIn: false, // changed to false(orig from FLOW true)
      initialState: AnimationState(
        opacity: 0,
      ),
      finalState: AnimationState(
        opacity: 1,
      ),
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) => TaskDialogBeamer(
                  taskAddress: widget.taskAddress,
                  fromPage: 'auditor',
                ));
      });
    }

    // init customerTagsList to show tag '+' button:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var searchServices = context.read<SearchServices>();
      searchServices.updateTagListOnTasksPages(page: 'auditor', initial: true);
    });
    // _searchKeywordController.text = '';
    // _searchKeywordController.addListener(() {_changeField();});
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var searchServices = context.read<SearchServices>();

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
        tasksServices.resetFilter(taskList: tasksServices.tasksAuditPending,
          tagsMap: searchServices.auditorTagsList, );
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(taskList: tasksServices.tasksAuditApplied,
          tagsMap: searchServices.auditorTagsList, );
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(taskList: tasksServices.tasksAuditWorkingOn,
          tagsMap: searchServices.auditorTagsList, );
      } else if (tabIndex == 3) {
        tasksServices.resetFilter(taskList: tasksServices.tasksAuditComplete,
          tagsMap: searchServices.auditorTagsList, );
      }
    }
    if (searchServices.searchKeywordController.text.isEmpty) {
      resetFilters();
    }

    if (tasksServices.publicAddress != null && tasksServices.validChainID) {}

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
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
            tasksServices.runFilter(taskList: tasksServices.tasksAuditPending,
              tagsMap: searchServices.auditorTagsList, enteredKeyword: searchKeyword, );
          } else if (tabIndex == 1) {
            tasksServices.runFilter(taskList: tasksServices.tasksAuditApplied,
              tagsMap: searchServices.auditorTagsList, enteredKeyword: searchKeyword, );
          } else if (tabIndex == 2) {
            tasksServices.runFilter(taskList: tasksServices.tasksAuditWorkingOn,
              tagsMap: searchServices.auditorTagsList, enteredKeyword: searchKeyword, );
          } else if (tabIndex == 3) {
            tasksServices.runFilter(taskList: tasksServices.tasksAuditComplete,
              tagsMap: searchServices.auditorTagsList, enteredKeyword: searchKeyword, );
          }
        },
        customTextEditingController: searchServices.searchKeywordController,
        centerTitle: false,
        elevation: 2,
      ),



      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
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
                          tabText: 'Complete',
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: constraints.minWidth - 70,
                  //       padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  //       // decoration: const BoxDecoration(
                  //       //   // color: Colors.white70,
                  //       //   // borderRadius: BorderRadius.circular(8),
                  //       // ),
                  //       child: TextField(
                  //         controller: _searchKeywordController,
                  //         onChanged: (searchKeyword) {
                  //           // print(tabIndex);
                  //           if (tabIndex == 0) {
                  //             tasksServices.runFilter(
                  //               taskList: tasksServices.tasksAuditPending,
                  //               enteredKeyword: searchKeyword,
                  //               tagsMap: searchServices.auditorTagsList
                  //             );
                  //           } else if (tabIndex == 1) {
                  //             tasksServices.runFilter(
                  //               taskList: tasksServices.tasksAuditApplied,
                  //               enteredKeyword: searchKeyword,
                  //               tagsMap: searchServices.auditorTagsList
                  //             );
                  //           } else if (tabIndex == 2) {
                  //             tasksServices.runFilter(
                  //               taskList: tasksServices.tasksAuditWorkingOn,
                  //               enteredKeyword: searchKeyword,
                  //               tagsMap: searchServices.auditorTagsList
                  //             );
                  //           } else if (tabIndex == 3) {
                  //             tasksServices.runFilter(
                  //               taskList: tasksServices.tasksAuditComplete,
                  //               enteredKeyword: searchKeyword,
                  //               tagsMap: searchServices.auditorTagsList
                  //             );
                  //           }
                  //         },
                  //         decoration: const InputDecoration(
                  //           hintText: '[Find task by Title...]',
                  //           hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  //           labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
                  //           labelText: 'Search',
                  //           suffixIcon: Icon(
                  //             Icons.search,
                  //             color: Colors.white,
                  //           ),
                  //           enabledBorder: UnderlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: Colors.white,
                  //               width: 1,
                  //             ),
                  //             borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(4.0),
                  //               topRight: Radius.circular(4.0),
                  //             ),
                  //           ),
                  //           focusedBorder: UnderlineInputBorder(
                  //             borderSide: BorderSide(
                  //               color: Colors.white,
                  //               width: 1,
                  //             ),
                  //             borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(4.0),
                  //               topRight: Radius.circular(4.0),
                  //             ),
                  //           ),
                  //         ),
                  //         style: DodaoTheme.of(context).bodyText1.override(
                  //               fontFamily: 'Inter',
                  //               color: Colors.white,
                  //               lineHeight: 2,
                  //             ),
                  //       ),
                  //     ),
                  //     TagCallButton(
                  //       page: 'auditor',
                  //       tabIndex: tabIndex,
                  //     ),
                  //   ],
                  // ),
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
                                theme: 'black',
                                item: MapEntry(
                                    e.key,
                                    NftTagsBunch(
                                        selected: false,
                                        name: e.value.name,
                                        bunch: e.value.bunch
                                    )
                                ),
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
      ).animated([animationsMap['containerOnPageLoadAnimation']!]),
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
  late bool justLoaded = true;
  // late Map<EthereumAddress, Task> obj;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    List objList = tasksServices.filterResults.values.toList();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          tasksServices.isLoadingBackground = true;
          tasksServices.fetchTasksPerformer(tasksServices.publicAddress!);
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: objList.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: TaskTransition(
                  fromPage: 'auditor',
                  task: tasksServices.filterResults.values.toList()[index],
                )

                // InkWell(
                //   onTap: () {
                //     setState(() {
                //       // Toggle light when tapped.
                //     });
                //     // final taskAddress = tasksServices.filterResults.values
                //     //     .toList()[index]
                //     //     .taskAddress;
                //     // context.beamToNamed('/auditor/$taskAddress');
                //     // showDialog(
                //     //     context: context,
                //     //     builder: (context) {
                //     //       return StatefulBuilder(builder: (context, setState) {
                //     //         return TaskInformationDialog(
                //     //             fromPage: 'auditor', object: objList[index]);
                //     //       });
                //     //     });
                //     // => TaskInformationDialog(fromPage: 'auditor', object: objList[index]),);
                //
                //     showDialog(
                //         context: context,
                //         builder: (context) {
                //           interface.mainDialogContext = context;
                //           return TaskInformationDialog(
                //             fromPage: 'auditor',
                //             taskAddress: objList[index].taskAddress,
                //             shimmerEnabled: false,
                //           );
                //         });
                //     final String taskAddress = tasksServices.filterResults.values.toList()[index].taskAddress;
                //     RouteInformation routeInfo = RouteInformation(location: '/auditor/$taskAddress');
                //     Beamer.of(context).updateRouteInformation(routeInfo);
                //   },
                //   child: TaskItem(fromPage: 'auditor', object: objList[index]),
                // ),
                );
          },
        ),
      ),
    );
  }
}
