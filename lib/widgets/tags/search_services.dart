import 'dart:async';

import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/cupertino.dart';

class SearchServices extends ChangeNotifier {
  final searchKeywordController = TextEditingController();
  //
  late ValueNotifier<bool> searchBarStart = ValueNotifier(true);

  Future<List<String>> getMintList() async {
    List<String>list = [];
    for (var v in mintPageFilterResults.values) {
      list.add(v.name);
    }
    return list;
  }

  Map<String, NftCollection> mintPageFilterResults = {};
  Map<String, NftCollection> treasuryPageFilterResults = {};
  Map<String, NftCollection> taskFilterResults = {};
  Map<String, NftCollection> addToNewTaskFilterResults = {};
  Map<String, NftCollection> selectionPageInitialCombined = {};
  Map<String, NftCollection> auditorTagsList = {};
  Map<String, NftCollection> tasksTagsList = {};
  Map<String, NftCollection> customerTagsList = {};
  Map<String, NftCollection> performerTagsList = {};
  Map<String, NftCollection> createTagsList = {};

  Map<String, NftCollection> _nftBalanceMap = {};
  Map<String, NftCollection> get nftBalanceMap => _nftBalanceMap;
  set nftBalanceMap(Map<String, NftCollection> value) {
    if (value != nftBalanceMap ) {
      _nftBalanceMap = value;
      notifyListeners();
    }
  }

  Map<String, NftCollection> _collectionMap = {};
  Map<String, NftCollection> get collectionMap => _collectionMap;
  set collectionMap(Map<String, NftCollection> value) {
    if (value != collectionMap ) {
      _collectionMap = value;
      notifyListeners();
    }
  }



  Future refreshLists(String listToRefresh) async {
    if (listToRefresh == 'mint') {
      mintPageFilterResults.clear();
      mintPageFilterResults = Map.from(collectionMap);
      mintPageFilterResults.removeWhere((String key, dynamic value) => key == '');
    } else if (listToRefresh == 'treasury') {
      treasuryPageFilterResults.clear();
      treasuryPageFilterResults = Map.from(nftBalanceMap);
      treasuryPageFilterResults.removeWhere((String key, dynamic value) => key == '');
    } else if (listToRefresh == 'filter') {
      taskFilterResults.clear();
      taskFilterResults = Map.from(collectionMap);
      taskFilterResults.removeWhere((String key, dynamic value) => key == '');
    } else if (listToRefresh == 'selection') {
      Map<String, NftCollection> tempNfts = {};
      if (collectionMap.entries.isNotEmpty) {
        for (var e in collectionMap.entries) {
          if (e.value.name != '') {
            tempNfts['collection ${e.key}'] = NftCollection(
                name: e.key,
                bunch: { BigInt.from(0) : (
                    TokenItem(
                        name: e.key,
                        collection: false,
                        nft: false,
                        selected: false
                    )
                )},
                selected: false
            );
          }

        }
      }
      addToNewTaskFilterResults = {...nftBalanceMap, ...tempNfts };
      selectionPageInitialCombined = {...nftBalanceMap, ...tempNfts, }; // initial combined copied map for tagsSearchFilter()

    }
    notifyListeners();
  }

  // experimental future. ready allow to run taskService.runFilter. to be deleted/
  late bool forbidSearchKeywordClear = false;

  Future removeTagOnPages(tagKey, {required String page}) async {
    if (page == 'auditor') {
      auditorTagsList.removeWhere((key, value) => key== tagKey);
    } else if (page == 'tasks') {
      tasksTagsList.removeWhere((key, value) => key == tagKey);
    } else if (page == 'customer') {
      customerTagsList.removeWhere((key, value) => key == tagKey);
    } else if (page == 'performer') {
      performerTagsList.removeWhere((key, value) => key == tagKey);
    } else if (page == 'create') {
      createTagsList.removeWhere((key, value) => key == tagKey);
    }
    // always remove from main filter list:
    // mintPageFilterResults.removeWhere((key, value) => value.tag == tagName);
    // after remove from actual list, we need to reset mintPageFilterResults to false
    if (page != 'create') {
      // addToNewTaskFilterResults[tagKey]!.selected = false;
      taskFilterResults[tagKey]!.selected = false;
    }
    notifyListeners();
    // selectTagListOnTasksPages(page: page, initial: false);
  }

