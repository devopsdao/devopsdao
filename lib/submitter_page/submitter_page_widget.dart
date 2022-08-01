import 'package:badges/badges.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
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
                  'Submitter page',
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
          color: Colors.white,
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
                length: 5,
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
                          text: 'Selection',
                        ),
                        Tab(
                          text: 'agreed',
                        ),
                        Tab(
                          text: 'Progress',
                        ),
                        Tab(
                          text: 'Review',
                        ),
                        Tab(
                          text: 'Done',
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
                          mySubmitterTabWidget (obj: tasksServices.tasksOwner, objectState: "new",), //new
                          mySubmitterTabWidget (obj: tasksServices.tasksAgreedSubmitter, objectState: "agreed",), //agreed
                          mySubmitterTabWidget (obj: tasksServices.tasksProgressSubmitter, objectState: "progress",), //progress
                          mySubmitterTabWidget (obj: tasksServices.tasksReviewSubmitter, objectState: "review",), //review
                          mySubmitterTabWidget (obj: tasksServices.tasksDoneSubmitter, objectState: "review",), //completed & canceled

                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          //
                          //   child: ListView.builder(
                          //     padding: EdgeInsets.zero,
                          //     scrollDirection: Axis.vertical,
                          //     itemCount: tasksServices.tasksOwner.length,
                          //     itemBuilder: (context, index) {
                          //
                          //       return Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             16, 8, 16, 0),
                          //         child: Container(
                          //           // color: Colors.white,
                          //           child: InkWell(
                          //             onTap: () {
                          //               setState(() {
                          //                 // Toggle light when tapped.
                          //               });
                          //               showDialog(context: context, builder: (context) => AlertDialog(
                          //                 title: Text(tasksServices.tasksOwner[index].title),
                          //                 content: SingleChildScrollView(
                          //                   child: ListBody(
                          //                     children: <Widget>[
                          //                       Text("Description: ${tasksServices.tasksOwner[index].description}",
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Text('Contract owner: ${tasksServices.tasksOwner[index].contractOwner.toString()}',
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Text('Contract address: ${tasksServices.tasksOwner[index].contractAddress.toString()}',
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Divider(
                          //                         height: 20,
                          //                         thickness: 1,
                          //                         indent: 40,
                          //                         endIndent: 40,
                          //                         color: Colors.black,
                          //                       ),
                          //                       Text('Choose contractor',
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Container(
                          //                           height: 300.0, // Change as per your requirement
                          //                           width: 300.0, // Change as per your requirement
                          //                           child: ListView.builder(
                          //                             // padding: EdgeInsets.zero,
                          //                             // scrollDirection: Axis.vertical,
                          //                             //
                          //                             // shrinkWrap: true,
                          //                             // physics: NeverScrollableScrollPhysics(),
                          //                               itemCount: tasksServices.tasksOwner[index].contributors.length,
                          //                               itemBuilder: (context2, index2) {
                          //                                 return
                          //                                   Column(
                          //                                     children: [
                          //                                       // Text(
                          //                                       //   tasksServices.tasksOwner[index].contributors[index2].toString(),
                          //                                       //   style: FlutterFlowTheme.of(
                          //                                       //       context2)
                          //                                       //       .bodyText2,
                          //                                       // ),
                          //                                       TextButton(
                          //                                         style: TextButton.styleFrom(
                          //                                           textStyle: const TextStyle(fontSize: 13),
                          //                                         ),
                          //                                         onPressed: () {
                          //                                           tasksServices.changeTaskStatus(
                          //                                               tasksServices.tasksOwner[index].contractAddress,
                          //                                               tasksServices.tasksOwner[index].contributors[index2],
                          //                                               'agreed'
                          //                                           );
                          //                                         },
                          //                                         child: Text(tasksServices.tasksOwner[index].contributors[index2].toString()),
                          //                                       ),]
                          //                                 );
                          //                               }
                          //                           ),
                          //                       ),
                          //
                          //                     ],
                          //                   ),
                          //
                          //                 ),
                          //                 actions: [
                          //                   TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                          //                   // TextButton(child: Text('Participate'), onPressed: () {
                          //                   //   print('Button pressed ...');
                          //                   //   tasksServices.taskParticipation(tasksServices.tasksOwner[index].contractAddress);
                          //                   // })
                          //                 ],
                          //               ));
                          //             },
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
                          //
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
                          //                           Text(
                          //                             tasksServices.tasksOwner[index].title,
                          //                             style: FlutterFlowTheme.of(context).subtitle1,
                          //                           ),
                          //                           Text(
                          //                             tasksServices.tasksOwner[index].description,
                          //                             style: FlutterFlowTheme.of(
                          //                                 context)
                          //                                 .bodyText2,
                          //                           ),
                          //                           Text(
                          //                             tasksServices.tasksOwner[index].contractOwner.toString(),
                          //                             style: FlutterFlowTheme.of(
                          //                                 context)
                          //                                 .bodyText2,
                          //                           ),
                          //
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //
                          //                   tasksServices.tasksOwner[index].contributorsCount != 0 ? Badge(
                          //
                          //                     // position: BadgePosition.topEnd(top: 10, end: 10),
                          //                     badgeContent: Text(
                          //                         tasksServices.tasksOwner[index].contributorsCount.toString(),
                          //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          //                     ),
                          //                     animationDuration: Duration(milliseconds: 300),
                          //                     animationType: BadgeAnimationType.scale,
                          //                     shape: BadgeShape.square,
                          //                     borderRadius: BorderRadius.circular(5),
                          //                     // borderSide: BorderSide(color: Colors.black, width: 3),
                          //                     // child: Icon(Icons.settings),
                          //                   ) :
                          //
                          //                   Row(
                          //                   ),
                          //
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
                          //             ),
                          //           ),
                          //         ),
                          //
                          //
                          //
                          //
                          //
                          //       );
                          //     },
                          //     // children: [
                          //     //
                          //     // ],
                          //   ),
                          // ),

                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                          //
                          //   child: ListView.builder(
                          //     padding: EdgeInsets.zero,
                          //     scrollDirection: Axis.vertical,
                          //     itemCount: tasksServices.tasksAgreedSubmitter.length,
                          //     itemBuilder: (context, index) {
                          //
                          //       return Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             16, 8, 16, 0),
                          //         child: Container(
                          //           // color: Colors.white,
                          //           child: InkWell(
                          //             onTap: () {
                          //               setState(() {
                          //                 // Toggle light when tapped.
                          //               });
                          //               showDialog(context: context, builder: (context) => AlertDialog(
                          //                 title: Text(tasksServices.tasksAgreedSubmitter[index].title),
                          //                 content: SingleChildScrollView(
                          //                   child: ListBody(
                          //                     children: <Widget>[
                          //                       Text("Description: ${tasksServices.tasksAgreedSubmitter[index].description}",
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Text('Contract owner: ${tasksServices.tasksAgreedSubmitter[index].contractOwner.toString()}',
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Text('Contract address: ${tasksServices.tasksAgreedSubmitter[index].contractAddress.toString()}',
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       Divider(
                          //                         height: 20,
                          //                         thickness: 1,
                          //                         indent: 40,
                          //                         endIndent: 40,
                          //                         color: Colors.black,
                          //                       ),
                          //                       Text('text',
                          //                         style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                          //                       // Container(
                          //                       //   height: 300.0, // Change as per your requirement
                          //                       //   width: 300.0, // Change as per your requirement
                          //                       //   child: ListView.builder(
                          //                       //     // padding: EdgeInsets.zero,
                          //                       //     // scrollDirection: Axis.vertical,
                          //                       //     //
                          //                       //     // shrinkWrap: true,
                          //                       //     // physics: NeverScrollableScrollPhysics(),
                          //                       //       itemCount: tasksServices.tasksOwner[index].contributors.length,
                          //                       //       itemBuilder: (context2, index2) {
                          //                       //         return
                          //                       //           Column(
                          //                       //               children: [
                          //                       //                 // Text(
                          //                       //                 //   tasksServices.tasksOwner[index].contributors[index2].toString(),
                          //                       //                 //   style: FlutterFlowTheme.of(
                          //                       //                 //       context2)
                          //                       //                 //       .bodyText2,
                          //                       //                 // ),
                          //                       //                 TextButton(
                          //                       //                   style: TextButton.styleFrom(
                          //                       //                     textStyle: const TextStyle(fontSize: 13),
                          //                       //                   ),
                          //                       //                   onPressed: () {
                          //                       //                     tasksServices.changeTaskStatus(tasksServices.tasksOwner[index].contractAddress, 'agreed');
                          //                       //                   },
                          //                       //                   child: Text(tasksServices.tasksOwner[index].contributors[index2].toString()),
                          //                       //                 ),]
                          //                       //           );
                          //                       //       }
                          //                       //   ),
                          //                       // ),
                          //
                          //                     ],
                          //                   ),
                          //
                          //                 ),
                          //                 actions: [
                          //                   TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                          //                   TextButton(child: Text('Participate'), onPressed: () {
                          //                     print('Button pressed ...');
                          //                     // tasksServices.changeTaskStatus(
                          //                     //     tasksServices.tasksOwner[index].contractAddress,
                          //                     //     tasksServices.tasksOwner[index].contributors[index2],
                          //                     //     ""
                          //                     // );
                          //                   })
                          //                 ],
                          //               ));
                          //             },
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
                          //
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
                          //                           Text(
                          //                             tasksServices.tasksAgreedSubmitter[index].title,
                          //                             style: FlutterFlowTheme.of(context).subtitle1,
                          //                           ),
                          //                           Text(
                          //                             tasksServices.tasksAgreedSubmitter[index].description,
                          //                             style: FlutterFlowTheme.of(
                          //                                 context)
                          //                                 .bodyText2,
                          //                           ),
                          //                           Text(
                          //                             tasksServices.tasksAgreedSubmitter[index].contractOwner.toString(),
                          //                             style: FlutterFlowTheme.of(
                          //                                 context)
                          //                                 .bodyText2,
                          //                           ),
                          //
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //
                          //                   // tasksServices.tasksAgreed[index].contributorsCount != 0 ? Badge(
                          //                   //
                          //                   //   // position: BadgePosition.topEnd(top: 10, end: 10),
                          //                   //   badgeContent: Text(
                          //                   //     tasksServices.tasksAgreed[index].contributorsCount.toString(),
                          //                   //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          //                   //   ),
                          //                   //   animationDuration: Duration(milliseconds: 300),
                          //                   //   animationType: BadgeAnimationType.scale,
                          //                   //   shape: BadgeShape.square,
                          //                   //   borderRadius: BorderRadius.circular(5),
                          //                   //   // borderSide: BorderSide(color: Colors.black, width: 3),
                          //                   //   // child: Icon(Icons.settings),
                          //                   // ) :
                          //                   //
                          //                   // Row(
                          //                   // ),
                          //
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
                          //             ),
                          //           ),
                          //         ),
                          //
                          //
                          //
                          //
                          //
                          //       );
                          //     },
                          //     // children: [
                          //     //
                          //     // ],
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

  // Widget _myTabWidget(BuildContext context) {
  //   return Column();
  // }
  // _buildExpandableContent(Task task) {
  //   List<Widget> columnContent = [
  //     new ListTile(
  //         title: Text(task.description)
  //     )
  //   ];
  //
  //   return columnContent;
  // }
}

class mySubmitterTabWidget extends StatelessWidget {
  final String objectState;
  final obj;
  const mySubmitterTabWidget({Key? key,
    required this.objectState, this.obj,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // TODO: implement build
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),

        child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: obj.length,
          itemBuilder: (context, index) {

            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  16, 8, 16, 0),
              child: Container(
                // color: Colors.white,
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   // Toggle light when tapped.
                    // });
                    showDialog(context: context, builder: (context) => AlertDialog(
                      title: Text(obj[index].title),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text("Description: ${obj[index].description}",
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                            Text('Contract owner: ${obj[index].contractOwner.toString()}',
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                            Text('Contract address: ${obj[index].contractAddress.toString()}',
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                            Divider(
                              height: 20,
                              thickness: 1,
                              indent: 40,
                              endIndent: 40,
                              color: Colors.black,
                            ),
                            obj[index].jobState == "new" ?
                            Text('Choose contractor',
                              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),)
                            :
                            Text('text',
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                            if (obj[index].jobState == "new")
                              Container(
                                height: 300.0, // Change as per your requirement
                                width: 300.0, // Change as per your requirement
                                child: ListView.builder(
                                  // padding: EdgeInsets.zero,
                                  // scrollDirection: Axis.vertical,
                                  //
                                  // shrinkWrap: true,
                                  // physics: NeverScrollableScrollPhysics(),
                                    itemCount: obj[index].contributors.length,
                                    itemBuilder: (context2, index2) {
                                      return
                                        Column(
                                            children: [
                                              // Text(
                                              //   tasksServices.tasksOwner[index].contributors[index2].toString(),
                                              //   style: FlutterFlowTheme.of(
                                              //       context2)
                                              //       .bodyText2,
                                              // ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(fontSize: 13),
                                                ),
                                                onPressed: () {
                                                  tasksServices.changeTaskStatus(
                                                      obj[index].contractAddress,
                                                      obj[index].contributors[index2],
                                                      'agreed'
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: Text(obj[index].contributors[index2].toString()),
                                              ),]
                                        );
                                    }
                                ),
                              ),

                          ],
                        ),

                      ),
                      actions: [
                        TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                        if (obj[index].jobState == 'review')
                          TextButton(child: Text('Complete Task'), onPressed: () {
                            tasksServices.changeTaskStatus(obj[index].contractAddress, obj[index].participiant, 'completed');
                          }),
                        if (obj[index].jobState == 'completed')
                          TextButton(child: Text('Withdraw'), onPressed: () {
                            tasksServices.withdraw(obj[index].contractAddress);
                          }),
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

                        if (obj[index].contributorsCount != 0 && obj[index].jobState == "new")
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(
                              0, 0, 12, 0),
                          child: Badge(
                            // position: BadgePosition.topEnd(top: 10, end: 10),
                            badgeContent: Text(
                              obj[index].contributorsCount.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.scale,
                            shape: BadgeShape.square,
                            borderRadius: BorderRadius.circular(5),
                            // borderSide: BorderSide(color: Colors.black, width: 3),
                            // child: Icon(Icons.settings),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            );
          },
          // children: [
          //
          // ],
        ),
      ),
    );
  }
}

