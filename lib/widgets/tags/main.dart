import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:dodao/widgets/tags/widgets/fab_button.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as Badges;

import '../../account_dialog/widget/dialog_button_widget.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../pages/performer_page.dart';
import '../../tags_manager/collection_services.dart';
import '../../tags_manager/nft_item.dart';
import '../../tags_manager/nft_card.dart';
import '../my_tools.dart';
import 'wrapped_chip.dart';
import 'package:flutter/services.dart';

enum ItemFilter { tags, both, nfts }

class MainTagsPage extends StatefulWidget {
  final String page;
  final int tabIndex;

  final PerformerPageWidget? performerPageWidget;

  const MainTagsPage({Key? key, required this.page, required this.tabIndex, this.performerPageWidget}) : super(key: key);


  @override
  _MainTagsPageState createState() => _MainTagsPageState();
}

class _MainTagsPageState extends State<MainTagsPage> {
  final PageController pageController = PageController(initialPage: 0);
  late Map<String, NftTagsBunch> tagsLocalList;
  final _searchKeywordController = TextEditingController();

  final Duration splitDuration = const Duration(milliseconds: 600);
  final Curve splitCurve = Curves.easeInOutQuart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      searchServices.tagSelection(typeSelection: 'selection', tagName: '', unselectAll: true, tagKey: '');

      //refresh NFT "selection" list
      tasksServices.collectMyNfts();
      Future.delayed(
        const Duration(milliseconds: 300), () {
            searchServices.refreshLists('selection');
            searchServices.refreshLists('treasury');
        }
      );

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

