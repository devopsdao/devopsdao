import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sidebarx/sidebarx.dart';

import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../main.dart';
import '../navigation/appbar.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../widgets/badgetab.dart';
import '../task_dialog/main.dart';
import '../widgets/loading/loading.dart';
import '../widgets/paw_indicator_with_tasks_list.dart';
import '../widgets/tags/main.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/tag_open_container.dart';
import '../task_item/task_item.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';
import '../widgets/tags/wrapped_chip.dart';

import 'package:beamer/beamer.dart';

import 'package:webthree/credentials.dart';

class PerformerPageWidget extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const PerformerPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _PerformerPageWidgetState createState() => _PerformerPageWidgetState();
}

class _PerformerPageWidgetState extends State<PerformerPageWidget> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final colors = [const Color(0xFFF62BAD), const Color(0xFFF75D21)  , const Color(
      0xFF448AF7)];
  late Color indicatorColor = colors[0];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    preload();
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.taskAddress != null) {
          showDialog(
              context: context,
              builder: (context) => TaskDialogBeamer(
                    taskAddress: widget.taskAddress,
                    fromPage: 'performer',
                  ));
        }
      });
    }

    // init customerTagsList to show tag '+' button:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var searchServices = context.read<SearchServices>();
      searchServices.selectTagListOnTasksPages(page: 'performer', initial: true);
    });

    _controller = TabController(length: 3, vsync: this, animationDuration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {
          indicatorColor = colors[_controller.index];
        });
      });
    indicatorColor = colors[0];
  }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  // }
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



  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // var interface = context.read<InterfaceServices>();
    var searchServices = context.read<SearchServices>();
    var modelTheme = context.read<ModelTheme>();

    // AppBarWithSearchSwitch.of(appbarServices.searchBarContext)?.stopSearch();

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
        tasksServices.resetFilter(taskList: tasksServices.tasksPerformerParticipate, tagsMap: searchServices.performerTagsList);
      } else if (tabIndex == 1) {
        tasksServices.resetFilter(taskList: tasksServices.tasksPerformerProgress, tagsMap: searchServices.performerTagsList);
      } else if (tabIndex == 2) {
        tasksServices.resetFilter(taskList: tasksServices.tasksPerformerComplete, tagsMap: searchServices.performerTagsList);
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
            "assets/images/background_cat_blue.png",
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
            "assets/images/background_cat_blue_big.png",
            fit: BoxFit.none,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            filterQuality: FilterQuality.medium,
            alignment: Alignment.center,
            scale: 1.0,
            opacity: modelTheme.isDark ? const AlwaysStoppedAnimation(.5) : const AlwaysStoppedAnimation(1),
          ),
        Scaffold(
          key: scaffoldKey,
          drawer: SideBar(controller: SidebarXController(selectedIndex: 3, extended: true)),
          appBar: OurAppBar(
            title: 'Performer',
            page: 'performer',
            tabIndex: tabIndex,
          ),

          backgroundColor: Colors.transparent,
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
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/background.png"),
            //     fit: BoxFit.cover,
            //     filterQuality: FilterQuality.medium,
            //   ),
            // ),
            child: SizedBox(
              width: InterfaceSettings.maxStaticGlobalWidth,
              child: DefaultTabController(
                length: 3,
                initialIndex: tabIndex,
                child: LayoutBuilder(builder: (context, constraints) {
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
                              // icon: const FaIcon(
                              //   FontAwesomeIcons.smileBeam,
                              // ),
                              child: BadgeTab(
                                taskCount: tasksServices.tasksPerformerParticipate.length,
                                tabText: 'Applied',
                                index: 0,
                              ),
                            ),
                            Tab(
                              // icon: const Icon(
                              //   Icons.card_travel_outlined,
                              // ),
                              child: BadgeTab(
                                taskCount: tasksServices.tasksPerformerProgress.length,
                                tabText: 'Working',
                                index: 1,
                              ),
                            ),
                            Tab(
                              // icon: const Icon(
                              //   Icons.done_outline,
                              // ),
                              child: BadgeTab(
                                taskCount: tasksServices.tasksPerformerComplete.length,
                                tabText: 'Completed',
                                index: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: constraints.minWidth - 70,
                      //       padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                      //       // decoration: const BoxDecoration(
                      //       //   // color: Colors.white70,
                      //       //   // borderRadius: BorderRadius.circular(8),
                      //       // ),
                      //       child: TextField(
                      //         controller: _searchKeywordController,
                      //         onChanged: (searchKeyword) {
                      //           if (tabIndex == 0) {
                      //             tasksServices.runFilter(
                      //                 taskList: tasksServices.tasksPerformerParticipate,
                      //                 enteredKeyword: searchKeyword,
                      //                 tagsMap: searchServices.performerTagsList );
                      //           } else if (tabIndex == 1) {
                      //             tasksServices.runFilter(
                      //                 taskList: tasksServices.tasksPerformerProgress,
                      //                 enteredKeyword: searchKeyword,
                      //                 tagsMap: searchServices.performerTagsList );
                      //           } else if (tabIndex == 2) {
                      //             tasksServices.runFilter(
                      //                 taskList: tasksServices.tasksPerformerComplete,
                      //                 enteredKeyword: searchKeyword,
                      //                 tagsMap: searchServices.performerTagsList );
                      //           }
                      //         },
                      //         decoration: const InputDecoration(
                      //           hintText: '[Find task by Title...]',
                      //           hintStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                      //           labelStyle: TextStyle(fontSize: 17.0, color: Colors.white),
                      //           labelText: 'Search',
                      //           suffixIcon: Icon(
                      //             Icons.search,
                      //             color: Colors.white,
                      //           ),
                      //           enabledBorder: UnderlineInputBorder(
                      //             borderSide: BorderSide(
                      //               color: Colors.white,
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(4.0),
                      //               topRight: Radius.circular(4.0),
                      //             ),
                      //           ),
                      //           focusedBorder: UnderlineInputBorder(
                      //             borderSide: BorderSide(
                      //               color: Colors.white,
                      //               width: 1,
                      //             ),
                      //             borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(4.0),
                      //               topRight: Radius.circular(4.0),
                      //             ),
                      //           ),
                      //         ),
                      //         style: DodaoTheme.of(context).bodyText1.override(
                      //               fontFamily: 'Inter',
                      //               color: Colors.white,
                      //               lineHeight: 2,
                      //             ),
                      //       ),
                      //     ),
                      //     TagOpenContainerButton(
                      //       page: 'performer',
                      //       tabIndex: tabIndex,
                      //     ),
                      //   ],
                      // ),
                      Consumer<SearchServices>(builder: (context, model, child) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 16),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: model.performerTagsList.entries.map((e) {
                                  return WrappedChip(
                                    key: ValueKey(e.value),
                                    item: MapEntry(e.key, NftCollection(selected: false, name: e.value.name, bunch: e.value.bunch)),
                                    page: 'performer',
                                    tabIndex: tabIndex,
                                    selected: e.value.selected,
                                    wrapperRole: e.value.name == '#' ? WrapperRole.hashButton : WrapperRole.onPages,
                                  );
                                }).toList()),
                          ),
                        );
                      }),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _controller,
                          children: [
                            PawRefreshAndTasksList(pageName: 'performer', paw: _file,),
                            PawRefreshAndTasksList(pageName: 'performer', paw: _file,),
                            PawRefreshAndTasksList(pageName: 'performer', paw: _file,),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}