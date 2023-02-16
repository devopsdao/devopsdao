import 'dart:collection';

import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../flutter_flow/theme.dart';
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
  late List<SimpleTags> selectedListData;
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    var tagsServices = context.watch<TagsServices>();
    // var tasksServices = context.read<TasksServices>();
    if (widget.page == 'audit') {
      selectedListData = interface.auditorTagsList;
    } else if (widget.page == 'tasks') {
      selectedListData = interface.tasksTagsList;
    } else if (widget.page == 'customer') {
      selectedListData = interface.customerTagsList;
    } else if (widget.page == 'performer') {
      selectedListData = interface.performerTagsList;
    } else if (widget.page == 'create') {
      selectedListData = interface.createTagsList;
    } else {
      selectedListData = [];
    }




    final double maxStaticDialogWidth = interface.maxStaticDialogWidth;
    const double myPadding = 8.0;

    final _searchKeywordController = TextEditingController();

    void dispose() {
      _searchKeywordController.dispose();
      super.dispose();
    }

    return LayoutBuilder(
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
                  child: TextFormField(
                    controller: _searchKeywordController,
                    onChanged: (searchKeyword) {
                      tagsServices.tagsFilter(searchKeyword, simpleTagsMap);
                    },
                    autofocus: false,
                    obscureText: false,
                    onTapOutside: (test) {
                      FocusScope.of(context).unfocus();
                      // interface.taskMessage = messageController!.text;
                    },

                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.add),
                      suffixIcon: IconButton(
                        onPressed: () {
                          interface.dialogPagesController.animateToPage(
                              interface.dialogCurrentState['pages']['widgets.chat'] ?? 99,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.ease);
                        },
                        icon: const Icon(Icons.add_box),
                        padding: const EdgeInsets.only(right: 12.0),
                        highlightColor: Colors.grey,
                        hoverColor: Colors.transparent,
                        color: Colors.blueAccent,
                        splashColor: Colors.black,
                      ),
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
                      labelText: 'Add your tag name',
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
                  ),
                ),
                SizedBox(
                  height: maxHeight,
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: TagsServices.tagsFilterResults.entries.map((e) {
                        return WrappedChip(
                            interactive: false,
                            key: ValueKey(e),
                            theme: 'white',
                            nft: e.value.nft ?? false,
                            name: e.value.tag,
                            control: true,
                            page: 'create'
                        );
                      }).toList()),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class TagsServices extends ChangeNotifier {
  Map<String, SimpleTags> tasksAuditPending = {};
  static Map<String, SimpleTags> tagsFilterResults = {};
  late String searchTagKeyword = '';

  Future<void> tagsFilter(String enteredKeyword, Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    searchTagKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      tagsFilterResults = Map.from(tagsList);
    } else {
      for (String key in tagsList.keys) {
        if (tagsList[key]!.tag.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          tagsFilterResults[key] = tagsList[key]!;
        }
      }
    }
    notifyListeners();
  }

  Future<void> resetTagsFilter(Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    tagsFilterResults = Map.from(tagsList);
  }
}