  Future removeAllTagsOnPages({required String page}) async {
    if (page == 'auditor') {
      auditorTagsList.clear();
    } else if (page == 'tasks') {
      tasksTagsList.clear();
    } else if (page == 'customer') {
      customerTagsList.clear();
    } else if (page == 'performer') {
      performerTagsList.clear();
    } else if (page == 'create') {
      createTagsList.clear();
    }
    notifyListeners();
  }

  Future selectTagListOnTasksPages({required String page, required bool initial}) async {
    // we add default "defaultTagAddNew" button that is displayed on task pages.
    // "Initial" means that we do not want to update the lists if they have not
    // been changed. Since we have only one "mintPageFilterResults", we must avoid
    // re-recordings data from it. "Initial:true" is launched only from task
    // pages, "Initial:false" - from the tag selection page/

    final Map<String, NftCollection> defaultTagAddNew = {
      // '#' : NftCollection(name: '#', bunch: {
      //   BigInt.from(0): TokenItem(
      //       collection: false, name: "#", icon: "", nft: false, selected: false)
      // })
    };


    late Map<String, NftCollection> list = {};

    // exclude create(add new task) page to add # tag:
    // if (page != 'create') { list = defaultTagAddNew; }
    final Map<String, NftCollection> filter;
    if (page == 'create') {
      filter = addToNewTaskFilterResults;
    } else {
      filter = taskFilterResults;
    }

    filter.entries.map((e) {
      // ...TagsList store tags on pages, it is ok to pass only first value from bunch
      if (e.value.selected) {
        // final Map<BigInt, TokenItem> nft = {};
        // for (var e2 in e.value.bunch.entries) {
        //   if (e2.value.selected) {
        //     nft[e2.key] = e2.value;
        //   }
        // }
        //
        // list[e.key]!.bunch.clear();
        // list[e.key]!.bunch = nft;

        // loop "bunch" for selected items
        for (TokenItem n in e.value.bunch.values) {
          // only NFTs has
          if (n.nft) {
            if (n.selected) {
              list[e.key] = e.value;
            }
          } else {
            list[e.key] = e.value;
          }
        }
      }
    }).toList();

    if (page == 'auditor') {
      if (initial) {
        if (auditorTagsList.isEmpty) {
          auditorTagsList = defaultTagAddNew;
        }
      } else {
        auditorTagsList = list;
      }
    } else if (page == 'tasks') {
      if (initial) {
        if (tasksTagsList.isEmpty) {
          tasksTagsList = defaultTagAddNew;
        }
      } else {
        tasksTagsList = list;
      }
    } else if (page == 'customer') {
      if (initial) {
        if (customerTagsList.isEmpty) {
          customerTagsList = defaultTagAddNew;
        }
      } else {
        customerTagsList = list;
      }
    } else if (page == 'performer') {
      if (initial) {
        if (performerTagsList.isEmpty) {
          performerTagsList = defaultTagAddNew;
        }
      } else {
        performerTagsList = list;
      }
    } else if (page == 'create') {
      createTagsList = list;
      // clear addToNewTaskFilterResults to prevent appearing on pages
      // addToNewTaskFilterResults.clear();
    }
    // tagsListToPass = list.entries.map((e) => e.value.tag).toList();
    notifyListeners();
  }

  // late String searchTagKeyword = '';
  // this flag 'newTag' gives ability to add new Tag to List:
  late bool newTag = false;

