import 'package:beamer/beamer.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dodao/main.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sidebarx/sidebarx.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../navigation/appbar.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../widgets/badgetab.dart';
import '../widgets/loading/loading.dart';
import '../widgets/paw_indicator_with_tasks_list.dart';
import '../widgets/tags/search_services.dart';
import 'package:flutter/material.dart';
import '../widgets/tags/wrapped_chip.dart';

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
with TickerProviderStateMixin
{
  List<String> localTagsList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final colors = [const Color(0xFFF62BAD), const Color(0xFFF75D21)  , const Color(
      0xFF448AF7)];
  late Color indicatorColor = colors[0];
  late TabController _controller;
  final GlobalKey<CustomRefreshIndicatorState> indicator = GlobalKey<CustomRefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    preload();


    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            // barrierDismissible: false,
            context: context,
            builder: (context) => TaskDialogBeamer(
                  taskAddress: widget.taskAddress,
                  fromPage: 'customer',
                ));


      });
    }

    // init customerTagsList to show tag '+' button:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var searchServices = context.read<SearchServices>();
      searchServices.selectTagListOnTasksPages(page: 'customer', initial: true);
    });
    _controller = TabController(length: 3, vsync: this)
      ..addListener(() {
        setState(() {
          indicatorColor = colors[_controller.index];
        });
      });

    indicatorColor = colors[0];
  }

  RiveFile? _file;
  Future<void> preload() async {
    rootBundle.load('assets/rive_animations/paw.riv').then(
          (data) async {
        // Load the RiveFile from the binary data.
        setState(() {
          _file = RiveFile.import(data);
        });
      },
    );
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
    var modelTheme = context.read<ModelTheme>();


    Map tabs = {"new": 0, "agreed": 1, "progress": 1, "review": 1, "audit": 1, "completed": 2, "canceled": 2};

    late bool desktopWidth = false;
    if (MediaQuery.of(context).size.width > 700) {
      desktopWidth = true;
    }

    if (widget.taskAddress != null) {
      final task = tasksServices.tasks[widget.taskAddress];

      if (task != null) {
        tabIndex = tabs[task.taskState];
      }
    }
    void resetFilters() async {
      if (tabIndex == 0) {
        tasksServices.resetFilter(taskList: tasksServices.tasksCustomerSelection, tagsMap: searchServices.customerTagsList);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(taskList: tasksServices.tasksCustomerProgress, tagsMap: searchServices.customerTagsList);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(taskList: tasksServices.tasksCustomerComplete, tagsMap: searchServices.customerTagsList);
      }
    }

    if (searchServices.searchKeywordController.text.isEmpty) {
      resetFilters();
    }

    return Stack(
      children: [
        Positioned(
            top:95.0,
            width: MediaQuery.of(context).size.width,
            child: const LoadIndicator()),
        if (!desktopWidth)
        Image.asset(
          "assets/images/background_cat_pink.png",
          fit: BoxFit.none,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          filterQuality: FilterQuality.medium,
          alignment: Alignment.center,
          scale: 1.0,
          opacity: modelTheme.isDark ? const AlwaysStoppedAnimation(.5) : const AlwaysStoppedAnimation(1),
        ),
        if (desktopWidth)
          Image.asset(
            "assets/images/background_cat_pink_big.png",
            fit: BoxFit.none,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            filterQuality: FilterQuality.medium,
            alignment: Alignment.center,
            scale: 1.0,
            opacity: modelTheme.isDark ? const AlwaysStoppedAnimation(.5) : const AlwaysStoppedAnimation(1),
          ),
        Scaffold(
            // extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            drawer: SideBar(controller: SidebarXController(selectedIndex: 2, extended: true)),
            appBar: OurAppBar(
              title: 'Customer',
              page: 'customer',
              tabIndex: tabIndex,
            ),
            backgroundColor: Colors.transparent,
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
              // decoration: const BoxDecoration(
              //   // gradient: LinearGradient(
              //   //   colors: [Colors.black, Colors.black, Colors.black],
              //   //   stops: [0, 0.5, 1],
              //   //   begin: AlignmentDirectional(1, -1),
              //   //   end: AlignmentDirectional(-1, 1),
              //   // ),
              //   // image: DecorationImage(
              //   //   image: SvgProvider.Svg('assets/images/background-from-png.svg'),
              //   //   fit: BoxFit.fitHeight,
              //   // ),
              //
              // ),
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
                            SizedBox(
                              height: 30,
                              child: TabBar(
                                controller: _controller,
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: indicatorColor,
                                ),
                                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                      // Use the default focused overlay color
                                      return states.contains(MaterialState.focused) ? null : Colors.transparent;
                                    }
                                ),
                                dividerColor: Colors.transparent,
                                labelColor: Colors.white,
                                labelStyle: Theme.of(context).textTheme.bodyMedium,
                                // indicatorColor: DodaoTheme.of(context).tabIndicator,
                                indicatorWeight: 1,
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
                                      index: 0,
                                    ),
                                  ),
                                  Tab(
                                    child: BadgeTab(
                                      taskCount: tasksServices.tasksCustomerProgress.length,
                                      tabText: 'Progress',
                                      index: 1,
                                    ),
                                  ),
                                  Tab(
                                    child: BadgeTab(
                                      taskCount: tasksServices.tasksCustomerComplete.length,
                                      tabText: 'Completed',
                                      index: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Consumer<SearchServices>(builder: (context, model, child) {
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
                                          item: MapEntry(e.key, NftCollection(selected: false, name: e.value.name, bunch: e.value.bunch)),
                                          page: 'customer',
                                          selected: e.value.selected,
                                          tabIndex: tabIndex,
                                          wrapperRole: e.value.name == '#' ? WrapperRole.hashButton : WrapperRole.onPages,
                                        );
                                      }).toList()),
                                ),
                              );
                            }),
                            Expanded(
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
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _controller,
                                  children: [
                                    PawRefreshAndTasksList(pageName: 'customer', paw: _file,), //new
                                    PawRefreshAndTasksList(pageName: 'customer', paw: _file,), //agreed
                                    PawRefreshAndTasksList(pageName: 'customer', paw: _file,), //completed & canceled
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
            ),
      ],
    );
  }
}