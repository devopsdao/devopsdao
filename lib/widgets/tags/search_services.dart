import 'package:devopsdao/blockchain/task.dart';
import 'package:devopsdao/widgets/tags/tags_old.dart';
import 'package:flutter/cupertino.dart';

import 'package:webthree/webthree.dart';

class SearchServices extends ChangeNotifier {
  Map<String, SimpleTags> tagsFilterResults = {...simpleTagsMap};

  Map<String, SimpleTags> auditorTagsList = {};
  Map<String, SimpleTags> tasksTagsList = {};
  Map<String, SimpleTags> customerTagsList = {};
  Map<String, SimpleTags> performerTagsList = {};
  Map<String, SimpleTags> createTagsList = {};

  Map<EthereumAddress, Task> filterResults = {};

  // set filterResults(Map<EthereumAddress, Task> filterResults) {}

  // experimental future. ready allow to run taskService.runFilter
  // late bool ready = false;


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
      tagsFilterResults = Map.from(tagsList);
      // tagsFilterResults = Map.fromEntries(
      //     tagsList.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1)
      // );
      newTag = false;
    } else {
      for (String key in tagsList.keys) {
        if (tagsList[key]!.selected) {
          tagsFilterResults[key] = tagsList[key]!;
        }
        if (tagsList[key]!.tag.toLowerCase().contains(enteredKeyword.toLowerCase())) {
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
    tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
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
    tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
    notifyListeners();
  }

  Future<void> resetTagsFilter(Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    tagsFilterResults = Map.from(tagsList);
  }

  //
  // Future<void> runFilter(String enteredKeyword, Map<EthereumAddress, Task> taskList,
  //     {List<String>? tagsList}) async {
  //   filterResults.clear();
  //   print(enteredKeyword);
  //   // searchKeyword = enteredKeyword;
  //   if (enteredKeyword.isEmpty) {
  //     filterResults = Map.from(taskList);
  //   } else {
  //     for (String taskAddress in taskList.keys) {
  //       if (taskList[taskAddress]!.title.toLowerCase().contains(enteredKeyword.toLowerCase())) {
  //         if (taskList.isNotEmpty && taskList[taskAddress]!.tags.isNotEmpty ) {
  //
  //
  //         } else {
  //           filterResults[taskAddress] = taskList[taskAddress]!;
  //         }
  //       }
  //     }
  //   }
  //   // Refresh the UI
  //   notifyListeners();
  // }
  //
  // Future<void> resetFilter(Map<EthereumAddress, Task> taskList) async {
  //   filterResults.clear();
  //   filterResults = Map.from(taskList);
  // }
}