  // Search in TAGS list
  Future<void> tagsSearchFilter({required String enteredKeyword, required String page}) async {
    late Map<String, NftCollection> resultMap = {};
    late Map<String, NftCollection> initialMap;
    if (page == 'mint') {
      initialMap = collectionMap;
      // resultMap = mintPageFilterResults;
    } else if (page == 'selection') {
      initialMap = selectionPageInitialCombined;
      // resultMap = addToNewTaskFilterResults;
    } else if (page == 'treasury') {
      initialMap = nftBalanceMap;
      // resultMap = treasuryPageFilterResults;
    } else if (page == 'filter') {
      initialMap = collectionMap;
      // resultMap = taskFilterResults;
    }
    // clear resultMap(and all associated maps) before start to write into it:
    // resultMap.clear();
    // searchTagKeyword = enteredKeyword;

    if (enteredKeyword.isEmpty) {
      resultMap = Map.from(initialMap);
      newTag = false;
    } else {
      for (String key in initialMap.keys) { 
        if (initialMap[key]!.selected) {
          resultMap[key] = initialMap[key]!;
        }
        if (initialMap[key]!.name.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          resultMap[key] = initialMap[key]!;
        }
      }

      // show button "add new tag":
      enteredKeyword.length > 1 ? newTag = true : newTag = false;
      // show button to add new tag !break used in loop:
      for (String key in initialMap.keys) {
        if (resultMap[key]?.name == enteredKeyword) {
          newTag = false;
          break;
        }
      }
    }
    // sort data:
    resultMap = Map.fromEntries(resultMap.entries.toList()
      ..sort((e1, e2) {
        if (e2.value.selected != e1.value.selected) {
          return e2.value.selected ? 1 : -1;
        } else {
          return e1.value.name.compareTo(e2.value.name);
        }
      }));


    if (page == 'mint') {
      mintPageFilterResults.clear();
      mintPageFilterResults = resultMap;
      mintPageFilterResults.removeWhere((String key, dynamic value) => key == '');
    } else if (page == 'selection') {
      addToNewTaskFilterResults.clear();
      addToNewTaskFilterResults = resultMap;
      addToNewTaskFilterResults.removeWhere((String key, dynamic value) => key == '');
    } else if (page == 'treasury') {
      treasuryPageFilterResults.clear();
      treasuryPageFilterResults = resultMap;
      treasuryPageFilterResults.removeWhere((String key, dynamic value) => key == '');
    } else if (page == 'filter') {
      taskFilterResults.clear();
      taskFilterResults = resultMap;
      taskFilterResults.removeWhere((String key, dynamic value) => key == '');
    }
    notifyListeners();
  }

  Future<void> addNewTag(String newTagName, String page) async {
    if (page == 'mint') {
      mintPageFilterResults.clear();
      mintPageFilterResults = Map.from(collectionMap); // {...nftBalanceMap};
      mintPageFilterResults[newTagName] = NftCollection(
          name: newTagName,
          bunch: { BigInt.from(0) : (
              TokenItem(
                  name: newTagName,
                  collection: false,
                  nft: false,
                  selected: false
              )
          )},
          selected: true
      );
      newTag = false;
      mintPageFilterResults = Map.fromEntries(mintPageFilterResults.entries.toList()
        ..sort((e1, e2) {
          if (e2.value.selected != e1.value.selected) {
            return e2.value.selected ? 1 : -1;
          } else {
            return e1.value.name.compareTo(e2.value.name);
          }
        }));
    } else if (page == 'selection') {
      // selectionPageInitialCombined.clear();
      // selectionPageInitialCombined = Map.from(collectionMap); // {...nftBalanceMap};
      // selectionPageInitialCombined[newTagName] = NftCollection(
      //     name: newTagName,
      //     bunch: { BigInt.from(0) : (
      //         TokenItem(
      //             name: newTagName,
      //             collection: false,
      //             nft: false,
      //             selected: false
      //         )
      //     )},
      //     selected: true
      // );
      // newTag = false;
      // selectionPageInitialCombined = Map.fromEntries(selectionPageInitialCombined.entries.toList()
      //   ..sort((e1, e2) {
      //     if (e2.value.selected != e1.value.selected) {
      //       return e2.value.selected ? 1 : -1;
      //     } else {
      //       return e1.value.name.compareTo(e2.value.name);
      //     }
      //   }));
    }
    notifyListeners();
  }

  late int nfts = 0;
  late int tags = 0;
  Future<void> countSelection() async {
    nfts = 0;
    tags = 0;
    for (MapEntry<String, NftCollection> e in addToNewTaskFilterResults.entries) {
      if (e.value.bunch.values.first.nft) {
        for (MapEntry<BigInt, TokenItem> e2 in e.value.bunch.entries) {
          if (e2.value.selected) {
            nfts++;
          }
        }
      } else {
        if (e.value.selected) {
          tags++;
        }
      }
    }
    notifyListeners();
  }

