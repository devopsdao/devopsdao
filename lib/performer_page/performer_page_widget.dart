import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
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
          LoadButtonIndicator(),
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

                    tasksServices.isLoading ?
                    LoadIndicator()
                        :
                    Expanded(
                      child: TabBarView(
                        children: [
                          myPerformerTabWidget (obj: tasksServices.tasksWithMyParticipation),
                          myPerformerTabWidget (obj: tasksServices.tasksPerformer),
                          myPerformerTabWidget (obj: tasksServices.tasksDonePerformer),
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
  final obj;
  const myPerformerTabWidget({Key? key,
    this.obj,
  }) : super(key: key);

  @override
  _myPerformerTabWidget createState() => _myPerformerTabWidget();
}

class _myPerformerTabWidget extends State<myPerformerTabWidget> {
  late bool justLoaded = true;

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
            itemCount: widget.obj.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                    16, 8, 16, 0),
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   // Toggle light when tapped.
                    // });
                    // if (obj[index].jobState != "new")
                    showDialog(context: context, builder: (context) => AlertDialog(
                      title: Text(widget.obj[index].title),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            RichText(text: TextSpan(
                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Description: \n',
                                      style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                  TextSpan(text: widget.obj[index].description)
                                ]
                            )),
                            RichText(text: TextSpan(
                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Contract value: \n',
                                      style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: widget.obj[index].contractValue.toString() + ' Eth',
                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0))
                                ]
                            )),
                            RichText(text: TextSpan(
                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Contract owner: \n',
                                      style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: widget.obj[index].contractOwner.toString(),
                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7))
                                ]
                            )),
                            RichText(text: TextSpan(
                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Contract address: \n',
                                      style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: widget.obj[index].contractAddress.toString(),
                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.7)
                                  )
                                ]
                            )),
                            RichText(text: TextSpan(
                                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Created: ',
                                      style: const TextStyle(height: 2, fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: DateFormat('MM/dd/yyyy, hh:mm a').format(widget.obj[index].createdTime),
                                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0)
                                  )
                                ]
                            )),
                            if (widget.obj[index].jobState == "completed" && widget.obj[index].contractValue != 0)
                              SelectNetworkMenu()
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(child: Text('Close'), onPressed: () => Navigator.pop(context)),
                        if (widget.obj[index].jobState == "agreed")
                        TextButton(
                          child: Text('Start the job'),
                          style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
                          onPressed: () {
                            setState(() {
                              widget.obj[index].justLoaded = false;
                            });
                            tasksServices.changeTaskStatus(
                              widget.obj[index].contractAddress,
                              widget.obj[index].participiant,
                            'progress');
                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) => WalletAction()
                            );

                        }),
                        if (widget.obj[index].jobState == "progress")
                        TextButton(
                          child: Text('Review'),
                          style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
                          onPressed: () {
                            setState(() {
                              widget.obj[index].justLoaded = false;
                            });
                            tasksServices.changeTaskStatus(
                              widget.obj[index].contractAddress,
                              widget.obj[index].participiant,
                              'review');
                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) => WalletAction()
                            );
                          }
                        ),
                        if (widget.obj[index].jobState == "completed" && widget.obj[index].contractValue != 0)
                          TextButton(
                              child: Text('Withdraw to Chain'),
                              style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
                              onPressed: () {
                                setState(() {
                                  widget.obj[index].justLoaded = false;
                                });
                                tasksServices.withdrawToChain(widget.obj[index].contractAddress);
                                Navigator.pop(context);

                                showDialog(
                                    context: context,
                                    builder: (context) => WalletAction()
                                );
                              }
                          ),
                        if (widget.obj[index].jobState == "completed" && widget.obj[index].contractValue != 0)
                          TextButton(
                            child: Text('Withdraw'),
                            style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
                            onPressed: () {
                              setState(() {
                                widget.obj[index].justLoaded = false;
                              });
                              tasksServices.withdraw(widget.obj[index].contractAddress);
                              Navigator.pop(context);

                              showDialog(
                                  context: context,
                                  builder: (context) => WalletAction()
                              );
                            }
                          ),
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
                        if (widget.obj[index].jobState == "agreed") {
                          return Colors.orange.shade200;
                        } else if (widget.obj[index].jobState == "review") {
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

                                Row(
                                  children: [
                                    Expanded( flex: 7, child:
                                      Text(
                                        widget.obj[index].title,
                                        style: FlutterFlowTheme.of(context).subtitle1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                    // Spacer(),
                                    Expanded( flex: 3, child:
                                      Text(
                                        widget.obj[index].jobState,
                                        style: FlutterFlowTheme.of(
                                            context)
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
                                          widget.obj[index].description,
                                          style: FlutterFlowTheme.of(
                                              context)
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
                                    Expanded( flex: 7, child:
                                      Text(
                                        DateFormat('MM/dd/yyyy, hh:mm a').format(widget.obj[index].createdTime),
                                        style: FlutterFlowTheme.of(
                                            context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                      ),
                                    ),
                                    // Spacer(),
                                    Expanded( flex: 3, child:
                                      Text(
                                        widget.obj[index].contractValue.toString()
                                            + ' Eth',
                                        style: FlutterFlowTheme.of(
                                            context)
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
                        if (widget.obj[index].jobState == "new")
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(
                              0, 0, 18, 0),
                          child: Badge(
                            // position: BadgePosition.topEnd(top: 10, end: 10),
                            badgeContent: Container(
                              width: 17,
                              height: 17,
                              alignment: Alignment.center,
                              child: Text(
                                  widget.obj[index].contributorsCount.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                              ),
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
                          EdgeInsetsDirectional.fromSTEB(
                              0, 0, 12, 0),
                          child: CircularProgressIndicator(),
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
