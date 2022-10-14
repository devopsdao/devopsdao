import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../create_job/create_job_widget.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/wallet_action.dart';
import 'task.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

import 'package:beamer/beamer.dart';

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

class JobExchangeWidget extends StatefulWidget {
  final int? index;
  const JobExchangeWidget({Key? key, this.index}) : super(key: key);

  @override
  _JobExchangeWidgetState createState() => _JobExchangeWidgetState();
}

class _JobExchangeWidgetState extends State<JobExchangeWidget>
    with TickerProviderStateMixin {
  // String _searchKeyword = '';
  final _searchKeywordController = TextEditingController();
  // _changeField() {
  //   setState(() =>_searchKeyword = _searchKeywordController.text);
  // }

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
    // _searchKeywordController.text = '';
    // _searchKeywordController.addListener(() {_changeField();});
    if (widget.index != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) => TaskDialog(index: widget.index!));
      });
    }

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
    bool isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter();
    }
    if (tasksServices.ownAddress != null && tasksServices.validChainID) {
      isFloatButtonVisible = true;
    }

    // if (widget.index != null) {
    //   showDialog(
    //       context: context,
    //       builder: (context) => TaskDialog(index: widget.index!));
    // }

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
      floatingActionButton: isFloatButtonVisible
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateJobWidget(),
                  ),
                );
              },
              backgroundColor: FlutterFlowTheme.of(context).maximumBlueGreen,
              elevation: 8,
              child: const Icon(
                Icons.add,
                color: Color(0xFFFCFCFC),
                size: 28,
              ),
            )
          : null,
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
                length: 1,
                initialIndex: 0,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      decoration: const BoxDecoration(
                          // color: Colors.white70,
                          // borderRadius: BorderRadius.circular(8),
                          ),
                      child: TextField(
                        controller: _searchKeywordController,
                        onChanged: (searchKeyword) {
                          tasksServices.runFilter(searchKeyword);
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
                    // TabBar(
                    //   labelColor: Colors.white,с
                    //   labelStyle: FlutterFlowTheme.of(context).bodyText1,
                    //   indicatorColor: Color(0xFF47CBE4),
                    //   indicatorWeight: 3,
                    //   tabs: [
                    //     Tab(
                    //       text: 'New offers',
                    //     ),
                    //     // Tab(
                    //     //   text: 'Reserved tab',
                    //     // ),
                    //     // Tab(
                    //     //   text: 'Reserved tab',
                    //     // ),
                    //   ],
                    // ),

                    tasksServices.isLoading
                        ? const LoadIndicator()
                        : Expanded(
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 6, 0, 0),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      tasksServices.isLoadingBackground = true;
                                      tasksServices.fetchTasks();
                                    },
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: tasksServices
                                          .filterResults.values
                                          .toList()
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(16, 8, 16, 0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                // Toggle light when tapped.
                                              });
                                              context
                                                  .beamToNamed('/tasks/$index');
                                              // showDialog(
                                              //     context: context,
                                              //     builder: (context) =>
                                              //         TaskDialog(index: index));
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              12, 8, 8, 8),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  // tasksServices.filterResults[index].title.length > 20 ? tasksServices.filterResults[index].title.substring(0, 20)+'...' : tasksServices.filterResults[index].title,
                                                                  tasksServices
                                                                      .filterResults
                                                                      .values
                                                                      .toList()[
                                                                          index]
                                                                      .title,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .subtitle1,
                                                                  softWrap:
                                                                      false,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  maxLines: 1,
                                                                ),
                                                              ),

                                                              // Spacer(),
                                                              // Text(
                                                              //   'Value: ' +
                                                              //       tasksServices.filterResults[index].contractValue.toString()
                                                              //   + ' Eth',
                                                              //   style: FlutterFlowTheme.of(
                                                              //       context)
                                                              //       .bodyText2,
                                                              // ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              tasksServices
                                                                  .filterResults
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .description,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyText2,
                                                              softWrap: false,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 7,
                                                                child: Text(
                                                                  DateFormat('MM/dd/yyyy, hh:mm a').format(tasksServices
                                                                      .filterResults
                                                                      .values
                                                                      .toList()[
                                                                          index]
                                                                      .createdTime),
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyText2,
                                                                  softWrap:
                                                                      false,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              // Spacer(),
                                                              // Expanded(
                                                              //   flex: 3,
                                                              //   child: Text(
                                                              //     tasksServices.filterResults[
                                                              //                 index]
                                                              //             .contractValue
                                                              //             .toString() +
                                                              //         ' Eth',
                                                              //     style: FlutterFlowTheme.of(
                                                              //             context)
                                                              //         .bodyText2,
                                                              //     softWrap:
                                                              //         false,
                                                              //     overflow:
                                                              //         TextOverflow
                                                              //             .fade,
                                                              //     maxLines: 1,
                                                              //     textAlign:
                                                              //         TextAlign
                                                              //             .end,
                                                              //   ),
                                                              // ),
                                                              if (tasksServices
                                                                      .filterResults
                                                                      .values
                                                                      .toList()[
                                                                          index]
                                                                      .contractValue !=
                                                                  0)
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    '${tasksServices.filterResults.values.toList()[index].contractValue} ETH',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText2,
                                                                    softWrap:
                                                                        false,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                ),
                                                              if (tasksServices
                                                                      .filterResults
                                                                      .values
                                                                      .toList()[
                                                                          index]
                                                                      .contractValueToken !=
                                                                  0)
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    '${tasksServices.filterResults.values.toList()[index].contractValueToken} aUSDC',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText2,
                                                                    softWrap:
                                                                        false,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                ),
                                                              if (tasksServices
                                                                          .filterResults
                                                                          .values
                                                                          .toList()[
                                                                              index]
                                                                          .contractValue ==
                                                                      0 &&
                                                                  tasksServices
                                                                          .filterResults
                                                                          .values
                                                                          .toList()[
                                                                              index]
                                                                          .contractValueToken ==
                                                                      0)
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    'Has no money',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyText2,
                                                                    softWrap:
                                                                        false,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (tasksServices
                                                          .filterResults.values
                                                          .toList()[index]
                                                          .contributorsCount !=
                                                      0)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 18, 0),
                                                      child: Badge(
                                                        // position: BadgePosition.topEnd(top: 10, end: 10),
                                                        badgeContent: Container(
                                                          width: 17,
                                                          height: 17,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              tasksServices
                                                                  .filterResults
                                                                  .values
                                                                  .toList()[
                                                                      index]
                                                                  .contributorsCount
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                        animationDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                        animationType:
                                                            BadgeAnimationType
                                                                .scale,
                                                        shape:
                                                            BadgeShape.circle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        // child: Icon(Icons.settings),
                                                      ),
                                                    ),
                                                  if (tasksServices
                                                          .filterResults.values
                                                          .toList()[index]
                                                          .justLoaded ==
                                                      false)
                                                    const Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 12, 0),
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
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