      for (var e in searchServices.selectionPageFilterResults.entries) {
        searchServices.selectionPageFilterResults[e.key]!.selected = false;
        for (var e2 in tagsLocalList.entries) {
          if (e.key == e2.key) {
            searchServices.selectionPageFilterResults[e.key]!.selected = true;
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
    var interfaceServices = context.read<InterfaceServices>();
    var searchServices = context.read<SearchServices>();
    var tasksServices = context.read<TasksServices>();
    var collectionServices = context.read<CollectionServices>();

    late Map<String, TagsCompare> tagsCompare = {};
    late String actualPage = '';
    widget.page == 'create' ? actualPage = 'selection' : actualPage = 'filter';


    // searchServices.resetTagsFilter(simpleTagsMap);


    // tagsLocalList.entries.where((element) {
    //   return element.value.selected == true;
    // });

    final Widget nftInfoField = Consumer<CollectionServices>(
        builder: (context, model, child) {
          late double secondPartHeight = 0.0;
          late bool splitScreen = false;
          final int nftCount = model.treasuryNftsInfoSelected.bunch.length;
          final String collectionName = model.treasuryNftsInfoSelected.bunch.entries.first.value.name;
          if (model.treasuryNftsInfoSelected.bunch.entries.first.value.name != 'empty') {
            splitScreen = true;
          }
          secondPartHeight = 300;

          return AnimatedContainer(

            duration: splitDuration,
            height: splitScreen ? secondPartHeight : 0.0,
            color: DodaoTheme.of(context).nftInfoBackgroundColor,
            curve: splitCurve,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    elevation: 6.0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 18, left: 8, right: 8),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              InkResponse(
                                radius: 35,
                                containedInkWell: false  ,
                                onTap: () {
                                  pageController.animateToPage(pageController.page!.toInt() - 1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 24,
                                  color: DodaoTheme.of(context).secondaryText,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Consumer<InterfaceServices>(
                                    builder: (context, model, child) {
                                      // Reset count:
                                      if (model.treasuryPageCount > nftCount) {
                                        model.treasuryPageCount = 1;
                                      }
                                      return Text(
                                        '${model.treasuryPageCount} of ${nftCount.toString()}',
                                        style: Theme.of(context).textTheme.bodyMedium?.apply(color: DodaoTheme.of(context).primaryText),
                                      );
                                    }
                                ),
                              ),
                              InkResponse(
                                radius: 35,
                                containedInkWell: false  ,
                                onTap: () {
                                  pageController.animateToPage(pageController.page!.toInt() + 1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 24,
                                  color: DodaoTheme.of(context).secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              collectionName,
                              style:  Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const Spacer(),
                          InkResponse(
                            radius: 35,
                            containedInkWell: false  ,
                            onTap: () {
                              model.clearSelectedInManager();
                            },
                            child: Icon(
                              Icons.arrow_downward,
                              size: 24,
                              color: DodaoTheme.of(context).secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: secondPartHeight - 58,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: PageView.builder(
                        onPageChanged: (number) {
                          interfaceServices.treasuryPageCountUpdate(number + 1);
                        },
                        itemCount: model.treasuryNftsInfoSelected.bunch.length,
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          late Widget nftItemWidget;
                          if (model.treasuryNftsInfoSelected.bunch.values.toList()[index].nft) {
                            nftItemWidget = NftItem(
                              item: model.treasuryNftsInfoSelected.bunch.values.toList()[index],
                              frameHeight: secondPartHeight, page: 'selection',
                            );
                          } else {
                            nftItemWidget = NftMint(
                              item: model.treasuryNftsInfoSelected.bunch.values.toList()[index],
                              frameHeight: secondPartHeight,
                            );
                          }
                          return nftItemWidget;
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );


    final double maxStaticDialogWidth = interfaceServices.maxStaticDialogWidth;
    const double myPadding = 8.0;

    const List<Widget> filter = <Widget>[
      Text('Tags'),
      Text('Both'),
      Text('Nft\'s')
    ];


    final Widget body = LayoutBuilder(
        builder: (context, constraints) {
          final double myHeight = constraints.maxHeight - (myPadding * 2);
          final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
          final double maxHeight = myHeight - statusBarHeight - 138;



          final List<bool> selectedFilter = <bool>[false, true, false];

          return Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.only(top: myPadding),
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
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Add tags',
                                        style: Theme.of(context).textTheme.titleLarge
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
                          searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');
                          searchServices.forbidSearchKeywordClear = true;
                          searchServices.specialTagSelection(tagName: '', tagKey: '', unselectAll: true);
                          searchServices.nftSelection(nftName: '', nftKey: BigInt.from(0), unselectAll: true, unselectAllInBunch: false);
                          collectionServices.clearSelectedInManager();
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
                    padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
                    height: 50,
                    child: Consumer<SearchServices>(
                      builder: (context, model, child) {
                        return Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // SegmentedButton<ItemFilter>(
                            //   segments: const <ButtonSegment<ItemFilter>>[
                            //     ButtonSegment<ItemFilter>(
                            //         value: ItemFilter.tags,
                            //         label: Text('Tags'),
                            //         icon: Icon(Icons.calendar_view_day)),
                            //     ButtonSegment<ItemFilter>(
                            //         value: ItemFilter.both,
                            //         label: Text('Both'),
                            //         icon: Icon(Icons.calendar_view_week)),
                            //     ButtonSegment<ItemFilter>(
                            //         value: ItemFilter.nfts,
                            //         label: Text('Nft\'s'),
                            //         icon: Icon(Icons.calendar_view_month)),
                            //   ],
                            //   selected: <ItemFilter>{itemFilter},
                            //   onSelectionChanged: (Set<ItemFilter> newSelection) {
                            //     setState(() {
                            //       itemFilter = newSelection.first;
                            //     });
                            //   },
                            // ),

                            ToggleButtons(
                              direction: Axis.horizontal,
                              onPressed: (int index) {
                                setState(() {
                                  // The button that is tapped is set to true, and the others to false.
                                  for (int i = 0; i < selectedFilter.length; i++) {
                                    setState(() {

                                      selectedFilter[i] = i == index;

                                    });
                                  }
                                });
                              },
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              borderWidth: 2,
                              selectedBorderColor: DodaoTheme.of(context).tabIndicator,
                              selectedColor: DodaoTheme.of(context).primaryText,
                              fillColor: DodaoTheme.of(context).tabIndicator,
                              color: DodaoTheme.of(context).secondaryText,
                              borderColor: DodaoTheme.of(context).tabIndicator,
                              constraints: const BoxConstraints(
                                minHeight: 30.0,
                                minWidth: 60.0,
                              ),
                              isSelected: selectedFilter,
                              children: filter,
                            ),
                            Row(
                              children: [
                                const Text('Tags: '),
                                Badges.Badge(
                                  // position: BadgePosition.topEnd(top: 10, end: 10),
                                  elevation: 0,
                                  badgeContent: Container(
                                    width: 14,
                                    height: 14,
                                    alignment: Alignment.center,
                                    child: Text(
                                        searchServices.tags.toString(),
                                        style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.white),
                                      // style: Theme.of(context).textTheme.bodySmall?.apply(color: DodaoTheme.of(context).primaryText),
                                    ),
                                  ),
                                  badgeColor: DodaoTheme.of(context).tabIndicator,
                                  // badgeColor: Colors.white,
                                  // animationDuration: const Duration(milliseconds: 600),
                                  // animationType: Badges.BadgeAnimationType.fade,
                                  toAnimate: false,
                                  shape: Badges.BadgeShape.square,
                                  borderRadius: BorderRadius.circular(6),
                                  // child: Icon(Icons.settings),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text('Nft\'s: '),
                                Badges.Badge(
                                  elevation: 0,
                                  badgeContent: Container(
                                    width: 14,
                                    height: 14,
                                    alignment: Alignment.center,
                                    child: Text(
                                        searchServices.nfts.toString(),
                                        style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.white),),
                                  ),
                                  badgeColor: DodaoTheme.of(context).tabIndicator,
                                  toAnimate: false,
                                  shape: Badges.BadgeShape.square,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  ),

                  Container(
                    padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
                    height: 70,
                    child: Consumer<SearchServices>(
                      builder: (context, model, child) {

                        return TextFormField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            model.tagsSearchFilter( page: 'selection', enteredKeyword: searchKeyword,);
                          },
                          autofocus: false,
                          obscureText: false,
                          // onTapOutside: (test) {
                          //   FocusScope.of(context).unfocus();
                          //   // interface.taskMessage = messageController!.text;
                          // },

                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.add),
                            // suffixIcon: model.newTag ? IconButton(
                            //   onPressed: () {
                            //     // NEW TAG
                            //     // searchServices.nftInitialCollectionMap[_searchKeywordController.text] =
                            //     //     SimpleTags(collection: false, tag: _searchKeywordController.text, icon: "", selected: true);
                            //     searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'treasury', tagKey: '');
                            //     model.addNewTag(_searchKeywordController.text, 'selection');
                            //     collectionServices.updateMintNft(searchServices.selectionPageInitialCombined[_searchKeywordController.text]!.bunch.values.first);
                            //   },
                            //   icon: const Icon(Icons.add_box),
                            //   padding: const EdgeInsets.only(right: 12.0),
                            //   highlightColor: Colors.grey,
                            //   hoverColor: Colors.transparent,
                            //   color: DodaoTheme.of(context).tabIndicator,
                            //   splashColor: Colors.black,
                            // ) : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(
                                color: DodaoTheme.of(context).tabIndicator,
                                width: 2.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Tag name',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: '[Enter your tag here..]',
                            hintStyle:  Theme.of(context).textTheme.bodyMedium,
                            // hintStyle:  Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
                            // focusedBorder: const UnderlineInputBorder(
                            //   borderSide: BorderSide.none,
                            // ),

                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                          minLines: 1,
                          maxLines: 1,
                        );
                      }
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 4.0, right: 8.0, left: 8.0, bottom: 4.0),
                        height: maxHeight - 10,
                        alignment: Alignment.topLeft,
                        child: Builder(
                            builder: (context) {
                            final searchProvider= Provider.of<SearchServices>(context, listen: true);
                            return Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: searchProvider.selectionPageFilterResults.entries.map((e) {
                                  final String name = e.key;
                                  if(!tagsCompare.containsKey(name)){
                                    if (e.value.selected) {
                                      tagsCompare[name] = TagsCompare(state: 'remain',);
                                    } else {
                                      tagsCompare[name] = TagsCompare(state: 'none',);
                                    }
                                  } else if (tagsCompare.containsKey(name)) {
                                    if (e.value.selected) {
                                      if (tagsCompare[name]!.state == 'start') {
                                        tagsCompare.update(name, (val) => val = TagsCompare(state: 'remain',));
                                      }
                                      if (tagsCompare[name]!.state == 'none') {
                                        tagsCompare.update(name, (val) => val = TagsCompare(state: 'start',));
                                      }
                                      if (tagsCompare[name]!.state == 'end') {
                                        tagsCompare.update(name, (val) => val = TagsCompare(state: 'start',));
                                      }
                                    } else {
                                      if (tagsCompare[name]!.state == 'end') {
                                        tagsCompare.update(name, (val) => val = TagsCompare(state: 'none',));
                                      }
                                      if (tagsCompare[name]!.state == 'start') {
                                        tagsCompare.update(name, (val) => val = TagsCompare(state: 'end',));
                                      }
                                      if (tagsCompare[name]!.state == 'remain') {
                                        tagsCompare.update(name, (val) => val = TagsCompare(state: 'end',));
                                      }
                                    }
                                  }
                                  return WrappedChip(
                                    key: ValueKey(e),
                                    theme: 'white',
                                    item: e,
                                    // selection or filter:
                                    page: actualPage,
                                    startScale: false,
                                    animationCicle: tagsCompare[name]!.state,
                                    selected: e.value.selected,
                                    wrapperRole: WrapperRole.selectNew,
                                  );
                                }).toList());
                          }
                        ),
                      ),

                      nftInfoField
                    ],
                  ),
                ],
              ),
            ),
          );
        }
    );

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
      body: body,
      floatingActionButtonAnimator: NoScalingAnimation(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat ,
      floatingActionButton: Consumer<CollectionServices>(
        builder: (context, model, child) {
          late bool splitScreen = false;
          if (model.treasuryNftsInfoSelected.bunch.entries.first.value.name != 'empty') {
            splitScreen = true;
          }
          return AnimatedContainer(
            // padding: keyboardSize == 0 ? const EdgeInsets.only(left: 40.0, right: 28.0) : const EdgeInsets.only(right: 14.0),
            padding: EdgeInsets.only(right: 13, left: 46, bottom: (splitScreen && MediaQuery.of(context).viewInsets.bottom == 0)? 300.0 : 0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutQuart,
            child: TagsFAB(

              inactive: false,
              expand: false,
              buttonName: 'Apply',
              buttonColorRequired: Colors.lightBlue.shade300,
              widthSize: (MediaQuery.of(context).viewInsets.bottom == 0 && !splitScreen )? 600 : 120, // Keyboard shown?
              callback: () {
                searchServices.selectTagListOnTasksPages(page: widget.page, initial: false);
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
          );
        }
      ),
    );
  }
}