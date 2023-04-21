import 'dart:async';

import 'package:dodao/blockchain/classes.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/cupertino.dart';

import '../../tags_manager/nft_templorary.dart';

class SearchServices extends ChangeNotifier {
  final searchKeywordController = TextEditingController();
  //
  late ValueNotifier<bool> searchBarStart = ValueNotifier(true);


  Map<String, NftTagsBunch> mintPageFilterResults = {};
  Map<String, NftTagsBunch> treasuryPageFilterResults = {};
  Map<String, NftTagsBunch> selectionPageFilterResults = {};
  Map<String, NftTagsBunch> selectionPageInitialCombined = {};
  Map<String, NftTagsBunch> auditorTagsList = {};
  Map<String, NftTagsBunch> tasksTagsList = {};
  Map<String, NftTagsBunch> customerTagsList = {};
  Map<String, NftTagsBunch> performerTagsList = {};
  Map<String, NftTagsBunch> createTagsList = {};

  Map<String, NftTagsBunch> _nftBalanceMap = {};
  Map<String, NftTagsBunch> get nftBalanceMap => _nftBalanceMap;
  set nftBalanceMap(Map<String, NftTagsBunch> value) {
    if (value != nftBalanceMap ) {
      _nftBalanceMap = value;
      notifyListeners();
    }
  }

  Map<String, NftTagsBunch> _nftCollectionMap = {};
  Map<String, NftTagsBunch> get nftCollectionMap => _nftCollectionMap;
  set nftCollectionMap(Map<String, NftTagsBunch> value) {
    if (value != nftCollectionMap ) {
      _nftCollectionMap = value;
      notifyListeners();
    }
  }



