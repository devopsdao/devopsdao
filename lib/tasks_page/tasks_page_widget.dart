import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../create_job/create_job_as_page.dart';
import '../create_job/create_job_call_button.dart';
import '../task_dialog/initial_click_on_task.dart';
import '../task_dialog/main_as_page.dart';
import '../widgets/tags/wrapped_chip.dart';
import '../widgets/tags/tag_call_button.dart';
import '../widgets/tags/tags.dart';
import '/blockchain/task_services.dart';
import '/create_job/create_job_widget.dart';
import '/widgets/loading.dart';
import '../task_dialog/main.dart';
import '/widgets/task_item.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import 'package:beamer/beamer.dart';

import 'package:webthree/credentials.dart';
import 'package:animations/animations.dart';

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

class TasksPageWidget extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const TasksPageWidget({Key? key, this.taskAddress}) : super(key: key);

  @override
  _TasksPageWidgetState createState() => _TasksPageWidgetState();
}

class _TasksPageWidgetState extends State<TasksPageWidget> {
  // String _searchKeyword = '';
  final _searchKeywordController = TextEditingController();
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

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
    if (widget.taskAddress != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => TaskDialog(taskAddress: widget.taskAddress!, fromPage: 'tasks'));
      });
    }
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  List<String> deleteItems = [];

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    bool isFloatButtonVisible = false;
    if (_searchKeywordController.text.isEmpty) {
      tasksServices.resetFilter(tasksServices.tasksNew);
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



    List objList = tasksServices.filterResults.values.toList();


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
          ? const CreateCallButton() : null,

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
          // image: DecorationImage(
          //   image: AssetImage("assets/images/background.png"),
          //   // fit: BoxFit.cover,
          //   repeat: ImageRepeat.repeat,
          // ),
        ),
        child: SizedBox(
          width: interface.maxGlobalWidth,
          child: DefaultTabController(
            length: 1,
            initialIndex: 0,
            child: LayoutBuilder(
                builder: (context, constraints) {
              // print('max:  ${constraints.maxHeight}');
              // print('max * : ${constraints.maxHeight * .65}');
              // print(constraints.minWidth);
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: constraints.minWidth - 70,
                          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                          decoration: const BoxDecoration(
                              // color: Colors.white70,
                              // borderRadius: BorderRadius.circular(8),
                              ),
                          child: TextField(
                            controller: _searchKeywordController,
                            onChanged: (searchKeyword) {
                              tasksServices.runFilter(searchKeyword, tasksServices.tasksNew);
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
                        const TagCallButton(page: 'tasks',),
                      ],
                    ),
                    Consumer<InterfaceServices>(
                      builder: (context, model, child) {
                        return Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: model.tasksTagsList.map((e) {

                            return WrappedChip(

                              key: ValueKey(e),
                              theme: 'black',
                              nft: e.nft ?? false,
                              name: e.tag!,
                              // callback: () {
                              //   model.removeTag(i.tag);
                              // },
                              control: true,
                              page: 'tasks'
                              // onDeleted: () {
                              //   //
                              //   if(!isMarkedForDelete) deleteItem(model.selectedTagsList.indexOf(e).toString() ?? "");
                              // },
                            );


                            // bool isMarkedForDelete = deleteItems.where((i) {
                            //       // print('model: ${model.selectedTagsList.indexOf(e)}');
                            //       // print('i: ${i}');
                            //       return i == model.selectedTagsList.indexOf(e).toString();
                            //
                            //     }).isNotEmpty;
                            // print(isMarkedForDelete); print(deleteItems);
                            // return AnimatedContainer(
                            //   key: ObjectKey(e),
                            //   duration: const Duration(milliseconds: 350),
                            //   width: isMarkedForDelete ? 0 : 100,
                            //   child: AnimatedOpacity(
                            //     duration: const Duration(milliseconds: 350),
                            //     opacity: isMarkedForDelete ? 0 : 1,
                            //     child: Chip(
                            //       label: Text(e.tag!),
                            //       onDeleted: () {
                            //       if(!isMarkedForDelete) deleteItem(model.selectedTagsList.indexOf(e).toString() ?? "");
                            //     },),
                            //
                            //
                            //
                            //   ),
                            // );
                          }).toList());
                      }
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      tasksServices.isLoadingBackground = true;
                                      tasksServices.fetchTasks();
                                    },
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemCount: tasksServices.filterResults.values.toList().length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                                          child:  ClickOnTask(fromPage: 'tasks', index: index,)

                                          // InkWell(
                                          //     onTap: () {
                                          //       // print('tap');
                                          //
                                          //       setState(() {
                                          //         // Toggle light when tapped.
                                          //       });
                                          //       // final taskAddress =
                                          //       //     tasksServices
                                          //       //         .filterResults.values
                                          //       //         .toList()[index]
                                          //       //         .taskAddress;
                                          //       // context.popToNamed(
                                          //       //     '/tasks/$taskAddress');
                                          //       // print(objList);
                                          //       showDialog(
                                          //           context: context,
                                          //           builder: (context) => TaskInformationDialog(
                                          //               fromPage: 'tasks', taskAddress: objList[index].taskAddress, shimmerEnabled: true));
                                          //       final String taskAddress =
                                          //           tasksServices.filterResults.values.toList()[index].taskAddress.toString();
                                          //       RouteInformation routeInfo = RouteInformation(location: '/tasks/$taskAddress');
                                          //       Beamer.of(context).updateRouteInformation(routeInfo);
                                          //       // showDialog(
                                          //       //     context: context,
                                          //       //     builder: (context) =>
                                          //       //         TaskDialog(index: index));
                                          //     },
                                          //     child: TaskItem(
                                          //       fromPage: 'tasks',
                                          //       object: tasksServices.filterResults.values.toList()[index],
                                          //     )),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
