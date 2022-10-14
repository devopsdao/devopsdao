import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/participants_list.dart';
import '../custom_widgets/wallet_action.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

// class ExchangeFilterWidget extends ChangeNotifier {
//   List<Task> filterResults = [];
//
//   void _runFilter(String enteredKeyword, _allTasks) {
//
//     filterResults.clear();
//     // filterResults = _allTasks.toList();
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all tasks
//       filterResults = _allTasks.toList();
//       // print(filterResults);
//
//     } else {
//       for (int i = 0; i<_allTasks.length ; i++) {
//         if(_allTasks.elementAt(i).title.toLowerCase().contains(enteredKeyword.toLowerCase())) {
//           print('${_allTasks.elementAt(i).title}');
//           filterResults.add(_allTasks.elementAt(i));
//           // notifyListeners();
//         }
//       }
//     }
//     // Refresh the UI
//     notifyListeners();
//   }
// }

class AuditorPageWidget extends StatefulWidget {
  const AuditorPageWidget({Key? key}) : super(key: key);

  @override
  _AuditorPageWidgetState createState() => _AuditorPageWidgetState();
}

class _AuditorPageWidgetState extends State<AuditorPageWidget>
    with TickerProviderStateMixin {
  // String _searchKeyword = '';
  int tabIndex = 0;
  final _searchKeywordController = TextEditingController();

  // _changeField() {
  //   setState(() =>_searchKeyword = _searchKeywordController.text);
  // }

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 1,
      delay: 1,
      hideBeforeAnimating: false,
      fadeIn: false,
      // changed to false(orig from FLOW true)
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
    // _searchKeywordController.text = '';
    // _searchKeywordController.addListener(() {_changeField();});
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    bool _isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      if(tabIndex == 0) {
        tasksServices.resetFilter(tasksServices.tasksNew);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(tasksServices.tasksWithMyParticipation);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(tasksServices.tasksDonePerformer);
      }
    }
    if (tasksServices.ownAddress != null && tasksServices.validChainID) {
      _isFloatButtonVisible = true;
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
                  'Auditor',
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
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      // floatingActionButton: _isFloatButtonVisible
      //     ? FloatingActionButton(
      //         onPressed: () async {
      //           await Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CreateJobWidget(),
      //             ),
      //           );
      //         },
      //         backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
      //         elevation: 8,
      //         child: Icon(
      //           Icons.add,
      //           color: Color(0xFFFCFCFC),
      //           size: 28,
      //         ),
      //       )
      //     : null,
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
                length: 4,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.white,
                      labelStyle: FlutterFlowTheme.of(context).bodyText1,
                      indicatorColor: const Color(0xFF47CBE4),
                      indicatorWeight: 3,
                      onTap: (index) {
                        _searchKeywordController.clear();
                        tabIndex = index;
                        if(index == 0) {
                          tasksServices.resetFilter(tasksServices.tasksNew);
                        } else if (index == 1) {
                          tasksServices.resetFilter(tasksServices.tasksWithMyParticipation);
                        } else if (index == 2) {
                          tasksServices.resetFilter(tasksServices.tasksDonePerformer);
                        } else if (index == 3) {
                          tasksServices.resetFilter(tasksServices.tasksDonePerformer);
                        }
                      },
                      tabs: const [
                        Tab(
                          text: 'Pending',
                        ),
                        Tab(
                          text: 'Applied for',
                        ),
                        Tab(
                          text: 'Working on',
                        ),
                        Tab(
                          text: 'Done',
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
                          if(tabIndex == 0) {
                            tasksServices.runFilter(searchKeyword, tasksServices.tasksNew);
                          } else if (tabIndex == 1) {
                            tasksServices.runFilter(searchKeyword, tasksServices.tasksWithMyParticipation);
                          } else if (tabIndex == 2) {
                            tasksServices.runFilter(searchKeyword, tasksServices.tasksDonePerformer);
                          } else if (tabIndex == 3) {
                            tasksServices.runFilter(searchKeyword, tasksServices.tasksDonePerformer);
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
                                PendingTabWidget(tabName: 'pending'),
                                PendingTabWidget(tabName: 'applied'),
                                PendingTabWidget(tabName: 'working'),
                                PendingTabWidget(tabName: 'done'),
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

class PendingTabWidget extends StatefulWidget {
  final String tabName;

  const PendingTabWidget({
    Key? key,
    required this.tabName,
  }) : super(key: key);

  @override
  _PendingTabWidgetState createState() => _PendingTabWidgetState();
}

class _PendingTabWidgetState extends State<PendingTabWidget> {
  late bool justLoaded = true;
  late List<Task> obj;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    obj = tasksServices.filterResults;
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
          itemCount: obj.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: InkWell(
                onTap: () {
                setState(() {
                  // Toggle light when tapped.
                });
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:
                        Text(obj[index].title),
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
                                const TextSpan(
                                    text: 'Description: \n',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: obj[index].description)
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
                                        '${obj[index].contractValue} ETH\n',
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.0)),
                                TextSpan(
                                    text:
                                        '${obj[index].contractValueToken} aUSDC',
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.0))
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
                                    text: obj[index].contractOwner.toString(),
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 0.7))
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
                                    text: obj[index].contractAddress.toString(),
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 0.7))
                              ])),
                          RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(fontSizeFactor: 1.0),
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Performer address: \n',
                                        style: TextStyle(
                                            height: 2,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                        text: obj[index].contractAddress.toString(),
                                        style: DefaultTextStyle.of(context)
                                            .style
                                            .apply(fontSizeFactor: 0.7))
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
                                  text:
                                      DateFormat('MM/dd/yyyy, hh:mm a')
                                          .format(obj[index].createdTime),
                                )
                              ])),
                        ],
                      ),
                    ),
                    actions: [
                      if(widget.tabName == 'pending')
                      TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green),
                          onPressed: () {
                            setState(() {
                              obj[index]
                                  .justLoaded = false;
                            });
                            tasksServices.taskParticipation(
                                obj[index]
                                    .contractAddress,
                                obj[index].nanoId);
                            Navigator.pop(context);

                            showDialog(
                                context: context,
                                builder: (context) => WalletAction(
                                      nanoId: obj[index].nanoId,
                                      taskName: 'taskParticipation',
                                    ));
                          },

                          child: const Text('Apply for audit')),
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
                    color: Colors.white,
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      // obj[index].title.length > 20 ? obj[index].title.substring(0, 20)+'...' : obj[index].title,
                                      obj[index].title,
                                      style: FlutterFlowTheme.of(context)
                                          .subtitle1,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    ),
                                  ),

                                  // Spacer(),
                                  // Text(
                                  //   'Value: ' +
                                  //       obj[index].contractValue.toString()
                                  //   + ' Eth',
                                  //   style: FlutterFlowTheme.of(
                                  //       context)
                                  //       .bodyText2,
                                  // ),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  obj[index].description,
                                  style: FlutterFlowTheme.of(context).bodyText2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      DateFormat('MM/dd/yyyy, hh:mm a').format(
                                          obj[index]
                                              .createdTime),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    ),
                                  ),
                                  if (obj[index].contractValue != 0)
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${obj[index].contractValue} ETH',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  if (obj[index]
                                          .contractValueToken !=
                                      0)
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        '${obj[index].contractValueToken} aUSDC',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyText2,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  if (obj[index]
                                              .contractValue == 0 &&
                                      obj[index]
                                              .contractValueToken == 0)
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
                      if (obj[index].contributorsCount != 0 &&
                      widget.tabName == 'pending')
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 18, 0),
                          child: Badge(
                            // position: BadgePosition.topEnd(top: 10, end: 10),
                            badgeContent: Container(
                              width: 17,
                              height: 17,
                              alignment: Alignment.center,
                              child: Text(
                                  obj[index].contributorsCount.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            badgeColor: Colors.green,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.scale,
                            shape: BadgeShape.circle,
                            borderRadius: BorderRadius.circular(5),
                            // child: Icon(Icons.settings),
                          ),
                        ),
                      if (obj[index].justLoaded ==
                          false)
                        const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
