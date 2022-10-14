import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/buttons.dart';
import '../custom_widgets/loading.dart';
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
                          icon: const FaIcon(
                            FontAwesomeIcons.smileBeam,
                          ),
                          child: BadgeTab(
                            taskCount:
                                tasksServices.tasksWithMyParticipation.length,
                            tabText: 'Applied for',
                          ),
                        ),
                        Tab(
                          icon: const Icon(
                            Icons.card_travel_outlined,
                          ),
                          child: BadgeTab(
                            taskCount: tasksServices.tasksPerformer.length,
                            tabText: 'Working on',
                          ),
                        ),
                        Tab(
                          icon: const Icon(
                            Icons.done_outline,
                          ),
                          child: BadgeTab(
                            taskCount: tasksServices.tasksDonePerformer.length,
                            tabText: 'Done',
                          ),
                        ),
                      ],
                    ),
                    tasksServices.isLoading
                        ? const LoadIndicator()
                        : Expanded(
                            child: TabBarView(
                              children: [
                                myPerformerTabWidget(
                                    obj:
                                        tasksServices.tasksWithMyParticipation),
                                myPerformerTabWidget(
                                    obj: tasksServices.tasksPerformer),
                                myPerformerTabWidget(
                                    obj: tasksServices.tasksDonePerformer),
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

class myPerformerTabWidget extends StatefulWidget {
  final Map<String, Task>? obj;
  myPerformerTabWidget({
    Key? key,
    required this.obj,
  }) : super(key: key);

  @override
  _myPerformerTabWidget createState() => _myPerformerTabWidget();
}

class _myPerformerTabWidget extends State<myPerformerTabWidget> {
  late bool justLoaded = true;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
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
                    // if (obj[index].jobState != "new")
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  widget.obj!.values.toList()[index].title),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Description: \n',
                                              style: TextStyle(
                                                  height: 2,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: widget.obj!.values
                                                  .toList()[index]
                                                  .description)
                                        ])),
                                    RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style
                                                .apply(fontSizeFactor: 1.0),
                                            children: <TextSpan>[
                                          const TextSpan(
                                              text: 'Contract value: \n',
                                              style: TextStyle(
                                                  height: 2,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text:
                                                  '${widget.obj!.values.toList()[index].contractValue} DEV \n',
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0)),
                                          TextSpan(
                                              text:
                                                  '${widget.obj!.values.toList()[index].contractValueToken} aUSDC',
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
                                          const TextSpan(
                                              text: 'Contract owner: \n',
                                              style: TextStyle(
                                                  height: 2,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: widget.obj!.values
                                                  .toList()[index]
                                                  .contractOwner
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
                                          const TextSpan(
                                              text: 'Contract address: \n',
                                              style: TextStyle(
                                                  height: 2,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: widget.obj!.values
                                                  .toList()[index]
                                                  .contractAddress
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
                                          const TextSpan(
                                              text: 'Created: ',
                                              style: TextStyle(
                                                  height: 2,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(
                                              text: DateFormat(
                                                      'MM/dd/yyyy, hh:mm a')
                                                  .format(widget.obj!.values
                                                      .toList()[index]
                                                      .createdTime),
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0))
                                        ])),
                                    if (widget.obj!.values
                                                .toList()[index]
                                                .jobState ==
                                            "completed" &&
                                        (widget.obj!.values
                                                    .toList()[index]
                                                    .contractValue !=
                                                0 ||
                                            widget.obj!.values
                                                    .toList()[index]
                                                    .contractValueToken !=
                                                0))
                                      SelectNetworkMenu(
                                        object:
                                            widget.obj!.values.toList()[index],
                                      )
                                  ],
                                ),
                              ),
                              actions: [
                                if (widget.obj!.values
                                        .toList()[index]
                                        .jobState ==
                                    "agreed")
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        setState(() {
                                          widget.obj!.values
                                              .toList()[index]
                                              .justLoaded = false;
                                        });
                                        tasksServices.changeTaskStatus(
                                            widget.obj!.values
                                                .toList()[index]
                                                .contractAddress,
                                            widget.obj!.values
                                                .toList()[index]
                                                .participiant,
                                            'progress',
                                            widget.obj!.values
                                                .toList()[index]
                                                .nanoId);
                                        Navigator.pop(context);

                                        showDialog(
                                            context: context,
                                            builder: (context) => WalletAction(
                                                  nanoId: widget.obj!.values
                                                      .toList()[index]
                                                      .nanoId,
                                                  taskName: 'changeTaskStatus',
                                                ));
                                      },
                                      child: const Text('Start the job')),
                                if (widget.obj!.values
                                        .toList()[index]
                                        .jobState ==
                                    "progress")
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        setState(() {
                                          widget.obj!.values
                                              .toList()[index]
                                              .justLoaded = false;
                                        });
                                        tasksServices.changeTaskStatus(
                                            widget.obj!.values
                                                .toList()[index]
                                                .contractAddress,
                                            widget.obj!.values
                                                .toList()[index]
                                                .participiant,
                                            'review',
                                            widget.obj!.values
                                                .toList()[index]
                                                .nanoId);
                                        Navigator.pop(context);

                                        showDialog(
                                            context: context,
                                            builder: (context) => WalletAction(
                                                  nanoId: widget.obj!.values
                                                      .toList()[index]
                                                      .nanoId,
                                                  taskName: 'changeTaskStatus',
                                                ));
                                      },
                                      child: const Text('Review')),
                                if (widget.obj!.values
                                        .toList()[index]
                                        .jobState ==
                                    "review")
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Colors.orangeAccent),
                                      onPressed: () {
                                        setState(() {
                                          widget.obj!.values
                                              .toList()[index]
                                              .justLoaded = false;
                                        });
                                        tasksServices.changeTaskStatus(
                                            widget.obj!.values
                                                .toList()[index]
                                                .contractAddress,
                                            widget.obj!.values
                                                .toList()[index]
                                                .participiant,
                                            'audit',
                                            widget.obj!.values
                                                .toList()[index]
                                                .nanoId);
                                        Navigator.pop(context);

                                        showDialog(
                                            context: context,
                                            builder: (context) => WalletAction(
                                                  nanoId: widget.obj!.values
                                                      .toList()[index]
                                                      .nanoId,
                                                  taskName: 'changeTaskStatus',
                                                ));
                                      },
                                      child: const Text('Request audit')),
                                if (widget.obj!.values
                                            .toList()[index]
                                            .jobState ==
                                        "completed" &&
                                    (widget.obj!.values
                                                .toList()[index]
                                                .contractValue !=
                                            0 ||
                                        widget.obj!.values
                                                .toList()[index]
                                                .contractValueToken !=
                                            0))
                                  WithdrawButton(
                                      object:
                                          widget.obj!.values.toList()[index]),
                                // TextButton(
                                //     child: Text('Withdraw'),
                                //     style: TextButton.styleFrom(
                                //         primary: Colors.white,
                                //         disabledBackgroundColor: Colors.white10,
                                //         backgroundColor: Colors.green),
                                //     onPressed: false ? () {
                                //       if (widget.obj!.values.toList()[index].jobState ==
                                //           "completed" &&
                                //           (widget.obj!.values.toList()[index].contractValue != 0 ||
                                //               widget.obj!.values.toList()[index].contractValueToken != 0)) {
                                //         setState(() {
                                //           widget.obj!.values.toList()[index].justLoaded = false;
                                //         });
                                //         tasksServices.withdrawToChain(
                                //             widget.obj!.values.toList()[index].contractAddress,
                                //             widget.obj!.values.toList()[index].nanoId);
                                //         Navigator.pop(context);
                                //
                                //         showDialog(
                                //             context: context,
                                //             builder: (context) => WalletAction(
                                //               nanoId:
                                //               widget.obj!.values.toList()[index].nanoId,
                                //               taskName: 'withdrawToChain',
                                //             ));
                                //       }
                                //     } : null),
                                // if (widget.obj!.values.toList()[index].jobState ==
                                //         "completed" &&
                                //     widget.obj!.values.toList()[index].contractValue != 0)
                                // TextButton(
                                //     child: Text('Withdraw'),
                                //     style: TextButton.styleFrom(
                                //         primary: Colors.white,
                                //         backgroundColor: Colors.green),
                                //     onPressed: () {
                                //       setState(() {
                                //         widget.obj!.values.toList()[index].justLoaded =
                                //             false;
                                //       });
                                //       tasksServices.withdraw(
                                //           widget.obj!.values.toList()[index].contractAddress,
                                //           widget.obj!.values.toList()[index].nanoId);
                                //       Navigator.pop(context);
                                //
                                //       showDialog(
                                //           context: context,
                                //           builder: (context) =>
                                //               WalletAction(
                                //                 nanoId: widget
                                //                     .obj!.values.toList()[index].nanoId,
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
                        if (widget.obj!.values.toList()[index].jobState ==
                            "agreed") {
                          return Colors.orange.shade200;
                        } else if (widget.obj!.values
                                .toList()[index]
                                .jobState ==
                            "review") {
                          return Colors.lightGreen.shade200;
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
                                        widget.obj!.values
                                            .toList()[index]
                                            .title,
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
                                        widget.obj!.values
                                            .toList()[index]
                                            .jobState,
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
                                        widget.obj!.values
                                            .toList()[index]
                                            .description,
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
                                            .format(widget.obj!.values
                                                .toList()[index]
                                                .createdTime),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                    // Spacer(),
                                    if (widget.obj!.values
                                            .toList()[index]
                                            .contractValue !=
                                        0)
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${widget.obj!.values.toList()[index].contractValue} ETH',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    if (widget.obj!.values
                                            .toList()[index]
                                            .contractValueToken !=
                                        0)
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${widget.obj!.values.toList()[index].contractValueToken} aUSDC',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyText2,
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    if (widget.obj!.values
                                                .toList()[index]
                                                .contractValue ==
                                            0 &&
                                        widget.obj!.values
                                                .toList()[index]
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
                        if (widget.obj!.values.toList()[index].jobState ==
                            "new")
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
                                    widget.obj!.values
                                        .toList()[index]
                                        .contributorsCount
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              animationType: BadgeAnimationType.scale,
                              shape: BadgeShape.circle,
                              borderRadius: BorderRadius.circular(5),
                              // child: Icon(Icons.settings),
                            ),
                          ),
                        if (widget.obj!.values.toList()[index].justLoaded ==
                            false)
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
    );
  }
}
