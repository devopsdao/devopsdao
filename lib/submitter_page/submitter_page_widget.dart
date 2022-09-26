import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/payment.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/loading.dart';
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
        actions: [
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
      backgroundColor: Color(0xFF1E2429),
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
                      // isScrollable: true,
                      tabs: [
                        Tab(
                          child: BadgeTab(
                            taskCount: tasksServices.tasksOwner.length,
                            tabText: 'Selection',
                          ),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksAgreedSubmitter.length,
                              tabText: 'Agreed'),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksProgressSubmitter.length,
                              tabText: 'Progress'),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksReviewSubmitter.length,
                              tabText: 'Review'),
                        ),
                        Tab(
                          child: BadgeTab(
                              taskCount:
                                  tasksServices.tasksDoneSubmitter.length,
                              tabText: 'Done'),
                        ),
                      ],
                    ),
                    tasksServices.isLoading
                        ? LoadIndicator()
                        : Expanded(
                            child: TabBarView(
                              children: [
                                mySubmitterTabWidget(
                                    obj: tasksServices.tasksOwner), //new
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksAgreedSubmitter), //agreed
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksProgressSubmitter), //progress
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksReviewSubmitter), //review
                                mySubmitterTabWidget(
                                    obj: tasksServices
                                        .tasksDoneSubmitter), //completed & canceled
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
  final obj;
  const mySubmitterTabWidget({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _mySubmitterTabWidgetState createState() => _mySubmitterTabWidgetState();
}

class _mySubmitterTabWidgetState extends State<mySubmitterTabWidget> {
  late bool justLoaded = true;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var Interface = context.watch<InterfaceServices>();
    // TODO: implement build
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            tasksServices.isLoadingBackground = true;
            tasksServices.fetchTasks();
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: widget.obj.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: Container(
                  // color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      // setState(() {
                      //   // Toggle light when tapped.
                      // });
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(widget.obj[index].title),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      // Divider(
                                      //   height: 20,
                                      //   thickness: 1,
                                      //   indent: 40,
                                      //   endIndent: 40,
                                      //   color: Colors.black,
                                      // ),
                                      RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: 'Description: \n',
                                                style: const TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    widget.obj[index].description)
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: 'Contract value: \n',
                                                style: const TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: widget
                                                        .obj[index].contractValue
                                                        .toString() +
                                                    ' DEV \n',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor: 1.0)),
                                            TextSpan(
                                                text: widget.obj[index]
                                                        .contractValueToken
                                                        .toString() +
                                                    ' aUSDC',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor: 1.0))
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: 'Contract owner: \n',
                                                style: const TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: widget
                                                    .obj[index].contractOwner
                                                    .toString(),
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor: 0.7))
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: 'Contract address: \n',
                                                style: const TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: widget
                                                    .obj[index].contractAddress
                                                    .toString(),
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor: 0.7))
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style: DefaultTextStyle.of(context)
                                                  .style
                                                  .apply(fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: 'Created: ',
                                                style: const TextStyle(
                                                    height: 2,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: DateFormat(
                                                        'MM/dd/yyyy, hh:mm a')
                                                    .format(widget
                                                        .obj[index].createdTime),
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor: 1.0))
                                          ])),
                                      // Text("Description: ${tasksServices.tasksNew[index].description}",
                                      //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                      // Text('Contract owner: ${tasksServices.tasksNew[index].contractOwner.toString()}',
                                      //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                      // Text('Contract address: ${tasksServices.tasksNew[index].contractAddress.toString()}',
                                      //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                      // Divider(
                                      //   height: 20,
                                      //   thickness: 1,
                                      //   indent: 40,
                                      //   endIndent: 40,
                                      //   color: Colors.black,
                                      // ),
                                      if (widget.obj[index].jobState == "new")
                                        // Text('Choose contractor: ',
                                        //   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                        RichText(
                                            text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor: 1.0),
                                                children: <TextSpan>[
                                              TextSpan(
                                                  text: 'Choose contractor: ',
                                                  style: const TextStyle(
                                                      height: 2,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ])),

                                      // if (widget.obj[index].jobState != "new" )
                                      // Text('text',
                                      // style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),),
                                      if (widget.obj[index].jobState == "new")
                                        Container(
                                          height:
                                              300.0, // Change as per your requirement
                                          width:
                                              300.0, // Change as per your requirement
                                          child: ListView.builder(
                                              // padding: EdgeInsets.zero,
                                              // scrollDirection: Axis.vertical,
                                              // shrinkWrap: true,
                                              // physics: NeverScrollableScrollPhysics(),
                                              itemCount: widget
                                                  .obj[index].contributors.length,
                                              itemBuilder: (context2, index2) {
                                                return Column(children: [
                                                  // Text(
                                                  //   tasksServices.tasksOwner[index].contributors[index2].toString(),
                                                  //   style: FlutterFlowTheme.of(
                                                  //       context2)
                                                  //       .bodyText2,
                                                  // ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        widget.obj[index]
                                                            .justLoaded = false;
                                                      });
                                                      tasksServices.changeTaskStatus(
                                                          widget.obj[index]
                                                              .contractAddress,
                                                          widget.obj[index]
                                                                  .contributors[
                                                              index2],
                                                          'agreed',
                                                          widget
                                                              .obj[index].nanoId);
                                                      Navigator.pop(context);

                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              WalletAction(
                                                                nanoId: widget
                                                                    .obj[index]
                                                                    .nanoId,
                                                                taskName:
                                                                    'changeTaskStatus',
                                                              ));
                                                    },
                                                    child: Text(
                                                      widget.obj[index]
                                                          .contributors[index2]
                                                          .toString(),
                                                      style: DefaultTextStyle.of(
                                                              context)
                                                          .style
                                                          .apply(
                                                              fontSizeFactor:
                                                                  0.7),
                                                    ),
                                                  ),
                                                ]);
                                              }),
                                        ),
                                    ],
                                  ),
                                ),
                                actions: [

            /////////////topup
                                  // TextButton(
                                  //   child: Text('Topup contract'),
                                  //   onPressed: () {
                                  //     showDialog(
                                  //         context: context,
                                  //         builder: (context) => AlertDialog(
                                  //               title: Text('Topup contract'),
                                  //               // backgroundColor: Colors.black,
                                  //               content: Payment(
                                  //                 purpose: 'topup',
                                  //               ),
                                  //               actions: [
                                  //                 TextButton(
                                  //                   onPressed: () {
                                  //                     tasksServices.addTokens(
                                  //                         widget.obj[index]
                                  //                             .contractAddress,
                                  //                         Interface.tokensEntered,
                                  //                         widget
                                  //                             .obj[index].nanoId);
                                  //                     Navigator.pop(context);
                                  //
                                  //                     showDialog(
                                  //                         context: context,
                                  //                         builder: (context) =>
                                  //                             WalletAction(
                                  //                               nanoId: widget
                                  //                                   .obj[index]
                                  //                                   .nanoId,
                                  //                               taskName:
                                  //                                   'addTokens',
                                  //                             ));
                                  //                   },
                                  //                   child: Text('Topup!'),
                                  //                   style: TextButton.styleFrom(
                                  //                       primary: Colors.white,
                                  //                       backgroundColor:
                                  //                           Colors.green),
                                  //                 ),
                                  //                 TextButton(
                                  //                     child: Text('Close'),
                                  //                     onPressed: () =>
                                  //                         Navigator.pop(context)),
                                  //               ],
                                  //             ));
                                  //   },
                                  //   style: TextButton.styleFrom(
                                  //       primary: Colors.white,
                                  //       backgroundColor: Colors.green),
                                  // ),

                                  // TextButton(
                                  //     child: Text('Withdraw to Chain'),
                                  //     style: TextButton.styleFrom(
                                  //         primary: Colors.white,
                                  //         backgroundColor: Colors.green),
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         widget.obj[index].justLoaded = false;
                                  //       });
                                  //       tasksServices.withdrawToChain(
                                  //           widget.obj[index].contractAddress,
                                  //           widget.obj[index].nanoId);
                                  //       Navigator.pop(context);
                                  //
                                  //       showDialog(
                                  //           context: context,
                                  //           builder: (context) => WalletAction(
                                  //                 nanoId:
                                  //                     widget.obj[index].nanoId,
                                  //                 taskName: 'withdrawToChain',
                                  //               ));
                                  //     }),

                                  if (widget.obj[index].jobState == 'review')
                                    TextButton(
                                        child: Text('Sign Review'),
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            widget.obj[index].justLoaded = false;
                                          });
                                          tasksServices.changeTaskStatus(
                                              widget.obj[index].contractAddress,
                                              widget.obj[index].participiant,
                                              'completed',
                                              widget.obj[index].nanoId);
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              builder: (context) => WalletAction(
                                                    nanoId:
                                                        widget.obj[index].nanoId,
                                                    taskName: 'changeTaskStatus',
                                                  ));
                                        }),
                                  TextButton(
                                      child: Text('Close'),
                                      onPressed: () => Navigator.pop(context)),
                                  // if (widget.obj[index].jobState == 'completed')
                                  //   TextButton(
                                  //     child: Text('Withdraw'),
                                  //     style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         widget.obj[index].justLoaded = false;
                                  //       });
                                  //       tasksServices.withdraw(widget.obj[index].contractAddress);
                                  //       Navigator.pop(context);
                                  //
                                  //       showDialog(
                                  //           context: context,
                                  //           builder: (context) => WalletAction()
                                  //       );
                                  //   }),
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
                                  EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          widget.obj[index].title,
                                          style: FlutterFlowTheme.of(context)
                                              .subtitle1,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                      // Spacer(),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          widget.obj[index].jobState,
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
                                  // Text(
                                  //   widget.obj[index].title,
                                  //   style: FlutterFlowTheme.of(context).subtitle1,
                                  // ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.obj[index].description,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          DateFormat('MM/dd/yyyy, hh:mm a')
                                              .format(
                                                  widget.obj[index].createdTime),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                      // Spacer(),
                                      if (widget.obj[index].contractValue != 0)
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            widget.obj[index].contractValue
                                                    .toString() +
                                                ' ETH',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      if (widget.obj[index].contractValueToken !=
                                          0)
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            widget.obj[index].contractValueToken
                                                    .toString() +
                                                ' aUSDC',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyText2,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      if (widget.obj[index].contractValue == 0 &&
                                          widget.obj[index].contractValueToken ==
                                              0)
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
                          if (widget.obj[index].contributorsCount != 0 &&
                              widget.obj[index].jobState == "new")
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                              child: Badge(
                                // position: BadgePosition.topEnd(top: 10, end: 10),
                                badgeContent: Container(
                                  width: 17,
                                  height: 17,
                                  alignment: Alignment.center,
                                  child: Text(
                                      widget.obj[index].contributorsCount
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                animationDuration: Duration(milliseconds: 300),
                                animationType: BadgeAnimationType.scale,
                                shape: BadgeShape.circle,
                                borderRadius: BorderRadius.circular(5),
                                // child: Icon(Icons.settings),
                              ),
                            ),
                          if (widget.obj[index].justLoaded == false)
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ),
    );
  }
}