  Future<void> nftSelection({
  required bool unselectAll,
  required bool unselectAllInBunch,
  required String nftName,
  required BigInt nftKey
  }) async {
    if (!unselectAll) {
      for (MapEntry<String, NftCollection> e in addToNewTaskFilterResults.entries) {
        if (e.value.bunch.values.first.nft) {
          for (BigInt key in e.value.bunch.keys) {
            if (key == nftKey) {
              final bool selected = addToNewTaskFilterResults[nftName]!.bunch[key]!.selected;
              selected ? addToNewTaskFilterResults[nftName]!.bunch[key]!.selected = false :
                addToNewTaskFilterResults[nftName]!.bunch[key]!.selected = true;
            }
          }
        }
      }
    } else if (unselectAllInBunch) {
      // call from tagSelection which fires when user unselect nft in 'selection' page(wrapped_chip)
      for (MapEntry<String, NftCollection> e in addToNewTaskFilterResults.entries) {
        if (e.value.bunch.values.first.nft) {
          for (BigInt key in e.value.bunch.keys) {
            if (key == nftKey) {
              final bool selected = addToNewTaskFilterResults[nftName]!.bunch[key]!.selected;
              selected ? addToNewTaskFilterResults[nftName]!.bunch[key]!.selected = false :
              addToNewTaskFilterResults[nftName]!.bunch[key]!.selected = true;
            }
          }
        }
      }
    } else {
      for (MapEntry<String, NftCollection> e in addToNewTaskFilterResults.entries) {
        if (e.value.bunch.values.first.nft) {
          for (TokenItem v in e.value.bunch.values) {
            if (v.selected) {
              v.selected = false;
            }
          }
        }
      }
    }
    countSelection();
  }

  Future<void> specialTagSelection({
    required String tagName,
    required String tagKey,
    bool unselectAll = false
  }) async {
    late bool nftSelected = false;
    for (MapEntry<String, NftCollection> e in addToNewTaskFilterResults.entries) {
      final Map<BigInt, TokenItem> bunch = e.value.bunch;

      // tag bunch has Nft?
      if (bunch.values.first.nft) {
        // print('name(tag key): ${e.key}, tag selected: ${e.value.selected}');
        for (var v in bunch.values) {
          // print('nft name: ${val.name}, nft in bunch selected: ${val.selected}');
          // tag bunch has selected Nft?
          if (v.selected) {
            nftSelected = true;
          }
          // unselect all nfts if tag going to unselect:
          if (tagKey == e.key) {
            if (e.value.selected) {
              v.selected = false;
            }
          }
        }
        // select or unselect tapped Tag:
        if (e.value.name == tagName) {

          if (bunch.values.length < 2 && !e.value.selected) {
            e.value.selected = true;
            e.value.bunch.values.first.selected = true;
            // nftSelected = true;
          } else {
            e.value.selected ? e.value.selected = false : e.value.selected = true;
          }
        }

        // unselect other tags(except with nft selected):
        if (e.value.name != tagName && !nftSelected) {
          // print('nftSelected: $nftSelected, e.value.name ${e.value.name}');
          e.value.selected = false;
          nftSelected = false;

        }

        if (unselectAll) {
          if (e.value.selected && !nftSelected) {
            e.value.selected = false;
          }
        }
      }

      nftSelected = false;

    }
    countSelection();
  }

  Future<void> tagSelection({
    required String typeSelection,
    required String tagName,
    required String tagKey,
    required bool unselectAll,
  }) async {
    if (typeSelection == 'selection') {
      for (String key in addToNewTaskFilterResults.keys) {
        if (key == tagKey) {
          if (addToNewTaskFilterResults[key]!.selected) {
            addToNewTaskFilterResults[key]!.selected = false;
          } else {
            addToNewTaskFilterResults[key]!.selected = true;
          }
        } else if (unselectAll) {
          // print('unselectAll in selection');
          addToNewTaskFilterResults[key]!.selected = false;
        }
      }
    } else if (typeSelection == 'filter') {
      for (String key in taskFilterResults.keys) {
        if (key == tagKey) {
          if (taskFilterResults[key]!.selected) {
            taskFilterResults[key]!.selected = false;
          } else {
            taskFilterResults[key]!.selected = true;
          }
        } else if (unselectAll) {
          // print('unselectAll in selection');
          taskFilterResults[key]!.selected = false;
        }


      }
    } else if (typeSelection == 'mint') {

      for (String key in mintPageFilterResults.keys) {
        if (mintPageFilterResults[key]?.name == tagName) {
          if (mintPageFilterResults[key]!.selected) {
            mintPageFilterResults[key]!.selected = false;
          } else {
            mintPageFilterResults[key]!.selected = true;
          }
        } else if (key != tagName || unselectAll) {
          mintPageFilterResults[key]!.selected = false;
        }
      }

    } else if (typeSelection == 'treasury') {
      for (String key in treasuryPageFilterResults.keys) {
        if (key.toLowerCase() == tagName.toLowerCase() && !unselectAll) {
          treasuryPageFilterResults[key]!.selected = true;
        } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
          treasuryPageFilterResults[key]!.selected = false;
        }
      }
    }
    // reset counter
    countSelection();
  }
}
