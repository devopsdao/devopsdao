import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/buttons.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/participants_list.dart';
import '../custom_widgets/selectMenu.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart';
import '../blockchain/task.dart';

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
                            taskCount: tasksServices.tasksPerformerProgress.length,
                            tabText: 'Working',
                          ),
                        ),
                        Tab(
                          // icon: const Icon(
                          //   Icons.done_outline,
                          // ),
                          child: BadgeTab(
                            taskCount: tasksServices.tasksPerformerComplete.length,
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
                              obj: tasksServices.tasksPerformerParticipate),
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
      ).animated([animationsMap['containerOnPageLoadAnimation']!]),
    );
  }
}

class MyPerformerTabWidget extends StatefulWidget {
  final Map<String, Task>? obj;
  final String tabName;
  const MyPerformerTabWidget({
    Key? key,
    required this.obj,
    required this.tabName
  }) : super(key: key);

  @override
  _MyPerformerTabWidget createState() => _MyPerformerTabWidget();
}

class _MyPerformerTabWidget extends State<MyPerformerTabWidget> {
  late bool justLoaded = true;

  @override
  Widget build(BuildContext context) {
    List objList = widget.obj!.values .toList();

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
                      // if (obj[index].jobState != "new")
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(objList[index].title),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      RichText(
                                          text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Description: \n',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: objList[index].description)
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Contract value: \n',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: '${objList[index].contractValue} DEV \n',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor:
                                                                1.0)),
                                            TextSpan(
                                                text: '${objList[index]
                                                        .contractValueToken} aUSDC',
                                                style: DefaultTextStyle.of(
                                                        context)
                                                    .style
                                                    .apply(fontSizeFactor: 1.0))
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Contract owner: \n',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: objList[index].contractOwner
                                                    .toString(),
                                                style: DefaultTextStyle.of(
                                                        context)
                                                    .style
                                                    .apply(fontSizeFactor: 0.7))
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Contract address: \n',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: objList[index].contractAddress
                                                    .toString(),
                                                style: DefaultTextStyle.of(
                                                        context)
                                                    .style
                                                    .apply(fontSizeFactor: 0.7))
                                          ])),
                                      RichText(
                                          text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                              children: <TextSpan>[
                                            const TextSpan(
                                                text: 'Created: ',
                                                style: TextStyle(
                                                    height: 2,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text: DateFormat(
                                                        'MM/dd/yyyy, hh:mm a')
                                                    .format(objList[index].createdTime),
                                                style: DefaultTextStyle.of(
                                                        context)
                                                    .style
                                                    .apply(fontSizeFactor: 1.0))
                                          ])),
                                      if (objList[index].jobState == "completed" &&
                                          (objList[index].contractValue != 0 ||
                                              objList[index].contractValueToken != 0))
                                        SelectNetworkMenu(
                                          object: objList[index],
                                        ),
                                      if (objList[index].jobState == 'audit')
                                        RichText(
                                            text: TextSpan(
                                                style:
                                                DefaultTextStyle.of(context)
                                                    .style
                                                    .apply(
                                                    fontSizeFactor: 1.0),
                                                children: const <TextSpan>[
                                                  TextSpan(
                                                      text: 'Warning, this contract on Audit state!  \n '
                                                          'Please choose auditor: ',
                                                      style: TextStyle(
                                                          height: 2,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                ])),
                                      if (objList[index].jobState == 'audit')
                                        ParticipantList(
                                          listType: 'auditor',
                                          obj: objList[index],
                                        )
                                    ],
                                  ),
                                ),
                                actions: [
                                  if (objList[index].jobState == "agreed")
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            objList[index].justLoaded =
                                                false;
                                          });
                                          tasksServices.changeTaskStatus(
                                              objList[index].contractAddress,
                                              objList[index].participiant,
                                              'progress',
                                              objList[index].nanoId);
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  WalletAction(
                                                    nanoId: objList[index].nanoId,
                                                    taskName:
                                                        'changeTaskStatus',
                                                  ));
                                        },
                                        child: const Text('Start the job')),
                                  if (objList[index].jobState == "progress")
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.green),
                                        onPressed: () {
                                          setState(() {
                                            objList[index].justLoaded =
                                                false;
                                          });
                                          tasksServices.changeTaskStatus(
                                              objList[index].contractAddress,
                                              objList[index].participiant,
                                              'review',
                                              objList[index].nanoId);
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  WalletAction(
                                                    nanoId: objList[index].nanoId,
                                                    taskName:
                                                        'changeTaskStatus',
                                                  ));
                                        },
                                        child: const Text('Review')),
                                  if (objList[index].jobState == "review")
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor:
                                                Colors.orangeAccent),
                                        onPressed: () {
                                          setState(() {
                                            objList[index].justLoaded =
                                                false;
                                          });
                                          tasksServices.changeTaskStatus(
                                              objList[index].contractAddress,
                                              objList[index].participiant,
                                              'audit',
                                              objList[index].nanoId);
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  WalletAction(
                                                    nanoId: objList[index].nanoId,
                                                    taskName:
                                                        'changeTaskStatus',
                                                  ));
                                        },
                                        child: const Text('Request audit')),
                                  if (objList[index].jobState ==
                                          "completed" &&
                                      (objList[index].contractValue != 0 ||
                                          objList[index]
                                                  .contractValueToken !=
                                              0))
                                    WithdrawButton(object: objList[index]),
                                  // TextButton(
                                  //     child: Text('Withdraw'),
                                  //     style: TextButton.styleFrom(
                                  //         primary: Colors.white,
                                  //         disabledBackgroundColor: Colors.white10,
                                  //         backgroundColor: Colors.green),
                                  //     onPressed: false ? () {
                                  //       if (widget.obj[index].jobState ==
                                  //           "completed" &&
                                  //           (widget.obj[index].contractValue != 0 ||
                                  //               widget.obj[index].contractValueToken != 0)) {
                                  //         setState(() {
                                  //           widget.obj[index].justLoaded = false;
                                  //         });
                                  //         tasksServices.withdrawToChain(
                                  //             widget.obj[index].contractAddress,
                                  //             widget.obj[index].nanoId);
                                  //         Navigator.pop(context);
                                  //
                                  //         showDialog(
                                  //             context: context,
                                  //             builder: (context) => WalletAction(
                                  //               nanoId:
                                  //               widget.obj[index].nanoId,
                                  //               taskName: 'withdrawToChain',
                                  //             ));
                                  //       }
                                  //     } : null),
                                  // if (widget.obj[index].jobState ==
                                  //         "completed" &&
                                  //     widget.obj[index].contractValue != 0)
                                  // TextButton(
                                  //     child: Text('Withdraw'),
                                  //     style: TextButton.styleFrom(
                                  //         primary: Colors.white,
                                  //         backgroundColor: Colors.green),
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         widget.obj[index].justLoaded =
                                  //             false;
                                  //       });
                                  //       tasksServices.withdraw(
                                  //           widget.obj[index].contractAddress,
                                  //           widget.obj[index].nanoId);
                                  //       Navigator.pop(context);
                                  //
                                  //       showDialog(
                                  //           context: context,
                                  //           builder: (context) =>
                                  //               WalletAction(
                                  //                 nanoId: widget
                                  //                     .obj[index].nanoId,
                                  //                 taskName: 'withdraw',
                                  //               ));
                                  //     }),
                                  // if (obj[index].jobState == "Review")
                                  //   TextButton(child: Text('Review'), onPressed: () {
                                  //     tasksServices.changeTaskStatus(
                                  //         obj[index].contractAddress,
                                  //         obj[index].participiant,
                                  //         'review');
                                  //   }),
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
                        // color: obj[index].jobState != "new" ? Colors.white : Colors.white,
                        color: (() {
                          if (objList[index].jobState == "agreed") {
                            return Colors.white;
                          } else if (objList[index].jobState == "review") {
                            return Colors.lightGreen.shade200;
                          } else if (objList[index].jobState == "progress") {
                            return Colors.blueGrey;
                          } else if (objList[index].jobState == "canceled") {
                            return Colors.orange;
                          } else if (objList[index].jobState == "audit") {
                            return Colors.orangeAccent;
                          } else {
                            return Colors.white;
                          }
                        }()),
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
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 8, 8, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          objList[index].title,
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
                                          objList[index].jobState,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          objList[index].description,
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
                                              .format(objList[index].createdTime),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                        ),
                                      ),
                                      // Spacer(),
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
                                      if (objList[index].contractValueToken !=
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
                                      if (objList[index].contractValue ==
                                              0 &&
                                          objList[index]
                                                  .contractValueToken ==
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
                          if (objList[index].jobState == "new" || objList[index].jobState == "audit")
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 18, 0),
                              child: Badge(
                                // position: BadgePosition.topEnd(top: 10, end: 10),
                                badgeContent: Container(
                                  width: 17,
                                  height: 17,
                                  alignment: Alignment.center,
                                  child: Text(
                                      objList[index].contributorsCount
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                badgeColor: (() {
                                  if (objList[index].jobState == "new") {
                                    return Colors.redAccent;
                                  } else if (objList[index].jobState == "audit") {
                                    return Colors.blueGrey;
                                  } else if (objList[index].jobState == "progress") {
                                    return Colors.blueGrey;
                                  } else if (objList[index].jobState == "canceled") {
                                    return Colors.orange;
                                  } else if (objList[index].jobState == "audit") {
                                    return Colors.orangeAccent;
                                  } else {
                                    return Colors.white;
                                  }
                                }()),
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                animationType: BadgeAnimationType.scale,
                                shape: BadgeShape.circle,
                                borderRadius: BorderRadius.circular(5),
                                // child: Icon(Icons.settings),
                              ),
                            ),
                          if (objList[index].justLoaded == false)
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
