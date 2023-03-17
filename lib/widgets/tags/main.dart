import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:dodao/widgets/tags/widgets/fab_button.dart';
import 'package:flutter/material.dart';

import '../../account_dialog/widget/dialog_button_widget.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../pages/performer_page.dart';
import '../my_tools.dart';
import 'wrapped_chip.dart';
import 'package:flutter/services.dart';

class MainTagsPage extends StatefulWidget {
  final String page;
  final int tabIndex;

  final PerformerPageWidget? performerPageWidget;

  const MainTagsPage({Key? key, required this.page, required this.tabIndex, this.performerPageWidget}) : super(key: key);


  @override
  _MainTagsPageState createState() => _MainTagsPageState();
}

class _MainTagsPageState extends State<MainTagsPage> {

  late Map<String, SimpleTags> tagsLocalList;
  final _searchKeywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true);
      // searchServices.tagsSearchFilter('', simpleTagsMap);
      if (widget.page == 'audit') {
        tagsLocalList = searchServices.auditorTagsList;
      } else if (widget.page == 'tasks') {
        tagsLocalList = searchServices.tasksTagsList;
      } else if (widget.page == 'customer') {
        tagsLocalList = searchServices.customerTagsList;
      } else if (widget.page == 'performer') {
        tagsLocalList = searchServices.performerTagsList;
      } else if (widget.page == 'create') {
        tagsLocalList = searchServices.createTagsList;
      } else {
        tagsLocalList = {};
      }

      for (var prop1 in searchServices.tagsFilterResults.values) {
        searchServices.tagsFilterResults[prop1.tag]!.selected = false;
        for (var prop2 in tagsLocalList.values) {
          if (prop1.tag == prop2.tag) {
            searchServices.tagsFilterResults[prop1.tag]!.selected = true;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    var searchServices = context.read<SearchServices>();
    var tasksServices = context.read<TasksServices>();

    late Map<String, TagsCompare> tagsCompare = {};



    // searchServices.tagsFilterResults.forEach((key, value) {
    //   searchServices.tagsFilterResults[key]!.selected = false;
    // });
    // searchServices.tagsFilterResults.forEach((key, value) {
    //   tagsLocalList.forEach((key2, value2) {
    //     if (key == key2) {
    //       searchServices.tagsFilterResults[key]!.selected = true;
    //     } else {
    //       false
    //     }
    //   });
    // });

    // searchServices.resetTagsFilter(simpleTagsMap);


    // tagsLocalList.entries.where((element) {
    //   return element.value.selected == true;
    // });


    final double maxStaticDialogWidth = interface.maxStaticDialogWidth;
    const double myPadding = 8.0;

    final Widget body = LayoutBuilder(
        builder: (context, constraints) {
          final double myHeight = constraints.maxHeight - (myPadding * 2);
          final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
          final double maxHeight = myHeight - statusBarHeight - 100;

          return Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(myPadding),
              width: maxStaticDialogWidth,
              child: Column(
                children: [
                  Container(
                    height: statusBarHeight,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      const Spacer(),
                      Expanded(
                          flex: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RichText(
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Add tags',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true);
                          searchServices.forbidSearchKeywordClear = true;
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          height: 30,
                          width: 30,
                          child: Row(
                            children: const <Widget>[
                              Expanded(
                                child: Icon(
                                  Icons.close,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
                    height: 70,
                    child: Consumer<SearchServices>(
                      builder: (context, model, child) {

                        return TextFormField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            model.tagsSearchFilter(searchKeyword, simpleTagsMap);
                          },
                          autofocus: false,
                          obscureText: false,
                          // onTapOutside: (test) {
                          //   FocusScope.of(context).unfocus();
                          //   // interface.taskMessage = messageController!.text;
                          // },

                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.add),
                            suffixIcon: model.newTag ? IconButton(
                              onPressed: () {
                                // NEW TAG
                                simpleTagsMap[_searchKeywordController.text] =
                                    SimpleTags(collection: false, tag: _searchKeywordController.text, icon: "", selected: true);
                                model.tagsAddAndUpdate(simpleTagsMap);
                              },
                              icon: const Icon(Icons.add_box),
                              padding: const EdgeInsets.only(right: 12.0),
                              highlightColor: Colors.grey,
                              hoverColor: Colors.transparent,
                              color: Colors.blueAccent,
                              splashColor: Colors.black,
                            ) : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Colors.blueAccent,
                                width: 1.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Tag name',
                            labelStyle: const TextStyle(
                                fontSize: 17.0, color: Colors.black54),
                            hintText: '[Enter your tag here..]',
                            hintStyle: const TextStyle(
                                fontSize: 14.0, color: Colors.black54),
                            // focusedBorder: const UnderlineInputBorder(
                            //   borderSide: BorderSide.none,
                            // ),

                          ),
                          style: DodaoTheme.of(context).bodyText1.override(
                            fontFamily: 'Inter',
                          ),
                          minLines: 1,
                          maxLines: 1,
                        );
                      }
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: maxHeight - 10,
                    alignment: Alignment.topLeft,
                    child: Builder(
                        builder: (context) {
                        final searchProvider= Provider.of<SearchServices>(context, listen: true);
                        return Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: searchProvider.tagsFilterResults.entries.map((e) {

                              if(!tagsCompare.containsKey(e.value.tag)){
                                if (e.value.selected) {
                                  tagsCompare[e.value.tag] = TagsCompare(state: 'remain',);
                                } else {
                                  tagsCompare[e.value.tag] = TagsCompare(state: 'none',);
                                }
                              } else if (tagsCompare.containsKey(e.value.tag)) {
                                if (e.value.selected) {
                                  if (tagsCompare[e.value.tag]!.state == 'start') {
                                    tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'remain',));
                                  }
                                  if (tagsCompare[e.value.tag]!.state == 'none') {
                                    tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
                                  }
                                  if (tagsCompare[e.value.tag]!.state == 'end') {
                                    tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
                                  }
                                } else {
                                  if (tagsCompare[e.value.tag]!.state == 'end') {
                                    tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'none',));
                                  }
                                  if (tagsCompare[e.value.tag]!.state == 'start') {
                                    tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
                                  }
                                  if (tagsCompare[e.value.tag]!.state == 'remain') {
                                    tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
                                  }
                                }
                              }
                              return WrappedChip(
                                key: ValueKey(e),
                                theme: 'white',
                                item: e.value,
                                page: 'selection',
                                startScale: false,
                                animationCicle: tagsCompare[e.value.tag]!.state,
                                selected: e.value.selected,
                                wrapperRole: WrapperRole.selectNew,
                              );
                            }).toList());
                      }
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );

    return Container(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: interface.maxStaticDialogWidth,
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: body,
          floatingActionButtonAnimator: NoScalingAnimation(),
          floatingActionButton: Padding(
            // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
            padding: const EdgeInsets.only(right: 13, left: 46),
            child: TagsFAB(
              inactive: false,
              expand: false,
              buttonName: 'Apply',
              buttonColorRequired: Colors.lightBlue.shade300,
              widthSize: MediaQuery.of(context).viewInsets.bottom == 0 ? 600 : 120, // Keyboard shown?
              callback: () {
                searchServices.updateTagListOnTasksPages(page: widget.page, initial: false);
                if (widget.page == 'audit') {
                  if (widget.tabIndex == 0) {
                    tasksServices.runFilter(taskList: tasksServices.tasksAuditPending,
                      tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
                  } else if (widget.tabIndex == 1) {
                    tasksServices.runFilter(taskList: tasksServices.tasksAuditApplied,
                      tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
                  } else if (widget.tabIndex == 2) {
                    tasksServices.runFilter(taskList: tasksServices.tasksAuditWorkingOn,
                      tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
                  } else if (widget.tabIndex == 3) {
                    tasksServices.runFilter(taskList: tasksServices.tasksAuditComplete,
                      tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
                  }
                } else if (widget.page == 'tasks') {
                  tasksServices.runFilter(taskList: tasksServices.tasksNew, tagsMap: searchServices.tasksTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                } else if (widget.page == 'customer') {
                  if (widget.tabIndex == 0) {
                    tasksServices.runFilter(taskList:tasksServices.tasksCustomerSelection,
                        tagsMap: searchServices.customerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                  } else if (widget.tabIndex == 1) {
                    tasksServices.runFilter(taskList:tasksServices.tasksCustomerProgress,
                        tagsMap: searchServices.customerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                  } else if (widget.tabIndex == 2) {
                    tasksServices.runFilter(taskList:tasksServices.tasksCustomerComplete,
                        tagsMap: searchServices.customerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                  }
                } else if (widget.page == 'performer') {
                  if (widget.tabIndex == 0) {
                    tasksServices.runFilter(taskList: tasksServices.tasksPerformerParticipate,
                        tagsMap: searchServices.performerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                  } else if (widget.tabIndex == 1) {
                    tasksServices.runFilter(taskList: tasksServices.tasksPerformerProgress,
                        tagsMap: searchServices.performerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                  } else if (widget.tabIndex == 2) {
                    tasksServices.runFilter(taskList: tasksServices.tasksPerformerComplete,
                        tagsMap: searchServices.performerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
                  }
                }
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}