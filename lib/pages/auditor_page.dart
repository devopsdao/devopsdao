import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../widgets/badgetab.dart';
import '../task_dialog/main.dart';
import '../widgets/loading.dart';
import '../widgets/tags/main.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/tag_call_button.dart';
import '../task_item/task_item.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/theme.dart';
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
  final _searchKeywordController = TextEditingController();

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
            context: context,
            builder: (context) => TaskDialogBeamer(
                  taskAddress: widget.taskAddress,
                  fromPage: 'auditor',
                ));
      });
    }
    // _searchKeywordController.text = '';
    // _searchKeywordController.addListener(() {_changeField();});
    startPageLoadAnimations(
      animationsMap.values.where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    Map tabs = {
      "requested": 0,
      "performing": 1,
      "finished": 2,
    };

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      tabIndex = tabs[task!.auditState];
    }

    if (_searchKeywordController.text.isEmpty) {
      if (tabIndex == 0) {
        tasksServices.resetFilter(tasksServices.tasksAuditPending);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(tasksServices.tasksAuditApplied);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(tasksServices.tasksAuditWorkingOn);
      } else if (tabIndex == 3) {
        tasksServices.resetFilter(tasksServices.tasksAuditComplete);
      }
    }
    if (tasksServices.publicAddress != null && tasksServices.validChainID) {}

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Auditor',
                  style: DodaoTheme.of(context).title2.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          LoadButtonIndicator(),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      // floatingActionButton: _isFloatButtonVisible
      //     ? FloatingActionButton(
      //         onPressed: () async {
      //           await Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CreateJobWidget(),
      //             ),
      //           );
      //         },
      //         backgroundColor: DodaoTheme.of(context).maximumBlueGreen,
      //         elevation: 8,
      //         child: Icon(
      //           Icons.add,
      //           color: Color(0xFFFCFCFC),
      //           size: 28,
      //         ),
      //       )
      //     : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black, Colors.black],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background.png"),
          //   // fit: BoxFit.cover,
          //   repeat: ImageRepeat.repeat,
          // ),
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
                    labelColor: Colors.white,
                    labelStyle: DodaoTheme.of(context).bodyText1,
                    indicatorColor: const Color(0xFF47CBE4),
                    indicatorWeight: 3,
                    onTap: (index) {
                      _searchKeywordController.clear();
                      tabIndex = index;
                      if (index == 0) {
                        tasksServices.resetFilter(tasksServices.tasksAuditPending);
                      } else if (index == 1) {
                        tasksServices.resetFilter(tasksServices.tasksAuditApplied);
                      } else if (index == 2) {
                        tasksServices.resetFilter(tasksServices.tasksAuditWorkingOn);
                      } else if (index == 3) {
                        tasksServices.resetFilter(tasksServices.tasksAuditComplete);
                      }
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
                  Row(
                    children: [
                      Container(
                        width: constraints.minWidth - 70,
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        // decoration: const BoxDecoration(
                        //   // color: Colors.white70,
                        //   // borderRadius: BorderRadius.circular(8),
                        // ),
                        child: TextField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            print(tabIndex);
                            if (tabIndex == 0) {
                              tasksServices.runFilter(searchKeyword, tasksServices.tasksAuditPending);
                            } else if (tabIndex == 1) {
                              tasksServices.runFilter(searchKeyword, tasksServices.tasksAuditApplied);
                            } else if (tabIndex == 2) {
                              tasksServices.runFilter(searchKeyword, tasksServices.tasksAuditWorkingOn);
                            } else if (tabIndex == 3) {
                              tasksServices.runFilter(searchKeyword, tasksServices.tasksAuditComplete);
                            }
                          },
                          decoration: const InputDecoration(
                            hintText: '[Find task by Title...]',
                            hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                            labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
                            labelText: 'Search',
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                          ),
                          style: DodaoTheme.of(context).bodyText1.override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                lineHeight: 2,
                              ),
                        ),
                      ),
                      const TagCallButton(
                        page: 'auditor',
                      ),
                    ],
                  ),
                  Consumer<SearchServices>(builder: (context, model, child) {
                    return Wrap(
                        alignment: WrapAlignment.start,
                        direction: Axis.horizontal,
                        children: model.auditorTagsList.entries.map((e) {
                          return WrappedChip(interactive: true, key: ValueKey(e.value), theme: 'black', item: e.value, delete: true, page: 'auditor');
                        }).toList());
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
                  index: index,
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
