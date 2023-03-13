import 'dart:async';

import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/cupertino.dart';

import 'package:webthree/webthree.dart';

import '../../tags_manager/nft_templorary.dart';

class SearchServices extends ChangeNotifier {
  Map<String, SimpleTags> tagsFilterResults = {...simpleTagsMap};

  Map<String, NftTagsBunch> nftFilterResults = {...nftTagsMap};

  Map<String, SimpleTags> auditorTagsList = {};
  Map<String, SimpleTags> tasksTagsList = {};
  Map<String, SimpleTags> customerTagsList = {};
  Map<String, SimpleTags> performerTagsList = {};
  Map<String, SimpleTags> createTagsList = {};

  List<String> tagsListToPass = [];

  // Map<EthereumAddress, Task> _filterResults = {};
  // Map<EthereumAddress, Task> get filterResults => _filterResults;
  // set filterResults(Map<EthereumAddress, Task> value) {
  //   if (value != filterResults ) {
  //     _filterResults = value;
  //     notifyListeners();
  //     print(_filterResults);
  //   }
  // }

  // set filterResults(Map<EthereumAddress, Task> filterResults) {}

  // experimental future. ready allow to run taskService.runFilter
  late bool forbidSearchKeywordClear = false;

  Future removeTagOnTasksPages(tagName, {required String page}) async {
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
    // always remove from main filter list:
    tagsFilterResults.removeWhere((key, value) => value.tag == tagName);
    updateTagListOnTasksPages(page: page);
    // print('removeTagOnTasksPages');
  }

  Future updateTagListOnTasksPages({required String page}) async {
    late Map<String, SimpleTags> list = {};
    tagsFilterResults.entries.map((e) {
      if (e.value.selected) {
        list[e.value.tag] = e.value;
      }
    }).toList();

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
    // tagsListToPass = list.entries.map((e) => e.value.tag).toList();
    notifyListeners();
    // print('updateTagListOnTasksPages');
  }

  late String searchTagKeyword = '';
  // this flag 'newTag' gives ability to add new Tag to List:
  late bool newTag = false;

  // Search in TAGS list
  Future<void> tagsSearchFilter(String enteredKeyword, Map<String, SimpleTags> tagsList) async {
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
    // tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
    // tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()
    //   ..sort((e1, e2) => e2.value.tag.compareTo(e1.value.tag) == 0 ?
    //   (e2.value.selected ? 1 : -1) : e2.value.tag.compareTo(e1.value.tag)));
    // tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.tag.compareTo(e1.value.tag) * (e2.value.selected ? -1 : 1)));
    tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()
      ..sort((e1, e2) {
        if (e2.value.selected != e1.value.selected) {
          return e2.value.selected ? 1 : -1;
        } else {
          return e1.value.tag.compareTo(e2.value.tag);
        }
      }));

    notifyListeners();
    print('tagsSearchFilter');
  }

  Future<void> tagsAddAndUpdate(Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    for (String key in tagsList.keys) {
      if (tagsList[key]!.selected) {
        tagsFilterResults[key] = tagsList[key]!;
      }
    }
    newTag = false;
    // tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
    // tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()
    //   ..sort((e1, e2) => e2.value.tag.compareTo(e1.value.tag) == 0 ?
    //   (e2.value.selected ? 1 : -1) : e2.value.tag.compareTo(e1.value.tag)));
    // tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()..sort((e1, e2) => e2.value.tag.compareTo(e1.value.tag) * (e2.value.selected ? -1 : 1)));
    tagsFilterResults = Map.fromEntries(tagsFilterResults.entries.toList()
      ..sort((e1, e2) {
        if (e2.value.selected != e1.value.selected) {
          return e2.value.selected ? 1 : -1;
        } else {
          return e1.value.tag.compareTo(e2.value.tag);
        }
      }));
    notifyListeners();
    print('tagsAddAndUpdate');
  }

  Future<void> resetTagsFilter(Map<String, SimpleTags> tagsList) async {
    tagsFilterResults.clear();
    tagsFilterResults = Map.from(tagsList);
  }

  Future<void> tagSelection({required String typeSelection, required String tagName, required bool unselectAll}) async {
    if (typeSelection == 'selection') {
      for (String key in tagsFilterResults.keys) {
        if (tagsFilterResults[key]?.tag.toLowerCase() == tagName.toLowerCase()) {
          if (tagsFilterResults[key]!.selected) {
            tagsFilterResults[key]!.selected = false;
          } else {
            tagsFilterResults[key]!.selected = true;
          }
        }
      }
    } else if (typeSelection == 'mint') {
      for (String key in tagsFilterResults.keys) {
        if (tagsFilterResults[key]?.tag.toLowerCase() == tagName.toLowerCase()) {
          if (tagsFilterResults[key]!.selected) {
            tagsFilterResults[key]!.selected = false;
          } else {
            tagsFilterResults[key]!.selected = true;
          }
        } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
          tagsFilterResults[key]!.selected = false;
        }
      }
    }
    notifyListeners();
  }

  Future<void> resetNFTFilter(Map<String, NftTagsBunch> tagsList) async {
    nftFilterResults.clear();
    nftFilterResults = Map.from(tagsList);
  }

  Future<void> tagsNFTFilter(String enteredKeyword, Map<String, NftTagsBunch> tagsList) async {
    nftFilterResults.clear();
    searchTagKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      nftFilterResults = Map.from(tagsList);
      newTag = false;
    } else {
      for (String key in tagsList.keys) {
        if (tagsList[key]!.selected) {
          nftFilterResults[key] = tagsList[key]!;
        }
        if (key.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          nftFilterResults[key] = tagsList[key]!;
        }
      }
      // show button to add new tag:
      enteredKeyword.length > 2 ? newTag = true : newTag = false;
      // show button to add new tag !break used in loop:
      for (String key in tagsList.keys) {
        if (key.toLowerCase() == enteredKeyword.toLowerCase()) {
          newTag = false;
          break;
        }
      }
    }
    nftFilterResults = Map.fromEntries(nftFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
    notifyListeners();
    print('tagsNFTFilter');
  }

  Future<void> nftSelection({required String tagName, required bool unselectAll}) async {
    for (String key in nftFilterResults.keys) {
      if (key.toLowerCase() == tagName.toLowerCase()) {
        nftFilterResults[key]!.selected = true;
      } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
        nftFilterResults[key]!.selected = false;
      }
    }
    notifyListeners();
    print('nftSelection');
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
