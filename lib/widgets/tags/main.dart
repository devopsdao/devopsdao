import 'dart:collection';

import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:devopsdao/widgets/tags/widgets/fab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../account_dialog/widget/dialog_button_widget.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../flutter_flow/theme.dart';
import '../my_tools.dart';
import 'wrapped_chip.dart';
import 'package:flutter/services.dart';

class MainTagsPage extends StatefulWidget {
  const MainTagsPage({Key? key, required this.page}) : super(key: key);
  final String page;

  @override
  _MainTagsPageState createState() => _MainTagsPageState();
}

class _MainTagsPageState extends State<MainTagsPage> {
  // late List<SimpleTags> selectedTagsListLocal = [];
  // TagsValueController tags = TagsValueController([]);
  late Map<String, SimpleTags> tagsLocalList;
  @override
  void initState() {
    super.initState();

  }
  final _searchKeywordController = TextEditingController();


  @override
  void dispose() {
    _searchKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    var tagsServices = context.read<TagsServices>();
    // var tasksServices = context.read<TasksServices>();
    if (widget.page == 'audit') {
      tagsLocalList = tagsServices.auditorTagsList;
    } else if (widget.page == 'tasks') {
      tagsLocalList = tagsServices.tasksTagsList;
    } else if (widget.page == 'customer') {
      tagsLocalList = tagsServices.customerTagsList;
    } else if (widget.page == 'performer') {
      tagsLocalList = tagsServices.performerTagsList;
    } else if (widget.page == 'create') {
      tagsLocalList = tagsServices.createTagsList;
    } else {
      tagsLocalList = {};
    }


    // tagsServices.tagsFilterResults.forEach((key, value) {
    //   tagsServices.tagsFilterResults[key]!.selected = false;
    // });
    // tagsServices.tagsFilterResults.forEach((key, value) {
    //   tagsLocalList.forEach((key2, value2) {
    //     if (key == key2) {
    //       tagsServices.tagsFilterResults[key]!.selected = true;
    //     } else {
    //       false
    //     }
    //   });
    // });

    for (var prop1 in tagsServices.tagsFilterResults.values) {
      tagsServices.tagsFilterResults[prop1.tag]!.selected = false;
      for (var prop2 in tagsLocalList.values) {
        if (prop1.tag == prop2.tag) {
          tagsServices.tagsFilterResults[prop1.tag]!.selected = true;
        }
      }
    }
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
                    child: Consumer<TagsServices>(
                      builder: (context, model, child) {
                        return TextFormField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            model.tagsFilter(searchKeyword, simpleTagsMap);
                          },
                          autofocus: true,
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
                                    SimpleTags(tag: _searchKeywordController.text, icon: "", selected: true);
                                model.tagsUpdate(simpleTagsMap);
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
                    child: Consumer<TagsServices>(
                      builder: (context, model, child) {
                        return Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: model.tagsFilterResults.entries.map((e) {
                              return WrappedChip(
                                interactive: false,
                                key: ValueKey(e),
                                theme: 'white',
                                item: e.value,
                                delete: false,
                                page: widget.page,
                                animation: false,
                                mint: true,
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
                late Map<String, SimpleTags> map = {};
                tagsServices.tagsFilterResults.entries.map((e) {
                  if(e.value.selected) {
                    map[e.value.tag] = e.value;
                  }
                }).toList();
                tagsServices.updateTagList(map, page: widget.page);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TagsServices extends ChangeNotifier {
  Map<String, SimpleTags> tagsFilterResults = {...simpleTagsMap};


  Map<String, SimpleTags> auditorTagsList = {};
  Map<String, SimpleTags> tasksTagsList = {};
  Map<String, SimpleTags> customerTagsList = {};
  Map<String, SimpleTags> performerTagsList = {};
  Map<String, SimpleTags> createTagsList = {};
  Future updateTagList(list, {required String page}) async {

    if (page == 'auditor') {
      auditorTagsList = list;
    } else if (page == 'tasks') {
      tasksTagsList = list;
    } else if (page == 'customer') {
      customerTagsList = list;
    } else if (page == 'performer') {
      performerTagsList = list;
    } else if (page == 'create') {
      createTagsList = list;
    }
    notifyListeners();
  }
  Future removeTag(tagName, {required String page}) async {
    if (page == 'auditor') {
      auditorTagsList.removeWhere((key, value) => value.tag == tagName);
    } else if (page == 'tasks') {
      tasksTagsList.removeWhere((key, value) => value.tag == tagName);
    } else if (page == 'customer') {
      customerTagsList.removeWhere((key, value) => value.tag == tagName);
    } else if (page == 'performer') {
      performerTagsList.removeWhere((key, value) => value.tag == tagName);
    } else if (page == 'create') {
      createTagsList.removeWhere((key, value) => value.tag == tagName);
    }
    notifyListeners();
  }

  late String searchTagKeyword = '';
  late bool newTag = false;

  Future<void> tagsFilter(String enteredKeyword, Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    searchTagKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      tagsFilterResults = Map.from(
          tagsList
      );
      // tagsFilterResults = Map.fromEntries(
      //     tagsList.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1)
      // );
      newTag = false;
    } else {
      for (String key in tagsList.keys) {
        if (tagsList[key]!.selected) {
          tagsFilterResults[key] = tagsList[key]!;
        }
        if (tagsList[key]!.tag.toLowerCase().contains(enteredKeyword.toLowerCase()) ) {
          tagsFilterResults[key] = tagsList[key]!;
        }
      }
      // show button to add new tag:
      enteredKeyword.length > 2 ? newTag = true : newTag = false;
      // show button to add new tag !break used in loop:
      for (String key in tagsList.keys) {
        if (tagsFilterResults[key]?.tag.toLowerCase() == enteredKeyword.toLowerCase()) {
          newTag = false;
          break;
        }
      }
    }
    tagsFilterResults = Map.fromEntries(
        tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1)
    );
    notifyListeners();
  }

  Future<void> tagsUpdate(Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    for (String key in tagsList.keys) {
      if (tagsList[key]!.selected) {
        tagsFilterResults[key] = tagsList[key]!;
      }
    }
    newTag = false;
    tagsFilterResults = Map.fromEntries(
        tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1)
    );
    notifyListeners();
  }

  Future<void> resetTagsFilter(Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    tagsFilterResults = Map.from(tagsList);
  }
}