  Future refreshLists(String listToRefresh) async {
    if (listToRefresh == 'mint') {
      mintPageFilterResults.clear();
      mintPageFilterResults = Map.from(nftCollectionMap);
    } else if (listToRefresh == 'treasury') {
      treasuryPageFilterResults.clear();
      treasuryPageFilterResults = Map.from(nftBalanceMap);
    } else if (listToRefresh == 'selection') {
      Map<String, NftTagsBunch> tempNfts = {};
      if (nftCollectionMap.entries.isNotEmpty) {
        for (var e in nftCollectionMap.entries) {
          tempNfts['collection ${e.key}'] = NftTagsBunch(
            name: e.key,
            bunch: { BigInt.from(0) : (
              SimpleTags(
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
      selectionPageFilterResults = {...tempNfts, ...nftBalanceMap};
      selectionPageInitialCombined = {...tempNfts, ...nftBalanceMap}; // initial combined copied map for tagsSearchFilter()
    }
    notifyListeners();
  }

  // experimental future. ready allow to run taskService.runFilter. to be deleted/
  late bool forbidSearchKeywordClear = false;

  Future removeTagsOnPages(tagKey, {required String page}) async {
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
    selectionPageFilterResults[tagKey]!.selected = false;
    notifyListeners();
    // updateTagListOnTasksPages(page: page, initial: false);
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

  Future updateTagListOnTasksPages({required String page, required bool initial}) async {
    // we add default "defaultTagAddNew" button that is displayed on task pages.
    // "Initial" means that we do not want to update the lists if they have not
    // been changed. Since we have only one "mintPageFilterResults", we must avoid
    // re-recordings data from it. "Initial:true" is launched only from task
    // pages, "Initial:false" - from the tag selection page/

    final Map<String, NftTagsBunch> defaultTagAddNew = {
      '#' : NftTagsBunch(name: '#', bunch: {
        BigInt.from(0): SimpleTags(
            collection: false, name: "#", icon: "", nft: false, selected: false)
      })
    };


    late Map<String, NftTagsBunch> list = {};

    // exclude create(add new task) page to add # tag:
    if (page != 'create') { list = defaultTagAddNew; }
    selectionPageFilterResults.entries.map((e) {
      // ...TagsList store tags on pages, it is ok to pass only first value from bunch
      if (e.value.selected) {
        if (page == 'create') {
          // final Map<BigInt, SimpleTags> nft = {};
          // for (var e2 in e.value.bunch.entries) {
          //   if (e2.value.selected) {
          //     nft[e2.key] = e2.value;
          //   }
          // }
          //
          // list[e.key]!.bunch.clear();
          // list[e.key]!.bunch = nft;

          // check if bunch has selected item (nft) then add this bunch
          late bool selected = false;
          for (SimpleTags nft in e.value.bunch.values) {
            selected = nft.selected;
          }
          if (selected) {
            list[e.key] = e.value;
          }
        } else {
          list[e.key] = e.value;
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
    }
    // tagsListToPass = list.entries.map((e) => e.value.tag).toList();
    notifyListeners();
  }

  late String searchTagKeyword = '';
  // this flag 'newTag' gives ability to add new Tag to List:
  late bool newTag = false;

  // Search in TAGS list
  Future<void> tagsSearchFilter({required String enteredKeyword, required String page}) async {
    late Map<String, NftTagsBunch> resultMap;
    late Map<String, NftTagsBunch> initialMap;
    if (page == 'mint') {
      resultMap = mintPageFilterResults;
      initialMap = nftCollectionMap;
    } else if (page == 'selection') {
      initialMap = selectionPageInitialCombined;
      resultMap = selectionPageFilterResults;
    } else if (page == 'treasury') {
      initialMap = nftBalanceMap;
      resultMap = treasuryPageFilterResults;
    }
    // clear resultMap(and all associated maps) before start to write into it:
    resultMap.clear();
    searchTagKeyword = enteredKeyword;

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

      // show button to add new tag:
      enteredKeyword.length > 2 ? newTag = true : newTag = false;
      // show button to add new tag !break used in loop:
      for (String key in initialMap.keys) {
        if (resultMap[key]?.name.toLowerCase() == enteredKeyword.toLowerCase()) {
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
    } else if (page == 'selection') {
      selectionPageFilterResults.clear();
      selectionPageFilterResults = resultMap;
    } else if (page == 'treasury') {
      treasuryPageFilterResults.clear();
      treasuryPageFilterResults = resultMap;
    }
    notifyListeners();
  }

  // Future<void> tagsNFTFilter(String enteredKeyword) async {
  //   treasuryPageFilterResults.clear();
  //   searchTagKeyword = enteredKeyword;
  //
  //   if (enteredKeyword.isEmpty) {
  //     treasuryPageFilterResults = Map.from(nftBalanceMap);
  //     newTag = false;
  //   } else {
  //     for (String key in nftBalanceMap.keys) {
  //       if (nftBalanceMap[key]!.selected) {
  //         treasuryPageFilterResults[key] = nftBalanceMap[key]!;
  //       }
  //       if (key.toLowerCase().contains(enteredKeyword.toLowerCase())) {
  //         treasuryPageFilterResults[key] = nftBalanceMap[key]!;
  //       }
  //     }
  //     // show button to add new tag:
  //     enteredKeyword.length > 2 ? newTag = true : newTag = false;
  //     // show button to add new tag !break used in loop:
  //     for (String key in nftBalanceMap.keys) {
  //       if (key.toLowerCase() == enteredKeyword.toLowerCase()) {
  //         newTag = false;
  //         break;
  //       }
  //     }
  //   }
  //   treasuryPageFilterResults = Map.fromEntries(treasuryPageFilterResults.entries.toList()..sort((e1, e2) {
  //     return e2.value.selected ? 1 : -1;
  //   }));
  //   notifyListeners();
  // }

  Future<void> addNewTag(String newTagName, String page) async {
    if (page == 'mint') {
      mintPageFilterResults.clear();
      mintPageFilterResults = Map.from(nftCollectionMap); // {...nftBalanceMap};
      mintPageFilterResults[newTagName] = NftTagsBunch(
          name: newTagName,
          bunch: { BigInt.from(0) : (
              SimpleTags(
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
      selectionPageInitialCombined.clear();
      selectionPageInitialCombined = Map.from(nftCollectionMap); // {...nftBalanceMap};
      selectionPageInitialCombined[newTagName] = NftTagsBunch(
          name: newTagName,
          bunch: { BigInt.from(0) : (
              SimpleTags(
                  name: newTagName,
                  collection: false,
                  nft: false,
                  selected: false
              )
          )},
          selected: true
      );
      newTag = false;
      selectionPageInitialCombined = Map.fromEntries(selectionPageInitialCombined.entries.toList()
        ..sort((e1, e2) {
          if (e2.value.selected != e1.value.selected) {
            return e2.value.selected ? 1 : -1;
          } else {
            return e1.value.name.compareTo(e2.value.name);
          }
        }));
    }
    notifyListeners();
  }

  late int nfts = 0;
  late int tags = 0;
  Future<void> countSelection() async {
    nfts = 0;
    tags = 0;
    for (MapEntry<String, NftTagsBunch> e in selectionPageFilterResults.entries) {
      if (e.value.bunch.values.first.nft) {
        for (MapEntry<BigInt, SimpleTags> e2 in e.value.bunch.entries) {
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
      for (MapEntry<String, NftTagsBunch> e in selectionPageFilterResults.entries) {
        if (e.value.bunch.values.first.nft) {
          for (BigInt key in e.value.bunch.keys) {
            if (key == nftKey) {
              final bool selected = selectionPageFilterResults[nftName]!.bunch[key]!.selected;
              selected ? selectionPageFilterResults[nftName]!.bunch[key]!.selected = false :
                selectionPageFilterResults[nftName]!.bunch[key]!.selected = true;
            }
          }
        }
      }
    } else if (unselectAllInBunch) {
      // call from tagSelection which fires when user unselect nft in 'selection' page(wrapped_chip)
      for (MapEntry<String, NftTagsBunch> e in selectionPageFilterResults.entries) {
        if (e.value.bunch.values.first.nft) {
          for (BigInt key in e.value.bunch.keys) {
            if (key == nftKey) {
              final bool selected = selectionPageFilterResults[nftName]!.bunch[key]!.selected;
              selected ? selectionPageFilterResults[nftName]!.bunch[key]!.selected = false :
              selectionPageFilterResults[nftName]!.bunch[key]!.selected = true;
            }
          }
        }
      }
    } else {
      for (MapEntry<String, NftTagsBunch> e in selectionPageFilterResults.entries) {
        if (e.value.bunch.values.first.nft) {
          for (SimpleTags v in e.value.bunch.values) {
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
    for (MapEntry<String, NftTagsBunch> e in selectionPageFilterResults.entries) {
      final Map<BigInt, SimpleTags> bunch = e.value.bunch;



      // tag bunch has Nft?
      if (bunch.values.first.nft) {
        // print('name(tag key): ${e.key}, tag selected: ${e.value.selected}');
        for (var val in bunch.values) {
          // print('nft name: ${val.name}, nft in bunch selected: ${val.selected}');
          // tag bunch has selected Nft?
          if (val.selected) {
            nftSelected = true;
          }
          // unselect all nfts if tag going to unselect:
          if (tagKey == e.key) {
            if (e.value.selected) {
              val.selected = false;
            }
          }

        }
        // select or unselect tapped Tag:
        if (e.value.name == tagName) {
          e.value.selected ? e.value.selected = false : e.value.selected = true;
        }

        // unselect other tags(except with nft selected):
        if (e.value.name != tagName && !nftSelected) {
          print('nftSelected: $nftSelected, e.value.name ${e.value.name}');
          e.value.selected = false;
          nftSelected = false;
        }

        if (unselectAll) {
          if (e.value.selected) {
            e.value.selected = false;
          }
        }
        // if (e.value.selected && e.value.name == tagName) {
        //   e.value.selected = false;
        // } else if (!e.value.selected && e.value.name == tagName){
        //   e.value.selected = true;
        // }
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
      for (String key in selectionPageFilterResults.keys) {
        if (key == tagKey) {
          if (selectionPageFilterResults[key]!.selected) {
            selectionPageFilterResults[key]!.selected = false;
          } else {
            selectionPageFilterResults[key]!.selected = true;
          }
        } else if (unselectAll) {
          // print('unselectAll in selection');
          selectionPageFilterResults[key]!.selected = false;
        }
      }
    } else if (typeSelection == 'mint') {
      for (String key in mintPageFilterResults.keys) {
        if (mintPageFilterResults[key]?.name.toLowerCase() == tagName.toLowerCase()) {
          if (mintPageFilterResults[key]!.selected) {
            mintPageFilterResults[key]!.selected = false;
          } else {
            mintPageFilterResults[key]!.selected = true;
          }
        } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
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

  // Future<void> combinedTagsSelection({required String typeSelection, required String tagName}) async {
  //   // fires from wrapped_chip on 'add new Task' page.
  //   if (typeSelection == 'selection') {
  //
  //   }
  //   notifyListeners();
  // }

  // Future<void> nftInfoSelection({required String tagName, required bool unselectAll}) async {
  //   for (String key in treasuryPageFilterResults.keys) {
  //     if (key.toLowerCase() == tagName.toLowerCase()) {
  //       treasuryPageFilterResults[key]!.selected = true;
  //     } else if (key.toLowerCase() != tagName.toLowerCase() || unselectAll) {
  //       treasuryPageFilterResults[key]!.selected = false;
  //     }
  //   }
  //   notifyListeners();
  // }
}
