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

  Map<String, SimpleTags> tagsCollectionFilterResults = {};
  Map<String, NftTagsBunch> nftBalanceFilterResults = {};
  Map<String, NftTagsBunch> combinedFilterResults = {};
  Map<String, SimpleTags> auditorTagsList = {};
  Map<String, SimpleTags> tasksTagsList = {};
  Map<String, SimpleTags> customerTagsList = {};
  Map<String, SimpleTags> performerTagsList = {};
  Map<String, SimpleTags> createTagsList = {};

  Map<String, NftTagsBunch> _nftBalanceMap = {};
  Map<String, NftTagsBunch> get nftBalanceMap => _nftBalanceMap;
  set nftBalanceMap(Map<String, NftTagsBunch> value) {
    // print('nftBalanceMap: $nftBalanceMap');
    if (value != nftBalanceMap ) {
      _nftBalanceMap = value;
      notifyListeners();
    }
  }

  Map<String, SimpleTags> _nftInitialCollectionMap = {};
  Map<String, SimpleTags> get nftInitialCollectionMap => _nftInitialCollectionMap;
  set nftInitialCollectionMap(Map<String, SimpleTags> value) {
    if (value != nftInitialCollectionMap ) {
      _nftInitialCollectionMap = value;
      notifyListeners();
    }
  }



  Future refreshLists(String listToRefresh) async {
    if (listToRefresh == 'collections') {
      tagsCollectionFilterResults.clear();
      tagsCollectionFilterResults = Map.from(nftInitialCollectionMap);
    } else if (listToRefresh == 'nft_balance') {
      nftBalanceFilterResults.clear();
      nftBalanceFilterResults = Map.from(nftBalanceMap);
    }
    notifyListeners();
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
    // tagsCollectionFilterResults.removeWhere((key, value) => value.tag == tagName);
    // after remove from actual list, we need to reset tagsCollectionFilterResults to false
    tagsCollectionFilterResults[tagName]!.selected = false;
    notifyListeners();
    // updateTagListOnTasksPages(page: page, initial: false);
  }

  Future updateTagListOnTasksPages({required String page, required bool initial}) async {
    // we add default "defaultTagAddNew" button that is displayed on task pages.
    // "Initial" means that we do not want to update the lists if they have not
    // been changed. Since we have only one "tagsCollectionFilterResults", we must avoid
    // re-recordings data from it. "Initial:true" is launched only from task
    // pages, "Initial:false" - from the tag selection page.

    late Map<String, SimpleTags> list = {
      "#" : defaultTagAddNew
    };
    tagsCollectionFilterResults.entries.map((e) {
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
  Future<void> tagsSearchFilter(String enteredKeyword) async {
    tagsCollectionFilterResults.clear();
    searchTagKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      tagsCollectionFilterResults = Map.from(nftInitialCollectionMap);
      // tagsCollectionFilterResults = Map.fromEntries(
      //     tagsList.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1)
      // );
      newTag = false;
    } else {
      for (String key in nftInitialCollectionMap.keys) {
        if (nftInitialCollectionMap[key]!.selected) {
          tagsCollectionFilterResults[key] = nftInitialCollectionMap[key]!;
        }
        if (nftInitialCollectionMap[key]!.tag.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          tagsCollectionFilterResults[key] = nftInitialCollectionMap[key]!;
        }
      }
      // show button to add new tag:
      enteredKeyword.length > 2 ? newTag = true : newTag = false;
      // show button to add new tag !break used in loop:
      for (String key in nftInitialCollectionMap.keys) {
        if (tagsCollectionFilterResults[key]?.tag.toLowerCase() == enteredKeyword.toLowerCase()) {
          newTag = false;
          break;
        }
      }
    }
    // tagsCollectionFilterResults = Map.fromEntries(tagsCollectionFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
    // tagsCollectionFilterResults = Map.fromEntries(tagsCollectionFilterResults.entries.toList()
    //   ..sort((e1, e2) => e2.value.tag.compareTo(e1.value.tag) == 0 ?
    //   (e2.value.selected ? 1 : -1) : e2.value.tag.compareTo(e1.value.tag)));
    // tagsCollectionFilterResults = Map.fromEntries(tagsCollectionFilterResults.entries.toList()..sort((e1, e2) => e2.value.tag.compareTo(e1.value.tag) * (e2.value.selected ? -1 : 1)));
    tagsCollectionFilterResults = Map.fromEntries(tagsCollectionFilterResults.entries.toList()
      ..sort((e1, e2) {
        if (e2.value.selected != e1.value.selected) {
          return e2.value.selected ? 1 : -1;
        } else {
          return e1.value.tag.compareTo(e2.value.tag);
        }
      }));

    notifyListeners();
  }

  Future<void> tagsAddAndUpdate(String newTagName) async {
    tagsCollectionFilterResults.clear();
    tagsCollectionFilterResults = nftInitialCollectionMap;
    tagsCollectionFilterResults[newTagName] = SimpleTags(collection: false, tag: newTagName, icon: "", selected: true);
    // nftInitialCollectionMap[newTagName] =
    //     SimpleTags(collection: false, tag: newTagName, icon: "", selected: true);
    //
    // for (String key in nftInitialCollectionMap.keys) {
    //   if (nftInitialCollectionMap[key]!.selected) {
    //     tagsCollectionFilterResults[key] = nftInitialCollectionMap[key]!;
    //   }
    // }
    newTag = false;
    tagsCollectionFilterResults = Map.fromEntries(tagsCollectionFilterResults.entries.toList()
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
    tagsCollectionFilterResults.clear();
    tagsCollectionFilterResults = Map.from(tagsList);
  }

  Future<void> tagSelection({required String typeSelection, required String tagName, required bool unselectAll}) async {
    if (typeSelection == 'selection') {
      for (String key in tagsCollectionFilterResults.keys) {
        if (tagsCollectionFilterResults[key]?.tag.toLowerCase() == tagName.toLowerCase()) {
          if (tagsCollectionFilterResults[key]!.selected) {
            tagsCollectionFilterResults[key]!.selected = false;
          } else {
            tagsCollectionFilterResults[key]!.selected = true;
          }
        }
      }
    } else if (typeSelection == 'mint') {
      for (String key in tagsCollectionFilterResults.keys) {
        if (tagsCollectionFilterResults[key]?.tag.toLowerCase() == tagName.toLowerCase()) {
          if (tagsCollectionFilterResults[key]!.selected) {
            tagsCollectionFilterResults[key]!.selected = false;
          } else {
            tagsCollectionFilterResults[key]!.selected = true;
          }
        } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
          tagsCollectionFilterResults[key]!.selected = false;
        }
      }
    }
    notifyListeners();
  }

  Future<void> combinedTagsSelection({required String typeSelection, required String tagName}) async {
    // fires from wrapped_chip on 'add new Task' page.
    if (typeSelection == 'selection') {
      for (String key in combinedFilterResults.keys) {
        if (combinedFilterResults[key]?.tag.toLowerCase() == tagName.toLowerCase()) {
          if (combinedFilterResults[key]!.selected) {
            combinedFilterResults[key]!.selected = false;
          } else {
            combinedFilterResults[key]!.selected = true;
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> resetNFTFilter(Map<String, NftTagsBunch> tagsList) async {
    nftBalanceFilterResults.clear();
    nftBalanceFilterResults = Map.from(tagsList);
  }

  Future<void> tagsNFTFilter(String enteredKeyword) async {
    nftBalanceFilterResults.clear();
    searchTagKeyword = enteredKeyword;
    if (enteredKeyword.isEmpty) {
      nftBalanceFilterResults = Map.from(nftBalanceMap);
      newTag = false;
    } else {
      for (String key in nftBalanceMap.keys) {
        if (nftBalanceMap[key]!.selected) {
          nftBalanceFilterResults[key] = nftBalanceMap[key]!;
        }
        if (key.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          nftBalanceFilterResults[key] = nftBalanceMap[key]!;
        }
      }
      // show button to add new tag:
      enteredKeyword.length > 2 ? newTag = true : newTag = false;
      // show button to add new tag !break used in loop:
      for (String key in nftBalanceMap.keys) {
        if (key.toLowerCase() == enteredKeyword.toLowerCase()) {
          newTag = false;
          break;
        }
      }
    }
    nftBalanceFilterResults = Map.fromEntries(nftBalanceFilterResults.entries.toList()..sort((e1, e2) => e2.value.selected ? 1 : -1));
    notifyListeners();
  }

  Future<void> nftInfoSelection({required String tagName, required bool unselectAll}) async {
    for (String key in nftBalanceFilterResults.keys) {
      if (key.toLowerCase() == tagName.toLowerCase()) {
        nftBalanceFilterResults[key]!.selected = true;
      } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
        nftBalanceFilterResults[key]!.selected = false;
      }
    }
    notifyListeners();
  }

  Future<void> combineTagsWithNfts() async {
    Map<String, NftTagsBunch> tempNfts = {};
    if (nftInitialCollectionMap.entries.isNotEmpty) {
      for (var e in nftInitialCollectionMap.entries) {
        tempNfts['initial ${e.key}'] = NftTagsBunch(
            tag: e.key,
          bunch: { 0 : (
            SimpleTags(
                tag: e.key,
                collection: false,
                nft: false,
                selected: false
            )
          )},
          selected: false);
      }
    }
    combinedFilterResults = {...tempNfts, ...nftBalanceMap};
    print(combinedFilterResults);
  }
}
