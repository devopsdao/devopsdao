import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/task_dialog.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/task_item.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../blockchain/task.dart';
import '../custom_widgets/task_dialog.dart';

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
            builder: (context) => TaskDialog(taskAddress: widget.taskAddress!, role: 'performer',));
      });
    }
    // startPageLoadAnimations(
    //   animationsMap.values
    //       .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
    //   this,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

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
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: const Color(0xFF47CBE4),
                      indicatorWeight: 3,
                      // isScrollable: true,
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
                    tasksServices.isLoading
                        ? const LoadIndicator()
                        : Expanded(
                            child: TabBarView(
                              children: [
                                MyPerformerTabWidget(
                                    tabName: 'applied',
                                    obj: tasksServices
                                        .tasksPerformerParticipate),
                                MyPerformerTabWidget(
                                    tabName: 'working',
                                    obj: tasksServices.tasksPerformerProgress),
                                MyPerformerTabWidget(
                                    tabName: 'complete',
                                    obj: tasksServices.tasksPerformerComplete),
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
  final Map<String, Task>? obj;
  final String tabName;
  const MyPerformerTabWidget(
      {Key? key, required this.obj, required this.tabName})
      : super(key: key);

  @override
  _MyPerformerTabWidget createState() => _MyPerformerTabWidget();
}

class _MyPerformerTabWidget extends State<MyPerformerTabWidget> {
  late bool justLoaded = true;

  @override
  Widget build(BuildContext context) {
    List objList = widget.obj!.values.toList();

    var tasksServices = context.watch<TasksServices>();
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
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => TaskInformationDialog(role: 'performer', object: objList[index],));
                      final taskAddress = tasksServices
                          .tasksPerformerParticipate.values
                          .toList()[index]
                          .taskAddress
                          .toString();
                      context.beamToNamed('/performer/$taskAddress');
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
