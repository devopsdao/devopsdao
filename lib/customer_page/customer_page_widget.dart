import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../custom_widgets/badgetab.dart';
import '../custom_widgets/buttons.dart';
import '../custom_widgets/task_dialog.dart';
import '../custom_widgets/loading.dart';
import '../custom_widgets/task_item.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import 'package:beamer/beamer.dart';

import 'package:throttling/throttling.dart';

class CustomerPageWidget extends StatefulWidget {
  // static final beamLocation = BeamPage(key: ValueKey('Home'), child: CustomerPageWidget());
  // static final path = '/';
  final String? taskAddress;
  const CustomerPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _CustomerPageWidgetState createState() => _CustomerPageWidgetState();
}

class _CustomerPageWidgetState extends State<CustomerPageWidget>
// with TickerProviderStateMixin
{
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
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) => TaskDialog(
                  taskAddress: widget.taskAddress!,
                  fromPage: 'customer',
                ));
      });
    }
  }

  final _searchKeywordController = TextEditingController();

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  int tabIndex = 0;
  int savedIndex = 999;
  bool firstLoad = true;
  double prevMetrics = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    Map tabs = {"new": 0, "agreed": 1, "progress": 1, "review": 1, "audit": 1, "completed": 2, "canceled": 2};

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      if (task != null) {
        tabIndex = tabs[task.taskState];
      }
    }
    if (firstLoad) {
      tasksServices.resetFilter(tasksServices.tasksCustomerSelection);
      firstLoad = false;
    }
    void changeTab(index, metrics) {
      if (tabIndex != index) {
        if (index == 0) {
          tasksServices.resetFilter(tasksServices.tasksCustomerSelection);
        } else if (index == 1) {
          tasksServices.resetFilter(tasksServices.tasksCustomerProgress);
        } else if (index == 2) {
          tasksServices.resetFilter(tasksServices.tasksCustomerComplete);
        }
        tabIndex = index;
        prevMetrics = metrics;
        print('saved index changed to: $index');
      }
    }

    if (_searchKeywordController.text.isEmpty) {
      changeTab(tabIndex, 0); //temp disable
      // if (tabIndex == 0) {
      //   tasksServices.resetFilter(tasksServices.tasksCustomerSelection);
      // } else if (tabIndex == 1) {
      //   tasksServices.resetFilter(tasksServices.tasksCustomerProgress);
      // } else if (tabIndex == 2) {
      //   tasksServices.resetFilter(tasksServices.tasksCustomerComplete);
      // }
    }
    late Throttling debounceChangeTab0 = Throttling(duration: const Duration(milliseconds: 2000));
    late Throttling debounceChangeTab1 = Throttling(duration: const Duration(milliseconds: 2000));
    late Throttling debounceChangeTab2 = Throttling(duration: const Duration(milliseconds: 2000));
    late Throttling debounceChangeTab3 = Throttling(duration: const Duration(milliseconds: 2000));

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
            SearchButton(),
            LoadButtonIndicator(),
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
              colors: [Colors.black, Colors.black, Colors.black],
              stops: [0, 0.5, 1],
              begin: AlignmentDirectional(1, -1),
              end: AlignmentDirectional(-1, 1),
            ),
            // image: DecorationImage(
            //   image: AssetImage("assets/images/background.png"),
            //   // fit: BoxFit.cover,
            //   repeat: ImageRepeat.repeat,
            // ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: DefaultTabController(
                    length: 3,
                    initialIndex: tabIndex,
                    child: Builder(builder: (BuildContext context) {
                      final TabController controller = DefaultTabController.of(context)!;
                      controller.addListener(() {
                        // print(controller.index);
                        // changeTab(controller.index);
                        if (!controller.indexIsChanging) {
                          // print(controller.index);
                        }
                      });
                      return Column(
                        children: [
                          TabBar(
                            labelColor: Colors.white,
                            labelStyle: FlutterFlowTheme.of(context).bodyText1,
                            indicatorColor: const Color(0xFF47CBE4),
                            indicatorWeight: 3,
                            // isScrollable: true,
                            onTap: (index) {
                              _searchKeywordController.clear();
                              tabIndex = index;
                              // print(index);
                              // changeTab(index); //temp disable
                              // if (index == 0) {
                              //   tasksServices.resetFilter(
                              //       tasksServices.tasksCustomerSelection);
                              // } else if (index == 1) {
                              //   tasksServices.resetFilter(
                              //       tasksServices.tasksCustomerProgress);
                              // } else if (index == 2) {
                              //   tasksServices.resetFilter(
                              //       tasksServices.tasksCustomerComplete);
                              // }
                            },
                            tabs: [
                              Tab(
                                child: BadgeTab(
                                  taskCount: tasksServices.tasksCustomerSelection.length,
                                  tabText: 'Selection',
                                ),
                              ),
                              Tab(
                                child: BadgeTab(taskCount: tasksServices.tasksCustomerProgress.length, tabText: 'Progress'),
                              ),
                              Tab(
                                child: BadgeTab(taskCount: tasksServices.tasksCustomerComplete.length, tabText: 'Complete'),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                            // decoration: const BoxDecoration(
                            //   // color: Colors.white70,
                            //   // borderRadius: BorderRadius.circular(8),
                            // ),
                            child: TextField(
                              controller: _searchKeywordController,
                              onChanged: (searchKeyword) {
                                if (tabIndex == 0) {
                                  tasksServices.runFilter(searchKeyword, tasksServices.tasksCustomerSelection);
                                } else if (tabIndex == 1) {
                                  tasksServices.runFilter(searchKeyword, tasksServices.tasksCustomerProgress);
                                } else if (tabIndex == 2) {
                                  tasksServices.runFilter(searchKeyword, tasksServices.tasksCustomerComplete);
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: '[Find task by Title...]',
                                hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                                labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
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
                              : Expanded(
                                  child: NotificationListener(
                                    onNotification: (scrollNotification) {
                                      // changeTab(tabIndex);
                                      // late int index = 0;
                                      if (scrollNotification is ScrollUpdateNotification) {
                                        late double tabWidth = MediaQuery.of(context).size.width;
                                        late double metrics = scrollNotification.metrics.pixels;
                                        print('metrics: ${metrics}   tabWidth: $tabWidth tabIndex $tabIndex');
                                        setState(() {
                                          if (metrics < tabWidth - (tabWidth / 5) && tabIndex >= 1 && prevMetrics > metrics) {
                                            print('first');
                                            debounceChangeTab0.throttle(() {
                                              changeTab(0, metrics);
                                            });
                                          } else if (((metrics > tabWidth / 5 && tabIndex == 0) && (metrics < tabWidth + (tabWidth / 5))) ||
                                              (metrics > tabWidth &&
                                                  metrics < tabWidth * 2 - (tabWidth / 5) &&
                                                  tabIndex == 2 &&
                                                  prevMetrics < metrics)) {
                                            print('second');
                                            debounceChangeTab1.throttle(() {
                                              changeTab(1, metrics);
                                            });
                                          } else if ((metrics > tabWidth + (tabWidth / 5)) ||
                                              (metrics < tabWidth * 3 - (tabWidth / 5) && tabIndex == 3)) {
                                            print('third');
                                            debounceChangeTab2.throttle(() {
                                              changeTab(2, metrics);
                                            });
                                          } else if ((metrics > tabWidth * 2 + (tabWidth / 5) && tabIndex == 2)) {
                                            print('forth');
                                            debounceChangeTab3.throttle(() {
                                              changeTab(3, metrics);
                                            });
                                          }
                                        });
                                        // print(tabIndex);
                                      }
                                      return false;
                                    },
                                    child: const TabBarView(
                                      children: [
                                        mySubmitterTabWidget(
                                          tabName: 'selection',
                                        ), //new
                                        mySubmitterTabWidget(
                                          tabName: 'progress',
                                        ), //agreed
                                        mySubmitterTabWidget(
                                          tabName: 'complete',
                                        ), //completed & canceled
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      );
                    })),
              ),
            ],
          ),
        )
        // .animated([animationsMap['containerOnPageLoadAnimation']!]),
        );
  }
}

class mySubmitterTabWidget extends StatefulWidget {
  final String tabName;
  const mySubmitterTabWidget({
    Key? key,
    required this.tabName,
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
    List objList = tasksServices.filterResults.values.toList();
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
            itemCount: objList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: InkWell(
                    onTap: () {
                      // setState(() {
                      //   // Toggle light when tapped.
                      // });

                      if (tasksServices.filterResults.values.toList().elementAt(index) != null) {
                        showDialog(
                            context: context,
                            builder: (context) => TaskInformationDialog(fromPage: 'customer', task: objList[index], shimmerEnabled: false));
                        final String taskAddress = tasksServices.filterResults.values.toList()[index].taskAddress.toString();
                        RouteInformation routeInfo = RouteInformation(location: '/customer/$taskAddress');
                        Beamer.of(context).updateRouteInformation(routeInfo);
                        // context.popToNamed('/customer/$taskAddress');
                        // context.beamToNamed('/customer/$taskAddress');
                      }
                    },
                    child: TaskItem(
                      fromPage: 'customer',
                      object: objList[index],
                    )),
              );
            },
          ),
        ));
  }
}
