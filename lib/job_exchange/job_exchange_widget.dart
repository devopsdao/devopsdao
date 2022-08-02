import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobExchangeWidget extends StatefulWidget {
  const JobExchangeWidget({Key? key}) : super(key: key);

  @override
  _JobExchangeWidgetState createState() => _JobExchangeWidgetState();
}

class _JobExchangeWidgetState extends State<JobExchangeWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 1000,
      delay: 1000,
      hideBeforeAnimating: false,
      fadeIn: true,
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
                  'Job Exchange',
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
        actions: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(11, 11, 11, 11),
                child: Icon(
                  Icons.settings_outlined,
                  color: FlutterFlowTheme.of(context).primaryBtnText,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Color(0xFF1E2429),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateJobWidget(),
            ),
          );
        },
        backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
        elevation: 8,
        child: Icon(
          Icons.add,
          color: Color(0xFFFCFCFC),
          size: 28,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
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
                length: 1,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: Color(0xFF47CBE4),
                      indicatorWeight: 3,
                      tabs: [
                        Tab(
                          text: 'New offers',
                        ),
                        // Tab(
                        //   text: 'Reserved tab',
                        // ),
                        // Tab(
                        //   text: 'Reserved tab',
                        // ),
                      ],
                    ),

                    tasksServices.isLoading ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        :
                    Expanded(
                      child: TabBarView(
                        children: [

                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                            child: RefreshIndicator(
                              onRefresh: () async {},
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: tasksServices.tasksNew.length,
                                itemBuilder: (context, index) {

                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 8, 16, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          // Toggle light when tapped.
                                        });
                                        showDialog(context: context, builder: (context) => AlertDialog(
                                          title: Text(tasksServices.tasksNew[index].title),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(tasksServices.tasksNew[index].description),
                                                Text(tasksServices.tasksNew[index].contractOwner.toString()),
                                                Text(tasksServices.tasksNew[index].contractAddress.toString()),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                                            TextButton(child: Text('Participate'), onPressed: () {
                                              print('Button pressed ...');
                                              tasksServices.taskParticipation(tasksServices.tasksNew[index].contractAddress);
                                              Navigator.pop(context);
                                            })
                                          ],
                                        ));
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 86,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
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
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 8, 8, 8),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.max,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      tasksServices.tasksNew[index].title,
                                                      style: FlutterFlowTheme.of(context).subtitle1,
                                                    ),
                                                    Text(
                                                      tasksServices.tasksNew[index].description,
                                                      style: FlutterFlowTheme.of(
                                                          context)
                                                          .bodyText2,
                                                    ),
                                                    Text(
                                                      tasksServices.tasksNew[index].contractOwner.toString(),
                                                      style: FlutterFlowTheme.of(
                                                          context)
                                                          .bodyText2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            tasksServices.tasksNew[index].contributorsCount != 0 ? Badge(
                                              // position: BadgePosition.topEnd(top: 10, end: 10),
                                              badgeContent: Text(
                                                  tasksServices.tasksNew[index].contributorsCount.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold)
                                              ),
                                              animationDuration: Duration(milliseconds: 1000),
                                              animationType: BadgeAnimationType.scale,
                                              shape: BadgeShape.square,
                                              borderRadius: BorderRadius.circular(5),
                                              // child: Icon(Icons.settings),
                                            )
                                                :

                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 12, 0),
                                              child: Icon(
                                                Icons.info_outlined,
                                                color: Colors.black,
                                                size: 24,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),



                          ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          //   child: RefreshIndicator(
                          //     onRefresh: () async {},
                          //     child: ListView.builder(
                          //       padding: EdgeInsets.zero,
                          //       scrollDirection: Axis.vertical,
                          //       itemCount: tasksServices.tasksAgreed.length,
                          //       itemBuilder: (context, index) {
                          //
                          //         return Padding(
                          //           padding: EdgeInsetsDirectional.fromSTEB(
                          //               16, 8, 16, 0),
                          //           child: Container(
                          //             width: double.infinity,
                          //             height: 86,
                          //             decoration: BoxDecoration(
                          //               color: Colors.white,
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   blurRadius: 5,
                          //                   color: Color(0x4D000000),
                          //                   offset: Offset(0, 2),
                          //                 )
                          //               ],
                          //               borderRadius: BorderRadius.circular(8),
                          //             ),
                          //             child: Row(
                          //               mainAxisSize: MainAxisSize.max,
                          //               children: [
                          //                 Expanded(
                          //                   child: Padding(
                          //                     padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         12, 8, 8, 8),
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.max,
                          //                       crossAxisAlignment:
                          //                       CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(
                          //                           tasksServices.tasksAgreed[index].title,
                          //                           style: FlutterFlowTheme.of(context).subtitle1,
                          //                         ),
                          //                         Text(
                          //                           tasksServices.tasksAgreed[index].description,
                          //                           style: FlutterFlowTheme.of(
                          //                               context)
                          //                               .bodyText2,
                          //                         ),
                          //                         Text(
                          //                           tasksServices.tasksAgreed[index].contractOwner.toString(),
                          //                           style: FlutterFlowTheme.of(
                          //                               context)
                          //                               .bodyText2,
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding:
                          //                   EdgeInsetsDirectional.fromSTEB(
                          //                       0, 0, 12, 0),
                          //                   child: Icon(
                          //                     Icons.info_outlined,
                          //                     color: Colors.black,
                          //                     size: 24,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         );
                          //       },
                          //       // children: [
                          //       //
                          //       // ],
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          //   child: ListView(
                          //     padding: EdgeInsets.zero,
                          //     scrollDirection: Axis.vertical,
                          //     children: [
                          //       Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             16, 8, 16, 0),
                          //         child: Container(
                          //           width: double.infinity,
                          //           height: 86,
                          //           decoration: BoxDecoration(
                          //             color: Colors.white,
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 blurRadius: 5,
                          //                 color: Color(0x4D000000),
                          //                 offset: Offset(0, 2),
                          //               )
                          //             ],
                          //             borderRadius: BorderRadius.circular(8),
                          //           ),
                          //           child: Row(
                          //             mainAxisSize: MainAxisSize.max,
                          //             children: [
                          //               Expanded(
                          //                 child: Padding(
                          //                   padding:
                          //                       EdgeInsetsDirectional.fromSTEB(
                          //                           12, 8, 8, 8),
                          //                   child: Column(
                          //                     mainAxisSize: MainAxisSize.max,
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Text(
                          //                         'Hello World',
                          //                         style: FlutterFlowTheme.of(
                          //                                 context)
                          //                             .subtitle1,
                          //                       ),
                          //                       Text(
                          //                         'Hello World',
                          //                         style: FlutterFlowTheme.of(
                          //                                 context)
                          //                             .bodyText2,
                          //                       ),
                          //                       Text(
                          //                         'Hello World',
                          //                         style: FlutterFlowTheme.of(
                          //                                 context)
                          //                             .bodyText2,
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         0, 0, 12, 0),
                          //                 child: Icon(
                          //                   Icons.info_outlined,
                          //                   color: Colors.black,
                          //                   size: 24,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
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