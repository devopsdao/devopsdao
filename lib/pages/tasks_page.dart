import 'package:app_bar_with_search_switch/app_bar_with_search_switch.dart';
import 'package:provider/provider.dart';

import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../create_job/create_job_call_button.dart';
import '../task_dialog/beamer.dart';
import '../task_dialog/task_transition_effect.dart';
import '../widgets/tags/search_services.dart';
import '../widgets/tags/wrapped_chip.dart';
import '../widgets/tags/tag_open_container.dart';
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
      searchServices.updateTagListOnTasksPages(page: 'tasks', initial: true);
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

    bool isFloatButtonVisible = false;
    if (searchServices.searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter(taskList: tasksServices.tasksNew, tagsMap: searchServices.tasksTagsList);
    }

    if (tasksServices.publicAddress != null && tasksServices.validChainID) {
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

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWithSearchSwitch(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        appBarBuilder: (context) {
          return AppBar(
            backgroundColor: Colors.black,
            title: Text(
                'Job Exchange',
              style: DodaoTheme.of(context).title2.override(
                fontFamily: 'Inter',
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            actions: [
              // AppBarSearchButton(),
              IconButton(
                onPressed: AppBarWithSearchSwitch.of(context)?.startSearch,
                icon: const Icon(Icons.search),
              ),
            ],
          );
        },
        searchInputDecoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 18.0, color: Colors.white),
          // suffixIcon: Icon(
          //   Icons.tag,
          //   color: Colors.grey[300],
          // ),

        ),

        onChanged: (searchKeyword) {
          tasksServices.runFilter(
              taskList: tasksServices.tasksNew,
              tagsMap: searchServices.tasksTagsList,
              enteredKeyword: searchKeyword);
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
        //   // LoadButtonIndicator(),
        // ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFF1E2429),
      floatingActionButton: isFloatButtonVisible ? const CreateCallButton() : null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black, Colors.black],
            stops: [0, 0.5, 1],
            begin: AlignmentDirectional(1, -1),
            end: AlignmentDirectional(-1, 1),
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
          ),
        ),
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
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: constraints.minWidth - 70,
                  //       padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  //       decoration: const BoxDecoration(
                  //           // color: Colors.white70,
                  //           // borderRadius: BorderRadius.circular(8),
                  //           ),
                  //       child: TextField(
                  //         controller: _searchKeywordController,
                  //         onChanged: (searchKeyword) {
                  //           tasksServices.runFilter(taskList: tasksServices.tasksNew, enteredKeyword: searchKeyword,
                  //               tagsMap: searchServices.tasksTagsList );
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
                  //     const TagCallButton(
                  //       page: 'tasks',
                  //       tabIndex: 0,
                  //     ),
                  //   ],
                  // ),
                  Consumer<SearchServices>(builder: (context, model, child) {
                    localTagsList = model.tasksTagsList.entries.map((e) => e.value.tag).toList();
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
                                theme: 'black',
                                item: e.value,
                                page: 'tasks',
                                selected: e.value.selected,
                                tabIndex: 0,
                                wrapperRole: e.value.tag == '#' ? WrapperRole.hashButton : WrapperRole.onPages,
                              );
                            }).toList()),
                      ),
                    );
                  }),

                  // TabBar(
                  //   labelColor: Colors.white,с
                  //   labelStyle: DodaoTheme.of(context).bodyText1,
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
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    tasksServices.isLoadingBackground = true;
                                    tasksServices.refreshTasksForAccount(tasksServices.publicAddress!);
                                  },
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    itemCount: tasksServices.filterResults.values.toList().length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                                          child: TaskTransition(
                                            fromPage: 'tasks',
                                            task: tasksServices.filterResults.values.toList()[index],
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
