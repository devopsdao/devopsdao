import 'package:animations/animations.dart';
import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../navigation/appbar.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../widgets/badgetab.dart';
import '../task_dialog/main.dart';
import '../widgets/loading.dart';
import '../widgets/search_filter_route.dart';
import '../widgets/tags/main.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/tag_open_container.dart';
import '../widgets/tags/tags_old.dart';
import '../task_item/task_item.dart';
import '../config/flutter_flow_animations.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';
import '../widgets/tags/wrapped_chip.dart';

import 'package:beamer/beamer.dart';

import 'package:webthree/credentials.dart';


class CustomerPageWidget extends StatefulWidget {
  // static final beamLocation = BeamPage(key: ValueKey('Home'), child: CustomerPageWidget());
  // static final path = '/';
  final EthereumAddress? taskAddress;
  const CustomerPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _CustomerPageWidgetState createState() => _CustomerPageWidgetState();
}

class _CustomerPageWidgetState extends State<CustomerPageWidget>
// with TickerProviderStateMixin
{
  List<String> localTagsList = [];
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
          builder: (context) => TaskDialogBeamer(
            taskAddress: widget.taskAddress,
            fromPage: 'customer',
          )
        );
      });
    }

    // init customerTagsList to show tag '+' button:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var searchServices = context.read<SearchServices>();
      searchServices.updateTagListOnTasksPages(page: 'customer', initial: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.read<InterfaceServices>();
    var searchServices = context.read<SearchServices>();

    Map tabs = {"new": 0, "agreed": 1, "progress": 1, "review": 1, "audit": 1, "completed": 2, "canceled": 2};

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      if (task != null) {
        tabIndex = tabs[task.taskState];
      }
    }
    void resetFilters() async {
      if (tabIndex == 0) {
        tasksServices.resetFilter(taskList:tasksServices.tasksCustomerSelection,
            tagsMap: searchServices.customerTagsList);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(taskList:tasksServices.tasksCustomerProgress,
            tagsMap: searchServices.customerTagsList);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(taskList:tasksServices.tasksCustomerComplete,
            tagsMap: searchServices.customerTagsList);
      }
    }
    if (searchServices.searchKeywordController.text.isEmpty) {
      resetFilters();
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: OurAppBar(
          title: 'Customer',
          tabIndex: tabIndex,
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
        //   backgroundColor: DodaoTheme.of(context).maximumBlueGreen,
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
          // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          alignment: Alignment.center,
          decoration:  const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black, Colors.black],
              stops: [0, 0.5, 1],
              begin: AlignmentDirectional(1, -1),
              end: AlignmentDirectional(-1, 1),
            ),
            // image: DecorationImage(
            //   image: SvgProvider.Svg('assets/images/background-from-png.svg'),
            //   fit: BoxFit.fitHeight,
            // ),
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
          ),
          child: SizedBox(
            width: interface.maxStaticGlobalWidth,
            child: DefaultTabController(
                length: 3,
                initialIndex: tabIndex,
                child: Builder(builder: (BuildContext context) {
                  // final TabController controller = DefaultTabController.of(context)!;
                  // controller.addListener(() {
                  //   // print(controller.index);
                  //   // changeTab(controller.index);
                  //   if (!controller.indexIsChanging) {
                  //     // print(controller.index);
                  //   }
                  // });
                  return LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        TabBar(
                          labelColor: Colors.white,
                          labelStyle: DodaoTheme.of(context).bodyText1,
                          indicatorColor: const Color(0xFF47CBE4),
                          indicatorWeight: 3,
                          // isScrollable: true,
                          onTap: (index) {
                            // AppBarWithSearchSwitch.of(appbarServices.searchBarContext)?.stopSearch();
                            searchServices.searchKeywordController.clear();
                            tabIndex = index;
                            resetFilters();
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
                        // Row(
                        //   children: [
                        //     Container(
                        //       width: constraints.minWidth - 70,
                        //       padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                        //
                        //       // child: TextField(
                        //       //   controller: _searchKeywordController,
                        //       //   onChanged: (searchKeyword) {
                        //       //     if (tabIndex == 0) {
                        //       //       tasksServices.runFilter(
                        //       //           taskList: tasksServices.tasksCustomerSelection,
                        //       //           enteredKeyword: searchKeyword,
                        //       //           tagsMap: searchServices.customerTagsList );
                        //       //     } else if (tabIndex == 1) {
                        //       //       tasksServices.runFilter(
                        //       //           taskList: tasksServices.tasksCustomerProgress,
                        //       //           enteredKeyword: searchKeyword,
                        //       //           tagsMap: searchServices.customerTagsList );
                        //       //     } else if (tabIndex == 2) {
                        //       //       tasksServices.runFilter(
                        //       //           taskList: tasksServices.tasksCustomerComplete,
                        //       //           enteredKeyword: searchKeyword,
                        //       //           tagsMap: searchServices.customerTagsList );
                        //       //     }
                        //       //   },
                        //       //   decoration: const InputDecoration(
                        //       //     hintText: '[Find task by Title...]',
                        //       //     hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                        //       //     labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
                        //       //     labelText: 'Search',
                        //       //     suffixIcon: Icon(
                        //       //       Icons.search,
                        //       //       color: Colors.white,
                        //       //     ),
                        //       //     enabledBorder: UnderlineInputBorder(
                        //       //       borderSide: BorderSide(
                        //       //         color: Colors.white,
                        //       //         width: 1,
                        //       //       ),
                        //       //       borderRadius: BorderRadius.only(
                        //       //         topLeft: Radius.circular(4.0),
                        //       //         topRight: Radius.circular(4.0),
                        //       //       ),
                        //       //     ),
                        //       //     focusedBorder: UnderlineInputBorder(
                        //       //       borderSide: BorderSide(
                        //       //         color: Colors.white,
                        //       //         width: 1,
                        //       //       ),
                        //       //       borderRadius: BorderRadius.only(
                        //       //         topLeft: Radius.circular(4.0),
                        //       //         topRight: Radius.circular(4.0),
                        //       //       ),
                        //       //     ),
                        //       //   ),
                        //       //   style: DodaoTheme.of(context).bodyText1.override(
                        //       //         fontFamily: 'Inter',
                        //       //         color: Colors.white,
                        //       //         lineHeight: 2,
                        //       //       ),
                        //       // ),
                        //     ),
                        //
                        //   ],
                        // ),
                        Consumer<SearchServices>(builder: (context, model, child) {
                          // localTagsList = model.customerTagsList.entries.map((e) => e.value.tag).toList();
                          // if (model.ready) {
                          //   tasksServices.runFilter(
                          //     tasksServices.tasksNew,
                          //     enteredKeyword: _searchKeywordController.text,
                          //     tagsList: localTagsList
                          //   );
                          //   model.ready = false;
                          // }

                          return Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Wrap(
                                  // alignment: WrapAlignment.start,
                                  direction: Axis.horizontal,
                                  children: model.customerTagsList.entries.map((e) {
                                    return WrappedChip(
                                      key: ValueKey(e.value),
                                      theme: 'black',
                                      item: e.value,
                                      page: 'customer',
                                      selected: e.value.selected,
                                      tabIndex: tabIndex,
                                      wrapperRole: e.value.tag == '#' ? WrapperRole.hash : WrapperRole.onPages,
                                    );
                                  }).toList()),
                            ),
                          );
                        }),
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
                                      // print('metrics: ${metrics}   tabWidth: $tabWidth tabIndex $tabIndex');
                                      // setState(() {
                                      //   if (metrics < tabWidth - (tabWidth / 5) && tabIndex >= 1 && prevMetrics > metrics) {
                                      //     print('first');
                                      //     debounceChangeTab0.throttle(() {
                                      //       changeTab(0, metrics);
                                      //     });
                                      //   } else if (((metrics > tabWidth / 5 && tabIndex == 0) &&
                                      //           (metrics < tabWidth + (tabWidth / 5)) &&
                                      //           prevMetrics < metrics) ||
                                      //       (metrics > tabWidth &&
                                      //           metrics < tabWidth * 2 - (tabWidth / 5) &&
                                      //           tabIndex == 2 &&
                                      //           prevMetrics > metrics)) {
                                      //     print('second');
                                      //     debounceChangeTab1.throttle(() {
                                      //       changeTab(1, metrics);
                                      //     });
                                      //   } else if ((metrics > tabWidth + (tabWidth / 5)) ||
                                      //       (metrics < tabWidth * 3 - (tabWidth / 5) && tabIndex == 3 && prevMetrics < metrics)) {
                                      //     print('third');
                                      //     debounceChangeTab2.throttle(() {
                                      //       changeTab(2, metrics);
                                      //     });
                                      //   } else if ((metrics > tabWidth * 2 + (tabWidth / 5) && tabIndex == 2)) {
                                      //     print('forth');
                                      //     debounceChangeTab3.throttle(() {
                                      //       changeTab(3, metrics);
                                      //     });
                                      //   }
                                      // });
                                      // print(tabIndex);
                                    }
                                    return false;
                                  },
                                  child: const TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
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
                  });
                })),
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
    // List objList = tasksServices.filterResults.values.toList();
    // TODO: implement build
    return

        // Selector<InterfaceServices, int>(
        //   selector: (_, model) {
        //     return model.dialogPageNum;
        //   },
        //   builder: (context, dialogPageNum, child) {
        //     late String page = interface.dialogCurrentState['pages'].entries
        //         .firstWhere((element) => element.value == dialogPageNum)
        //         .key;
        //     return Row(
        //       children: <Widget>[
        //         if (page == 'topup')
        //           const Expanded(
        //             child: Icon(
        //               Icons.arrow_forward,
        //               size: 30,
        //             ),
        //           ),
        //         if (page.toString() == 'main')
        //           const Expanded(
        //             child: Center(),
        //           ),
        //         if (page == 'description' || page == 'widgets.chat' || page == 'select')
        //           const Expanded(
        //             child: Icon(
        //               Icons.arrow_back,
        //               size: 30,
        //             ),
        //           ),
        //       ],
        //     );
        //   },
        // ),

        Selector<TasksServices, Map<EthereumAddress, Task>>(
            selector: (_, model) => model.filterResults,
            builder: (_, filter, __) {
              List objList = filter.values.toList();
              return Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      tasksServices.isLoadingBackground = true;
                      tasksServices.fetchTasksCustomer(tasksServices.publicAddress!);
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: objList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                            child: TaskTransition(
                              fromPage: 'customer',
                              task: tasksServices.filterResults.values.toList()[index],
                            )

                            // InkWell(
                            //     onTap: () {
                            //       // setState(() {
                            //       //   // Toggle light when tapped.
                            //       // });
                            //
                            //       if (tasksServices.filterResults.values.toList().elementAt(index) != null) {
                            //         showDialog(
                            //             context: context,
                            //             builder: (context) =>
                            //                 TaskInformationDialog(fromPage: 'customer', taskAddress: objList[index].taskAddress, shimmerEnabled: false));
                            //         final String taskAddress = tasksServices.filterResults.values.toList()[index].taskAddress;
                            //         RouteInformation routeInfo = RouteInformation(location: '/customer/$taskAddress');
                            //         Beamer.of(context).updateRouteInformation(routeInfo);
                            //         // context.popToNamed('/customer/$taskAddress');
                            //         // context.beamToNamed('/customer/$taskAddress');
                            //       }
                            //     },
                            //     child: TaskItem(
                            //       fromPage: 'customer',
                            //       object: objList[index],
                            //     )),
                            );
                      },
                    ),
                  ));
            });
  }
}
