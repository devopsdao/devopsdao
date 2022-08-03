import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart';

class PerformerPageWidget extends StatefulWidget {
  const PerformerPageWidget({Key? key}) : super(key: key);

  @override
  _PerformerPageWidgetState createState() => _PerformerPageWidgetState();
}

class _PerformerPageWidgetState extends State<PerformerPageWidget>
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
                  'Performer page',
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
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: Color(0xFF47CBE4),
                      indicatorWeight: 4,
                      tabs: [
                        Tab(
                          text: 'I\'m in',
                          icon: FaIcon(
                            FontAwesomeIcons.smileBeam,
                          ),
                        ),
                        Tab(
                          text: 'Working on',
                          icon: Icon(
                            Icons.card_travel_outlined,
                          ),
                        ),
                        Tab(
                          text: 'Done',
                          icon: Icon(
                            Icons.done_outline,
                          ),
                        ),
                      ],
                    ),

                    tasksServices.isLoading ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        :

                    Expanded(
                      child: TabBarView(
                        children: [
                          myPerformerTabWidget (obj: tasksServices.tasksWithMyParticipation, objectState: "",),
                          myPerformerTabWidget (obj: tasksServices.tasksPerformer, objectState: "",),
                          myPerformerTabWidget (obj: tasksServices.tasksDonePerformer, objectState: "",),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          //   child: RefreshIndicator(
                          //     onRefresh: () async {},
                          //     child: ListView.builder(
                          //       padding: EdgeInsets.zero,
                          //       scrollDirection: Axis.vertical,
                          //       itemCount: tasksServices.tasksWithMyParticipation.length,
                          //       itemBuilder: (context, index) {
                          //
                          //         return Padding(
                          //           padding: EdgeInsetsDirectional.fromSTEB(
                          //               16, 8, 16, 0),
                          //           child: InkWell(
                          //             // onTap: () {
                          //             //   setState(() {
                          //             //     // Toggle light when tapped.
                          //             //   });
                          //             //   showDialog(context: context, builder: (context) => AlertDialog(
                          //             //     title: Text(tasksServices.tasksWithMyParticipation[index].title),
                          //             //     content: SingleChildScrollView(
                          //             //       child: ListBody(
                          //             //         children: <Widget>[
                          //             //           Text(tasksServices.tasksWithMyParticipation[index].description),
                          //             //           Text(tasksServices.tasksWithMyParticipation[index].contractOwner.toString()),
                          //             //           Text(tasksServices.tasksWithMyParticipation[index].contractAddress.toString()),
                          //             //         ],
                          //             //       ),
                          //             //     ),
                          //             //     actions: [
                          //             //       TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                          //             //       TextButton(child: Text('Participate'), onPressed: () {
                          //             //         print('Button pressed ...');
                          //             //         tasksServices.taskParticipation(tasksServices.tasksWithMyParticipation[index].contractAddress);
                          //             //       })
                          //             //     ],
                          //             //   ));
                          //             // },
                          //             child: Container(
                          //               width: double.infinity,
                          //               height: 86,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     blurRadius: 5,
                          //                     color: Color(0x4D000000),
                          //                     offset: Offset(0, 2),
                          //                   )
                          //                 ],
                          //                 borderRadius: BorderRadius.circular(8),
                          //               ),
                          //               child: Row(
                          //                 mainAxisSize: MainAxisSize.max,
                          //                 children: [
                          //                   Expanded(
                          //                     child: Padding(
                          //                       padding:
                          //                       EdgeInsetsDirectional.fromSTEB(
                          //                           12, 8, 8, 8),
                          //                       child: Column(
                          //                         mainAxisSize: MainAxisSize.max,
                          //                         crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                         children: [
                          //
                          //                           Text(
                          //                             tasksServices.tasksWithMyParticipation[index].title,
                          //                             style: FlutterFlowTheme.of(context).subtitle1,
                          //
                          //                           ),
                          //                           Text(
                          //                             tasksServices.tasksWithMyParticipation[index].description,
                          //                             style: FlutterFlowTheme.of(
                          //                                 context)
                          //                                 .bodyText2,
                          //                           ),
                          //                           Text(
                          //                             tasksServices.tasksWithMyParticipation[index].contractOwner.toString(),
                          //                             style: FlutterFlowTheme.of(
                          //                                 context)
                          //                                 .bodyText2,
                          //                           ),
                          //
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Badge(
                          //                     // position: BadgePosition.topEnd(top: 10, end: 10),
                          //                     badgeContent: Text(
                          //                         tasksServices.tasksWithMyParticipation[index].contributorsCount.toString(),
                          //                         style: TextStyle(fontWeight: FontWeight.bold)
                          //                     ),
                          //                     animationDuration: Duration(milliseconds: 300),
                          //                     animationType: BadgeAnimationType.scale,
                          //                     shape: BadgeShape.square,
                          //                     borderRadius: BorderRadius.circular(5),
                          //                     // child: Icon(Icons.settings),
                          //                   ),
                          //                   Padding(
                          //                     padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         0, 0, 12, 0),
                          //                     child: Icon(
                          //                       Icons.info_outlined,
                          //                       color: Colors.black,
                          //                       size: 24,
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             )
                          //           ),
                          //         );
                          //
                          //       },
                          //
                          //       // children: [
                          //       //
                          //       // ],
                          //     ),
                          //   ),
                          // ),


                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          //   child: RefreshIndicator(
                          //     onRefresh: () async {},
                          //     child: ListView.builder(
                          //       padding: EdgeInsets.zero,
                          //       scrollDirection: Axis.vertical,
                          //       itemCount: tasksServices.tasksWithMyParticipation.length,
                          //       itemBuilder: (context, index) {
                          //
                          //         return Padding(
                          //           padding: EdgeInsetsDirectional.fromSTEB(
                          //               16, 8, 16, 0),
                          //           child: InkWell(
                          //             // onTap: () {
                          //             //   setState(() {
                          //             //     // Toggle light when tapped.
                          //             //   });
                          //             //   showDialog(context: context, builder: (context) => AlertDialog(
                          //             //     title: Text(tasksServices.tasksWithMyParticipation[index].title),
                          //             //     content: SingleChildScrollView(
                          //             //       child: ListBody(
                          //             //         children: <Widget>[
                          //             //           Text(tasksServices.tasksWithMyParticipation[index].description),
                          //             //           Text(tasksServices.tasksWithMyParticipation[index].contractOwner.toString()),
                          //             //           Text(tasksServices.tasksWithMyParticipation[index].contractAddress.toString()),
                          //             //         ],
                          //             //       ),
                          //             //     ),
                          //             //     actions: [
                          //             //       TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                          //             //       TextButton(child: Text('Participate'), onPressed: () {
                          //             //         print('Button pressed ...');
                          //             //         tasksServices.taskParticipation(tasksServices.tasksWithMyParticipation[index].contractAddress);
                          //             //       })
                          //             //     ],
                          //             //   ));
                          //             // },
                          //               child: Container(
                          //                 width: double.infinity,
                          //                 height: 86,
                          //                 decoration: BoxDecoration(
                          //                   color: Colors.white,
                          //                   boxShadow: [
                          //                     BoxShadow(
                          //                       blurRadius: 5,
                          //                       color: Color(0x4D000000),
                          //                       offset: Offset(0, 2),
                          //                     )
                          //                   ],
                          //                   borderRadius: BorderRadius.circular(8),
                          //                 ),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   children: [
                          //                     Expanded(
                          //                       child: Padding(
                          //                         padding:
                          //                         EdgeInsetsDirectional.fromSTEB(
                          //                             12, 8, 8, 8),
                          //                         child: Column(
                          //                           mainAxisSize: MainAxisSize.max,
                          //                           crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                           children: [
                          //
                          //                             Text(
                          //                               tasksServices.tasksAgreedPerformer[index].title,
                          //                               style: FlutterFlowTheme.of(context).subtitle1,
                          //
                          //                             ),
                          //                             Text(
                          //                               tasksServices.tasksAgreedPerformer[index].description,
                          //                               style: FlutterFlowTheme.of(
                          //                                   context)
                          //                                   .bodyText2,
                          //                             ),
                          //                             Text(
                          //                               tasksServices.tasksAgreedPerformer[index].contractOwner.toString(),
                          //                               style: FlutterFlowTheme.of(
                          //                                   context)
                          //                                   .bodyText2,
                          //                             ),
                          //
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     // Badge(
                          //                     //   // position: BadgePosition.topEnd(top: 10, end: 10),
                          //                     //   badgeContent: Text(
                          //                     //       tasksServices.tasksWithMyParticipation[index].contributorsCount.toString(),
                          //                     //       style: TextStyle(fontWeight: FontWeight.bold)
                          //                     //   ),
                          //                     //   animationDuration: Duration(milliseconds: 300),
                          //                     //   animationType: BadgeAnimationType.scale,
                          //                     //   shape: BadgeShape.square,
                          //                     //   borderRadius: BorderRadius.circular(5),
                          //                     //   // child: Icon(Icons.settings),
                          //                     // ),
                          //                     Padding(
                          //                       padding:
                          //                       EdgeInsetsDirectional.fromSTEB(
                          //                           0, 0, 12, 0),
                          //                       child: Icon(
                          //                         Icons.info_outlined,
                          //                         color: Colors.black,
                          //                         size: 24,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               )
                          //           ),
                          //         );
                          //
                          //       },
                          //
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


class myPerformerTabWidget extends StatelessWidget {
  final String objectState;
  final obj;
  const myPerformerTabWidget({Key? key,
    required this.objectState, this.obj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
        child: RefreshIndicator(
          onRefresh: () async {},
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: obj.length,
            itemBuilder: (context, index) {

              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    16, 8, 16, 0),
                child: InkWell(

                  onTap: () {
                    // setState(() {
                    //   // Toggle light when tapped.
                    // });
                    if (obj[index].jobState != "new")
                    showDialog(context: context, builder: (context) => AlertDialog(
                      title: Text(obj[index].title),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(obj[index].description),
                            Text(obj[index].contractOwner.toString()),
                            Text(obj[index].contractAddress.toString()),
                          ],
                        ),
                      ),
                      actions: [

                        TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                        if (obj[index].jobState == "agreed")
                        TextButton(child: Text('Start the job'), onPressed: () {
                          tasksServices.changeTaskStatus(
                            obj[index].contractAddress,
                            obj[index].participiant,
                            'progress');
                        }),
                        if (obj[index].jobState == "progress")
                        TextButton(child: Text('Review'), onPressed: () {
                          tasksServices.changeTaskStatus(
                              obj[index].contractAddress,
                              obj[index].participiant,
                              'review');
                        }),
                        // if (obj[index].jobState == "Review")
                        //   TextButton(child: Text('Review'), onPressed: () {
                        //     tasksServices.changeTaskStatus(
                        //         obj[index].contractAddress,
                        //         obj[index].participiant,
                        //         'review');
                        //   }),
                      ],
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 86,
                    decoration:
                    BoxDecoration(
                      // color: obj[index].jobState != "new" ? Colors.white : Colors.white,
                      color: (() {
                        if (obj[index].jobState == "agreed") {
                          return Colors.orange.shade200;
                        } else if (obj[index].jobState == "review") {
                          return Colors.lightGreen.shade200;
                        } else {
                          return Colors.white;
                        }
                      }()),
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
                                  obj[index].title,
                                  style: FlutterFlowTheme.of(context).subtitle1,

                                ),
                                Text(
                                  obj[index].description,
                                  style: FlutterFlowTheme.of(
                                      context)
                                      .bodyText2,
                                ),
                                Text(
                                  obj[index].contractOwner.toString(),
                                  style: FlutterFlowTheme.of(
                                      context)
                                      .bodyText2,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (obj[index].jobState == "new")
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(
                              0, 0, 18, 0),
                          child: Badge(
                            // position: BadgePosition.topEnd(top: 10, end: 10),
                            badgeContent: Text(
                                obj[index].contributorsCount.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.scale,
                            shape: BadgeShape.square,
                            borderRadius: BorderRadius.circular(5),
                            // child: Icon(Icons.settings),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
