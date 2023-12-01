import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';

import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../create_job/create_job_call_button.dart';
import '../main.dart';
import '../navigation/navmenu.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../widgets/paw_indicator_with_tasks_list.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/wrapped_chip.dart';
import '../widgets/tags/tag_open_container.dart';
import '../widgets/tags_on_page_open_container.dart';
import '/blockchain/task_services.dart';
import '/widgets/loading.dart';
import '/config/flutter_flow_animations.dart';
import '/config/theme.dart';
import 'package:flutter/material.dart';

import 'package:webthree/credentials.dart';

class TasksPageWidget extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const TasksPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _TasksPageWidgetState createState() => _TasksPageWidgetState();
}

class _TasksPageWidgetState extends State<TasksPageWidget> {
  // final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  List<String> localTagsList = [];

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
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => TaskDialogBeamer(taskAddress: widget.taskAddress!, fromPage: 'tasks'));
      });
    }

    // init customerTagsList to show tag '+' button:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var searchServices = context.read<SearchServices>();
      searchServices.selectTagListOnTasksPages(page: 'tasks', initial: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> deleteItems = [];

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var searchServices = context.read<SearchServices>();
    var modelTheme = context.read<ModelTheme>();

    late bool desktopWidth = false;
    if (MediaQuery.of(context).size.width > 700) {
      desktopWidth = true;
    }

    bool isFloatButtonVisible = false;
    if (searchServices.searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter(taskList: tasksServices.tasksNew, tagsMap: searchServices.tasksTagsList);
    }

    if (tasksServices.publicAddress != null && tasksServices.allowedChainId) {
      isFloatButtonVisible = true;
    }

    void deleteItem(String id) async {
      setState(() {
        deleteItems.add(id);
      });
      Future.delayed(const Duration(milliseconds: 350)).whenComplete(() {
        setState(() {
          deleteItems.removeWhere((i) => i == id);
        });
      });
    }

    return Stack(
      children: [
        if (!desktopWidth)
          Image.asset(
            "assets/images/background_cat_orange.png",
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
            "assets/images/background_cat_orange_big.png",
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
          drawer: SideBar(controller: SidebarXController(selectedIndex: 1, extended: true)),
          appBar: AppBarWithSearchSwitch(
            backgroundColor: DodaoTheme.of(context).background,
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            automaticallyImplyLeading: true,
            appBarBuilder: (context) {
              return AppBar(
                title: Text('Job Exchange', style: Theme.of(context).textTheme.titleLarge),
                actions: [
                  const OpenMyAddTags(
                    page: 'tasks',
                    tabIndex: 0,
                  ),
                  InkResponse(
                    radius: DodaoTheme.of(context).inkRadius,
                    containedInkWell: false,
                    onTap: AppBarWithSearchSwitch.of(context)?.startSearch,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Icon(
                        Icons.search,
                        size: 24,
                        color: DodaoTheme.of(context).secondaryText,
                      ),
                    ),
                  ),
                  if (tasksServices.platform == 'web' || tasksServices.platform == 'linux') const LoadButtonIndicator(),
                ],
              );
            },
            keepAppBarColors: false,
            searchInputDecoration: InputDecoration(
                border: InputBorder.none, hintText: 'Search', hintStyle: Theme.of(context).textTheme.titleMedium,
                // suffixIcon: Icon(
                //   Icons.tag,
                //   color: Colors.grey[300],
                //   size: 100,
                // ),

                ),

            onChanged: (searchKeyword) {
              tasksServices.runFilter(taskList: tasksServices.tasksNew, tagsMap: searchServices.tasksTagsList, enteredKeyword: searchKeyword);
            },
            customTextEditingController: searchServices.searchKeywordController,
            // actions: [
            //   // IconButton(
            //   //   onPressed: () {
            //   //     showSearch(
            //   //       context: context,
            //   //       delegate: MainSearchDelegate(),
            //   //     );
            //   //   },
            //   //   icon: const Icon(Icons.search)
            //   // ),
            //   LoadButtonIndicator(),
            // ],
            centerTitle: false,
            elevation: 2,
          ),
          backgroundColor: Colors.transparent,

          floatingActionButton: isFloatButtonVisible ? const CreateCallButton() : null,
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
              width: interface.maxStaticGlobalWidth,
              child: DefaultTabController(
                length: 1,
                initialIndex: 0,
                child: LayoutBuilder(builder: (context, constraints) {
                  // print('max:  ${constraints.maxHeight}');
                  // print('max * : ${constraints.maxHeight * .65}');
                  // print(constraints.minWidth);
                  return Column(
                    children: [
                      Consumer<SearchServices>(builder: (context, model, child) {
                        localTagsList = model.tasksTagsList.entries.map((e) => e.value.name).toList();
                        // tasksServices.runFilter(
                        //     tasksServices.tasksNew,
                        //     enteredKeyword: _searchKeywordController.text,
                        //     tagsList: localTagsList);
                        return Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: model.tasksTagsList.entries.map((e) {
                                  return WrappedChip(
                                    key: ValueKey(e.value),
                                    item: MapEntry(
                                        e.key,
                                        NftCollection(selected: false, name: e.value.name, bunch: e.value.bunch
                                            // {
                                            //   BigInt.from(0) : TokenItem(
                                            //     name: e.value.name,
                                            //     collection: true,
                                            //   )
                                            // },
                                            )),
                                    page: 'tasks',
                                    selected: e.value.selected,
                                    tabIndex: 0,
                                    wrapperRole: e.value.name == '#' ? WrapperRole.hashButton : WrapperRole.onPages,
                                  );
                                }).toList()),
                          ),
                        );
                      }),

                      // TabBar(
                      //   labelColor: Colors.white,с
                      //   labelStyle: Theme.of(context).textTheme.bodyMedium,
                      //   indicatorColor: DodaoTheme.of(context).tabIndicator,
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
                          : const Expanded(
                              child: TabBarView(
                                children: [
                                  PawRefreshAndTasksList(pageName: 'tasks',),
                                  // Padding(
                                  //   padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                  //   child: RefreshIndicator(
                                  //     onRefresh: () async {
                                  //       tasksServices.isLoadingBackground = true;
                                  //       // tasksServices.refreshTasksForAccount(tasksServices.publicAddress!);
                                  //     },
                                  //     child: ListView.builder(
                                  //       padding: EdgeInsets.zero,
                                  //       scrollDirection: Axis.vertical,
                                  //       itemCount: tasksServices.filterResults.values.toList().length,
                                  //       itemBuilder: (context, index) {
                                  //         return Container(
                                  //             padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                                  //
                                  //             child: TaskTransition(
                                  //               fromPage: 'tasks',
                                  //               task: tasksServices.filterResults.values.toList()[index],
                                  //             ));
                                  //       },
                                  //     ),
                                  //   ),
                                  // ),
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
