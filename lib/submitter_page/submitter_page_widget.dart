import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/payment.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/task_dialog.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/participants_list.dart';
import '../custom_widgets/task_item.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitterPageWidget extends StatefulWidget {
  const SubmitterPageWidget({Key? key}) : super(key: key);

  @override
  _SubmitterPageWidgetState createState() => _SubmitterPageWidgetState();
}

class _SubmitterPageWidgetState extends State<SubmitterPageWidget>
    with TickerProviderStateMixin {
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
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    bool _lightIsOn = false;

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
                  'Customer',
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
          //     LoadButtonIndicator(),
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => CreateJobWidget(),
      //       ),
      //     );
      //   },
      //   backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
      //   elevation: 8,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 28,
      //   ),
      // ),
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
                          child: BadgeTab(
                            taskCount: tasksServices.tasksCustomerApplied.length,
                            tabText: 'Selection',
                          ),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksCustomerWorking.length,
                              tabText: 'Progress'),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksCustomerComplete.length,
                              tabText: 'Complete'),
                        ),
                      ],
                    ),
                    tasksServices.isLoading
                        ? const LoadIndicator()
                        : Expanded(
                            child: TabBarView(
                              children: [
                                mySubmitterTabWidget(
                                    obj: tasksServices.tasksCustomerApplied), //new
                                mySubmitterTabWidget(
                                    obj: tasksServices.tasksCustomerWorking), //agreed
                                mySubmitterTabWidget(
                                    obj: tasksServices.tasksCustomerComplete), //completed & canceled
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

class mySubmitterTabWidget extends StatefulWidget {
  final Map<String, Task>? obj;
  const mySubmitterTabWidget({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _mySubmitterTabWidgetState createState() => _mySubmitterTabWidgetState();
}

class _mySubmitterTabWidgetState extends State<mySubmitterTabWidget> {
  late bool justLoaded = true;
  bool enableRatingButton = false;
  double ratingScore = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    List objList = widget.obj!.values .toList();
    // TODO: implement build
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
            itemCount: widget.obj?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   // Toggle light when tapped.
                    // });
                    showDialog(
                        context: context,
                        builder: (context) => TaskInformationDialog(role: 'customer', object: objList[index],)
                    );
                  },
                  child: TaskItem(role: 'customer', object: objList[index],)


                  // Container(
                  //   width: double.infinity,
                  //   height: 86,
                  //   decoration: BoxDecoration(
                  //     color: (() {
                  //       if (objList[index].taskState == "agreed") {
                  //         return Colors.white;
                  //       } else if (objList[index].taskState == "review") {
                  //         return Colors.lightGreen.shade200;
                  //       } else if (objList[index].taskState == "progress") {
                  //         return Colors.blueGrey;
                  //       } else if (objList[index].taskState == "canceled") {
                  //         return Colors.orange;
                  //       } else if (objList[index].taskState == "audit") {
                  //         return Colors.orangeAccent;
                  //       } else {
                  //         return Colors.white;
                  //       }
                  //     }()),
                  //     boxShadow: const [
                  //       BoxShadow(
                  //         blurRadius: 5,
                  //         color: Color(0x4D000000),
                  //         offset: Offset(0, 2),
                  //       )
                  //     ],
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //     children: [
                  //       Expanded(
                  //         child: Padding(
                  //           padding: const EdgeInsetsDirectional.fromSTEB(
                  //               12, 8, 8, 8),
                  //           child: Column(
                  //             mainAxisSize: MainAxisSize.max,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 7,
                  //                     child: Text(
                  //                       objList[index]
                  //                           .title,
                  //                       style: FlutterFlowTheme.of(context)
                  //                           .subtitle1,
                  //                       softWrap: false,
                  //                       overflow: TextOverflow.fade,
                  //                       maxLines: 1,
                  //                     ),
                  //                   ),
                  //                   // Spacer(),
                  //                   Expanded(
                  //                     flex: 3,
                  //                     child: Text(
                  //                       objList[index]
                  //                           .taskState,
                  //                       style: FlutterFlowTheme.of(context)
                  //                           .bodyText2,
                  //                       softWrap: false,
                  //                       overflow: TextOverflow.fade,
                  //                       maxLines: 1,
                  //                       textAlign: TextAlign.end,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               // Text(
                  //               //   objList[index].title,
                  //               //   style: FlutterFlowTheme.of(context).subtitle1,
                  //               // ),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     child: Text(
                  //                       objList[index]
                  //                           .description,
                  //                       style: FlutterFlowTheme.of(context)
                  //                           .bodyText2,
                  //                       softWrap: false,
                  //                       overflow: TextOverflow.fade,
                  //                       maxLines: 1,
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 7,
                  //                     child: Text(
                  //                       DateFormat('MM/dd/yyyy, hh:mm a')
                  //                           .format(objList[index]
                  //                               .createdTime),
                  //                       style: FlutterFlowTheme.of(context)
                  //                           .bodyText2,
                  //                       softWrap: false,
                  //                       overflow: TextOverflow.fade,
                  //                       maxLines: 1,
                  //                     ),
                  //                   ),
                  //                   // Spacer(),
                  //                   if (objList[index]
                  //                           .contractValue !=
                  //                       0)
                  //                     Expanded(
                  //                       flex: 3,
                  //                       child: Text(
                  //                         '${objList[index].contractValue} ETH',
                  //                         style: FlutterFlowTheme.of(context)
                  //                             .bodyText2,
                  //                         softWrap: false,
                  //                         overflow: TextOverflow.fade,
                  //                         maxLines: 1,
                  //                         textAlign: TextAlign.end,
                  //                       ),
                  //                     ),
                  //                   if (objList[index]
                  //                           .contractValueToken !=
                  //                       0)
                  //                     Expanded(
                  //                       flex: 3,
                  //                       child: Text(
                  //                         '${objList[index].contractValueToken} aUSDC',
                  //                         style: FlutterFlowTheme.of(context)
                  //                             .bodyText2,
                  //                         softWrap: false,
                  //                         overflow: TextOverflow.fade,
                  //                         maxLines: 1,
                  //                         textAlign: TextAlign.end,
                  //                       ),
                  //                     ),
                  //                   if (objList[index]
                  //                               .contractValue ==
                  //                           0 &&
                  //                       objList[index]
                  //                               .contractValueToken ==
                  //                           0)
                  //                     Expanded(
                  //                       flex: 3,
                  //                       child: Text(
                  //                         'Has no money',
                  //                         style: FlutterFlowTheme.of(context)
                  //                             .bodyText2,
                  //                         softWrap: false,
                  //                         overflow: TextOverflow.fade,
                  //                         maxLines: 1,
                  //                         textAlign: TextAlign.end,
                  //                       ),
                  //                     ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       if (objList[index]
                  //                   .contributorsCount !=
                  //               0 &&
                  //           objList[index].taskState ==
                  //               "new")
                  //         Padding(
                  //           padding: const EdgeInsetsDirectional.fromSTEB(
                  //               0, 0, 12, 0),
                  //           child: Badge(
                  //             // position: BadgePosition.topEnd(top: 10, end: 10),
                  //             badgeContent: Container(
                  //               width: 17,
                  //               height: 17,
                  //               alignment: Alignment.center,
                  //               child: Text(
                  //                   objList[index]
                  //                       .contributorsCount
                  //                       .toString(),
                  //                   style: const TextStyle(
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.white)),
                  //             ),
                  //             animationDuration:
                  //                 const Duration(milliseconds: 300),
                  //             animationType: BadgeAnimationType.scale,
                  //             shape: BadgeShape.circle,
                  //             borderRadius: BorderRadius.circular(5),
                  //             // child: Icon(Icons.settings),
                  //           ),
                  //         ),
                  //       if (objList[index].justLoaded ==
                  //           false)
                  //         const Padding(
                  //           padding:
                  //               EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //     ],
                  //   ),
                  // ),
                ),
              );
            },
          ),
        ));
  }
}
