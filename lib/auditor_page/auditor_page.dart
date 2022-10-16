import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/info_in_task_dialog.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/participants_list.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class AuditorPageWidget extends StatefulWidget {
  const AuditorPageWidget({Key? key}) : super(key: key);

  @override
  _AuditorPageWidgetState createState() => _AuditorPageWidgetState();
}

class _AuditorPageWidgetState extends State<AuditorPageWidget>
    with TickerProviderStateMixin {
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
    // _searchKeywordController.text = '';
    // _searchKeywordController.addListener(() {_changeField();});
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
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

    bool _isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      if(tabIndex == 0) {
        tasksServices.resetFilter(tasksServices.tasksAuditPending);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(tasksServices.tasksAuditApplied);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(tasksServices.tasksAuditWorkingOn);
      } else if (tabIndex == 3) {
        tasksServices.resetFilter(tasksServices.tasksAuditComplete);
      }
    }
    if (tasksServices.ownAddress != null && tasksServices.validChainID) {
      _isFloatButtonVisible = true;
    }

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
                  style: FlutterFlowTheme.of(context).title2.override(
                        fontFamily: 'Poppins',
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
      //         backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E2517), Color(0xFF0D0D50), Color(0xFF531E59)],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 4,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: const Color(0xFF47CBE4),
                      indicatorWeight: 3,
                      onTap: (index) {
                        _searchKeywordController.clear();
                        tabIndex = index;
                        if(index == 0) {
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
                            taskCount:
                            tasksServices.tasksAuditPending.length,
                            tabText: 'Pending',
                          ),
                        ),
                        Tab(
                          child: BadgeTab(
                            taskCount:
                            tasksServices.tasksAuditApplied.length,
                            tabText: 'Applied',
                          ),
                        ),
                        Tab(
                          child: BadgeTab(
                            taskCount:
                            tasksServices.tasksAuditWorkingOn.length,
                            tabText: 'Working',
                          ),
                        ),
                        Tab(
                          child: BadgeTab(
                            taskCount:
                            tasksServices.tasksAuditComplete.length,
                            tabText: 'Complete',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      // decoration: const BoxDecoration(
                      //   // color: Colors.white70,
                      //   // borderRadius: BorderRadius.circular(8),
                      // ),
                      child: TextField(
                        controller: _searchKeywordController,
                        onChanged: (searchKeyword) {
                          print(tabIndex);
                          if(tabIndex == 0) {
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
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.white),
                          labelStyle:
                              TextStyle(fontSize: 17.0, color: Colors.white),
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
                        style: FlutterFlowTheme.of(context).bodyText1.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              lineHeight: 2,
                            ),
                      ),
                    ),
                    // TabBar(
                    //   labelColor: Colors.white,с
                    //   labelStyle: FlutterFlowTheme.of(context).bodyText1,
                    //   indicatorColor: Color(0xFF47CBE4),
                    //   indicatorWeight: 3,
                    //   tabs: [
                    //     Tab(
                    //       text: 'New offers',
                    //     ),
                    //     // Tab(
                    //     //   text: 'Reserved tab',
                    //     // ),
                    //     // Tab(
                    //     //   text: 'Reserved tab',
                    //     // ),
                    //   ],
                    // ),

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
                ),
              ),
            ),
          ],
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
  // late Map<String, Task> obj;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    List objList = tasksServices.filterResults!.values.toList();

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          tasksServices.isLoadingBackground = true;
          tasksServices.fetchTasks();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: objList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: InkWell(
                onTap: () {
                setState(() {
                  // Toggle light when tapped.
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:
                        Text(objList[index].title),
                    content: SingleChildScrollView(
                      child: TaskInformationDialog(role: 'auditor', object: objList[index]),
                    ),
                    actions: [
                      if(widget.tabName == 'working')
                      TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green),
                          onPressed: () {
                            setState(() {
                              objList[index].justLoaded = false;
                            });
                            tasksServices.changeAuditTaskStatus(
                                objList[index]
                                    .contractAddress,
                                'Customer',
                                objList[index].nanoId);
                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) => WalletAction(
                                      nanoId: objList[index].nanoId,
                                      taskName: 'changeAuditTaskStatus',
                                    ));
                          },

                          child: const Text('In favor of Customer')),
                      if(widget.tabName == 'working')
                        TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.green),
                            onPressed: () {
                              setState(() {
                                objList[index].justLoaded = false;
                              });
                              tasksServices.changeAuditTaskStatus(
                                  objList[index]
                                      .contractAddress,
                                  'Performer',
                                  objList[index].nanoId);
                              Navigator.pop(context);

                              showDialog(
                                  context: context,
                                  builder: (context) => WalletAction(
                                    nanoId: objList[index].nanoId,
                                    taskName: 'changeAuditTaskStatus',
                                  ));
                            },

                            child: const Text('In favor of Performer')),

                      TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context)),
                    ],
                    ));
                },
                child: Container(
                  width: double.infinity,
                  height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Color(0x4D000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      // obj[index].title.length > 20 ? obj[index].title.substring(0, 20)+'...' : obj[index].title,
                                      objList[index].title,
                                      style: FlutterFlowTheme.of(context)
                                          .subtitle1,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    ),
                                  ),

                                  // Spacer(),
                                  // Text(
                                  //   'Value: ' +
                                  //       obj[index].contractValue.toString()
                                  //   + ' Eth',
                                  //   style: FlutterFlowTheme.of(
                                  //       context)
                                  //       .bodyText2,
                                  // ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  objList[index].description,
                                  style: FlutterFlowTheme.of(context).bodyText2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      DateFormat('MM/dd/yyyy, hh:mm a').format(
                                          objList[index]
                                              .createdTime),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (objList[index].contractValue != 0)
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${objList[index].contractValue} ETH',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  if (objList[index]
                                          .contractValueToken !=
                                      0)
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${objList[index].contractValueToken} aUSDC',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  if (objList[index]
                                              .contractValue == 0 &&
                                      objList[index]
                                              .contractValueToken == 0)
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Has no money',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (objList[index].contributorsCount != 0 &&
                      widget.tabName == 'pending')
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 18, 0),
                          child: Badge(
                            // position: BadgePosition.topEnd(top: 10, end: 10),
                            badgeContent: Container(
                              width: 17,
                              height: 17,
                              alignment: Alignment.center,
                              child: Text(
                                  objList[index].auditContributors.length.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            badgeColor: Colors.green,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.scale,
                            shape: BadgeShape.circle,
                            borderRadius: BorderRadius.circular(5),
                            // child: Icon(Icons.settings),
                          ),
                        ),
                      if (objList[index].justLoaded ==
                          false)
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
