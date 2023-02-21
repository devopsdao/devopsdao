import 'dart:collection';

import 'package:devopsdao/widgets/tags/search_services.dart';
import 'package:devopsdao/widgets/tags/tags_old.dart';
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
    var searchServices = context.read<SearchServices>();
    // var tasksServices = context.read<TasksServices>();
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

    for (var prop1 in searchServices.tagsFilterResults.values) {
      searchServices.tagsFilterResults[prop1.tag]!.selected = false;
      for (var prop2 in tagsLocalList.values) {
        if (prop1.tag == prop2.tag) {
          searchServices.tagsFilterResults[prop1.tag]!.selected = true;
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
                    child: Consumer<SearchServices>(
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
                    child: Consumer<SearchServices>(
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
                searchServices.tagsFilterResults.entries.map((e) {
                  if(e.value.selected) {
                    map[e.value.tag] = e.value;
                  }
                }).toList();
                searchServices.updateTagList(map, page: widget.page);
                // searchServices.ready = true;
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}