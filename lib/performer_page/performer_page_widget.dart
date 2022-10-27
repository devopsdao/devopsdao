import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/task_dialog.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/task_item.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../blockchain/task.dart';

import 'package:beamer/beamer.dart';

class PerformerPageWidget extends StatefulWidget {
  final String? taskAddress;
  const PerformerPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _PerformerPageWidgetState createState() => _PerformerPageWidgetState();
}

class _PerformerPageWidgetState extends State<PerformerPageWidget> {
  // final animationsMap = {
  //   'containerOnPageLoadAnimation': AnimationInfo(
  //     trigger: AnimationTrigger.onPageLoad,
  //     duration: 1000,
  //     delay: 1000,
  //     hideBeforeAnimating: false,
  //     fadeIn: false, // changed to false(orig from FLOW true)
  //     initialState: AnimationState(
  //       opacity: 0,
  //     ),
  //     finalState: AnimationState(
  //       opacity: 1,
  //     ),
  //   ),
  // };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) => TaskDialog(
                  taskAddress: widget.taskAddress!,
                  role: 'performer',
                ));
      });
    }
    // startPageLoadAnimations(
    //   animationsMap.values
    //       .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
    //   this,
    // );
  }

  final _searchKeywordController = TextEditingController();
  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    Map tabs = {
      "new": 0,
      "agreed": 1,
      "progress": 1,
      "review": 1,
      "audit": 1,
      "completed": 2,
      "canceled": 2
    };

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      if (task != null) {
        tabIndex = tabs[task!.taskState];
      }
    }

    if (_searchKeywordController.text.isEmpty) {
      if (tabIndex == 0) {
        tasksServices.resetFilter(tasksServices.tasksPerformerParticipate);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(tasksServices.tasksPerformerProgress);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(tasksServices.tasksPerformerComplete);
      }
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
                  'Performer',
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
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   children: [
          //     Padding(
          //       padding: EdgeInsetsDirectional.fromSTEB(11, 11, 11, 11),
          //       child: Icon(
          //         Icons.settings_outlined,
          //         color: FlutterFlowTheme.of(context).primaryBtnText,
          //         size: 24,
          //       ),
          //     ),
          //   ],
          // ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
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
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            // fit: BoxFit.cover,
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 3,
                initialIndex: tabIndex,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: const Color(0xFF47CBE4),
                      indicatorWeight: 3,
                      // isScrollable: true,
                      onTap: (index) {
                        _searchKeywordController.clear();
                        tabIndex = index;
                        print(index);
                        if (index == 0) {
                          tasksServices.resetFilter(
                              tasksServices.tasksPerformerParticipate);
                        } else if (index == 1) {
                          tasksServices.resetFilter(
                              tasksServices.tasksPerformerProgress);
                        } else if (index == 2) {
                          tasksServices.resetFilter(
                              tasksServices.tasksPerformerComplete);
                        }
                      },
                      tabs: [
                        Tab(
                          // icon: const FaIcon(
                          //   FontAwesomeIcons.smileBeam,
                          // ),
                          child: BadgeTab(
                            taskCount:
                                tasksServices.tasksPerformerParticipate.length,
                            tabText: 'Applied',
                          ),
                        ),
                        Tab(
                          // icon: const Icon(
                          //   Icons.card_travel_outlined,
                          // ),
                          child: BadgeTab(
                            taskCount:
                                tasksServices.tasksPerformerProgress.length,
                            tabText: 'Working',
                          ),
                        ),
                        Tab(
                          // icon: const Icon(
                          //   Icons.done_outline,
                          // ),
                          child: BadgeTab(
                            taskCount:
                                tasksServices.tasksPerformerComplete.length,
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
                          if (tabIndex == 0) {
                            tasksServices.runFilter(searchKeyword,
                                tasksServices.tasksPerformerParticipate);
                          } else if (tabIndex == 1) {
                            tasksServices.runFilter(searchKeyword,
                                tasksServices.tasksPerformerProgress);
                          } else if (tabIndex == 2) {
                            tasksServices.runFilter(searchKeyword,
                                tasksServices.tasksPerformerComplete);
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
                    tasksServices.isLoading
                        ? const LoadIndicator()
                        : const Expanded(
                            child: TabBarView(
                              children: [
                                MyPerformerTabWidget(
                                  tabName: 'applied',
                                ),
                                MyPerformerTabWidget(
                                  tabName: 'working',
                                ),
                                MyPerformerTabWidget(
                                  tabName: 'complete',
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPerformerTabWidget extends StatefulWidget {
  final String tabName;
  const MyPerformerTabWidget({Key? key, required this.tabName})
      : super(key: key);

  @override
  _MyPerformerTabWidget createState() => _MyPerformerTabWidget();
}

class _MyPerformerTabWidget extends State<MyPerformerTabWidget> {
  late bool justLoaded = true;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    List objList = tasksServices.filterResults!.values.toList();

    return Container(
      child: Padding(
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
                      // setState(() {
                      //   // Toggle light when tapped.
                      // });
                      // if (obj[index].taskState != "new")
                      if (tasksServices.filterResults.values
                              .toList()
                              .elementAt(index) !=
                          null) {
                        showDialog(
                            context: context,
                            builder: (context) => TaskInformationDialog(
                                  role: 'performer',
                                  object: objList[index],
                                ));
                        final String taskAddress = tasksServices
                            .filterResults.values
                            .toList()[index]
                            .taskAddress
                            .toString();
                        RouteInformation routeInfo = RouteInformation(
                            location: '/performer/$taskAddress');
                        Beamer.of(context).updateRouteInformation(routeInfo);
                        // context.popToNamed('/performer/$taskAddress');
                      }
                    },
                    child: TaskItem(
                      role: 'performer',
                      object: objList[index],
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
