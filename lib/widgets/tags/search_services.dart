import 'dart:async';

import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/cupertino.dart';

import '../../tags_manager/nft_templorary.dart';

class SearchServices extends ChangeNotifier {
  final searchKeywordController = TextEditingController();
  //
  late ValueNotifier<bool> searchBarStart = ValueNotifier(true);

  SimpleTags defaultTagAddNew = SimpleTags(collection: false, tag: "#", icon: "", nft: false, selected: true);

  Map<String, SimpleTags> tagsFilterResults = {...simpleTagsMap};
  // Map<String, NftTagsBunch> nftFilterResults = {...nftTagsMap};
  Map<String, SimpleTags> auditorTagsList = {};
  Map<String, SimpleTags> tasksTagsList = {};
  Map<String, SimpleTags> customerTagsList = {};
  Map<String, SimpleTags> performerTagsList = {};
  Map<String, SimpleTags> createTagsList = {};

  Map<String, NftTagsBunch> _nftFilterResults = {};
  Map<String, NftTagsBunch> get nftFilterResults => _nftFilterResults;
  set nftFilterResults(Map<String, NftTagsBunch> value) {
    // print(_resultNftsMapReceived);
    // print(resultNftsMapReceived);
    print(nftFilterResults);
    if (value != nftFilterResults ) {
      _nftFilterResults = value;
      notifyListeners();
    }
  }

  // experimental future. ready allow to run taskService.runFilter. to be deleted/
  late bool forbidSearchKeywordClear = false;

  Future removeTagsOnPages(tagName, {required String page}) async {
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
    // tagsFilterResults.removeWhere((key, value) => value.tag == tagName);
    // after remove from actual list, we need to reset tagsFilterResults to false
    tagsFilterResults[tagName]!.selected = false;
    notifyListeners();
    // updateTagListOnTasksPages(page: page, initial: false);
  }

  Future updateTagListOnTasksPages({required String page, required bool initial}) async {
    // we add default "defaultTagAddNew" button that is displayed on task pages.
    // "Initial" means that we do not want to update the lists if they have not
    // been changed. Since we have only one "tagsFilterResults", we must avoid
    // re-recordings data from it. "Initial:true" is launched only from task
    // pages, "Initial:false" - from the tag selection page.

    late Map<String, SimpleTags> list = {
      "#" : defaultTagAddNew
    };
    tagsFilterResults.entries.map((e) {
      if (e.value.selected) {
        list[e.value.tag] = e.value;
      }
    }).toList();

    if (page == 'auditor') {
      if (initial) {
        if (auditorTagsList.isEmpty) {
          auditorTagsList = {"#" : defaultTagAddNew};
        }
      } else {
        auditorTagsList = list;
      }
    } else if (page == 'tasks') {
      if (initial) {
        if (tasksTagsList.isEmpty) {
          tasksTagsList = {"#" : defaultTagAddNew};
        }
      } else {
        tasksTagsList = list;
      }
    } else if (page == 'customer') {
      if (initial) {
        if (customerTagsList.isEmpty) {
          customerTagsList = {"#" : defaultTagAddNew};
        }
      } else {
        customerTagsList = list;
      }
    } else if (page == 'performer') {
      if (initial) {
        if (performerTagsList.isEmpty) {
          performerTagsList = {"#" : defaultTagAddNew};
        }
      } else {
        performerTagsList = list;
      }
    } else if (page == 'create') {
      if (initial) {
        if (createTagsList.isEmpty) {
          createTagsList = {"#" : defaultTagAddNew};
        }
      } else {
        createTagsList = list;
      }
    }
    // tagsListToPass = list.entries.map((e) => e.value.tag).toList();
    notifyListeners();
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
  }

  Future<void> nftInfoSelection({required String tagName, required bool unselectAll}) async {
    for (String key in nftFilterResults.keys) {
      if (key.toLowerCase() == tagName.toLowerCase()) {
        nftFilterResults[key]!.selected = true;
      } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
        nftFilterResults[key]!.selected = false;
      }
    }
    notifyListeners();
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
