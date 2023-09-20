import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
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
  late Map<String, NftCollection> tagsLocalList;
  final _searchKeywordController = TextEditingController();

  final Duration splitDuration = const Duration(milliseconds: 600);
  final Curve splitCurve = Curves.easeInOutQuart;
  late double safeAreaWidth = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      searchServices.tagSelection(typeSelection: 'selection', tagName: '', unselectAll: true, tagKey: '');

      //refresh NFT "selection" list
      await tasksServices.collectMyTokens();
      Future.delayed(const Duration(milliseconds: 100), () {
        searchServices.refreshLists('selection');
        searchServices.refreshLists('treasury');
      });

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

    final double maxStaticDialogWidth = interfaceServices.maxStaticDialogWidth;
    const double myPadding = 8.0;

    const List<Widget> filter = <Widget>[Text('Tags'), Text('Both'), Text('Nft\'s')];

    final Widget nftInfoField = Consumer<CollectionServices>(builder: (context, model, child) {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 8, right: 8),
              child: Row(
                children: [
                  Row(
                    children: [
                      InkResponse(
                        radius: 35,
                        containedInkWell: false,
                        onTap: () {
                          pageController.animateToPage(pageController.page!.toInt() - 1,
                              duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 24,
                          color: DodaoTheme.of(context).secondaryText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Consumer<InterfaceServices>(builder: (context, model, child) {
                          // Reset count:
                          if (model.treasuryPageCount > nftCount) {
                            model.treasuryPageCount = 1;
                          }
                          return Text(
                            '${model.treasuryPageCount} of ${nftCount.toString()}',
                            style: Theme.of(context).textTheme.bodyMedium?.apply(color: DodaoTheme.of(context).primaryText),
                          );
                        }),
                      ),
                      InkResponse(
                        radius: 35,
                        containedInkWell: false,
                        onTap: () {
                          pageController.animateToPage(pageController.page!.toInt() + 1,
                              duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const Spacer(),
                  InkResponse(
                    radius: 35,
                    containedInkWell: false,
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
            SizedBox(
              height: secondPartHeight - 60,
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
                        frameHeight: secondPartHeight,
                        page: 'selection',
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
      );
    });

    final Widget body = LayoutBuilder(builder: (context, constraints) {
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
                                  TextSpan(text: 'Tags', style: Theme.of(context).textTheme.titleLarge),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
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
                        child: const Row(
                          children: <Widget>[
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
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 10.0, right: 12.0, left: 12.0),
                height: 50,
                child: Consumer<SearchServices>(builder: (context, model, child) {
                  return Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text('Tags selected: '),
                          Badges.Badge(
                            // position: BadgePosition.topEnd(top: 10, end: 10),
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
                            // badgeColor: Colors.white,
                            // animationDuration: const Duration(milliseconds: 600),
                            // animationType: Badges.BadgeAnimationType.fade,
                            badgeAnimation: const Badges.BadgeAnimation.slide(
                            // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                            // curve: Curves.easeInCubic,
                            ),
                            badgeStyle: Badges.BadgeStyle(
                              badgeColor: DodaoTheme.of(context).tabIndicator,
                              elevation: 0,
                              shape: Badges.BadgeShape.square,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            // child: Icon(Icons.settings),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Nft\'s selected: '),
                          Badges.Badge(
                            badgeContent: Container(
                              width: 14,
                              height: 14,
                              alignment: Alignment.center,
                              child: Text(
                                searchServices.nfts.toString(),
                                style: Theme.of(context).textTheme.bodySmall?.apply(color: Colors.white),
                              ),
                            ),
                            badgeStyle: Badges.BadgeStyle(
                              badgeColor: DodaoTheme.of(context).tabIndicator,
                              elevation: 0,
                              shape: Badges.BadgeShape.square,
                              borderRadius: BorderRadius.circular(6),
                            ),
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
                child: Consumer<SearchServices>(builder: (context, model, child) {
                  return TextFormField(
                    controller: _searchKeywordController,
                    onChanged: (searchKeyword) {
                      model.tagsSearchFilter(
                        page: 'selection',
                        enteredKeyword: searchKeyword,
                      );
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
                      //     //     TokenItem(collection: false, tag: _searchKeywordController.text, icon: "", selected: true);
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
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      // hintStyle:  Theme.of(context).textTheme.bodyMedium?.apply(heightFactor: 1.4),
                      // focusedBorder: const UnderlineInputBorder(
                      //   borderSide: BorderSide.none,
                      // ),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                    minLines: 1,
                    maxLines: 1,
                  );
                }),
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
                    child: Builder(builder: (context) {
                      final searchProvider = Provider.of<SearchServices>(context, listen: true);
                      return Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          children: searchProvider.selectionPageFilterResults.entries.map((e) {
                            final String name = e.key;
                            if (!tagsCompare.containsKey(name)) {
                              if (e.value.selected) {
                                tagsCompare[name] = TagsCompare(
                                  state: 'remain',
                                );
                              } else {
                                tagsCompare[name] = TagsCompare(
                                  state: 'none',
                                );
                              }
                            } else if (tagsCompare.containsKey(name)) {
                              if (e.value.selected) {
                                if (tagsCompare[name]!.state == 'start') {
                                  tagsCompare.update(
                                      name,
                                      (val) => val = TagsCompare(
                                            state: 'remain',
                                          ));
                                }
                                if (tagsCompare[name]!.state == 'none') {
                                  tagsCompare.update(
                                      name,
                                      (val) => val = TagsCompare(
                                            state: 'start',
                                          ));
                                }
                                if (tagsCompare[name]!.state == 'end') {
                                  tagsCompare.update(
                                      name,
                                      (val) => val = TagsCompare(
                                            state: 'start',
                                          ));
                                }
                              } else {
                                if (tagsCompare[name]!.state == 'end') {
                                  tagsCompare.update(
                                      name,
                                      (val) => val = TagsCompare(
                                            state: 'none',
                                          ));
                                }
                                if (tagsCompare[name]!.state == 'start') {
                                  tagsCompare.update(
                                      name,
                                      (val) => val = TagsCompare(
                                            state: 'end',
                                          ));
                                }
                                if (tagsCompare[name]!.state == 'remain') {
                                  tagsCompare.update(
                                      name,
                                      (val) => val = TagsCompare(
                                            state: 'end',
                                          ));
                                }
                              }
                            }
                            return WrappedChip(
                              key: ValueKey(e),
                              item: e,
                              // selection or filter:
                              page: actualPage,
                              startScale: false,
                              animationCicle: tagsCompare[name]!.state,
                              selected: e.value.selected,
                              wrapperRole: WrapperRole.selectNew,
                            );
                          }).toList());
                    }),
                  ),
                  nftInfoField
                ],
              ),
            ],
          ),
        ),
      );
    });

    return LayoutBuilder(builder: (ctx, constraints) {
      final double myMaxWidth = constraints.maxWidth;
      if (myMaxWidth >= maxStaticDialogWidth) {
        // actualFieldWidth = maxStaticInternalDialogWidth;
        safeAreaWidth = (myMaxWidth - maxStaticDialogWidth) / 2;
      }

      return Container(
        color: DodaoTheme.of(context).taskBackgroundColor,
        child: SafeArea(
          minimum: EdgeInsets.only(left: safeAreaWidth, right: safeAreaWidth),
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            backgroundColor: DodaoTheme.of(context).taskBackgroundColor,
            body: body,
            floatingActionButtonAnimator: NoScalingAnimation(),
            // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat ,
            floatingActionButton: Consumer<CollectionServices>(builder: (context, model, child) {
              late bool splitScreen = false;
              if (model.treasuryNftsInfoSelected.bunch.entries.first.value.name != 'empty') {
                splitScreen = true;
              }
              return Padding(
                padding: const EdgeInsets.only(right: 13, left: 46),
                // AnimatedCOntainer needs to show button 'Apply' over Tag Info:
                child: AnimatedContainer(
                  padding: EdgeInsets.only(bottom: (splitScreen && MediaQuery.of(context).viewInsets.bottom == 0) ? 300.0 : 0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutQuart,
                  child: TaskDialogFAB(
                    inactive: false,
                    expand: true,
                    buttonName: 'Apply',
                    buttonColorRequired: Colors.lightBlue.shade300,
                    widthSize: (MediaQuery.of(context).viewInsets.bottom == 0 && !splitScreen) ? 600 : 120, // Keyboard shown?
                    callback: () {
                      searchServices.selectTagListOnTasksPages(page: widget.page, initial: false);
                      if (widget.page == 'audit') {
                        if (widget.tabIndex == 0) {
                          tasksServices.runFilter(
                            taskList: tasksServices.tasksAuditPending,
                            tagsMap: searchServices.auditorTagsList,
                            enteredKeyword: searchServices.searchKeywordController.text,
                          );
                        } else if (widget.tabIndex == 1) {
                          tasksServices.runFilter(
                            taskList: tasksServices.tasksAuditApplied,
                            tagsMap: searchServices.auditorTagsList,
                            enteredKeyword: searchServices.searchKeywordController.text,
                          );
                        } else if (widget.tabIndex == 2) {
                          tasksServices.runFilter(
                            taskList: tasksServices.tasksAuditWorkingOn,
                            tagsMap: searchServices.auditorTagsList,
                            enteredKeyword: searchServices.searchKeywordController.text,
                          );
                        } else if (widget.tabIndex == 3) {
                          tasksServices.runFilter(
                            taskList: tasksServices.tasksAuditComplete,
                            tagsMap: searchServices.auditorTagsList,
                            enteredKeyword: searchServices.searchKeywordController.text,
                          );
                        }
                      } else if (widget.page == 'tasks') {
                        tasksServices.runFilter(
                            taskList: tasksServices.tasksNew,
                            tagsMap: searchServices.tasksTagsList,
                            enteredKeyword: searchServices.searchKeywordController.text);
                      } else if (widget.page == 'customer') {
                        if (widget.tabIndex == 0) {
                          tasksServices.runFilter(
                              taskList: tasksServices.tasksCustomerSelection,
                              tagsMap: searchServices.customerTagsList,
                              enteredKeyword: searchServices.searchKeywordController.text);
                        } else if (widget.tabIndex == 1) {
                          tasksServices.runFilter(
                              taskList: tasksServices.tasksCustomerProgress,
                              tagsMap: searchServices.customerTagsList,
                              enteredKeyword: searchServices.searchKeywordController.text);
                        } else if (widget.tabIndex == 2) {
                          tasksServices.runFilter(
                              taskList: tasksServices.tasksCustomerComplete,
                              tagsMap: searchServices.customerTagsList,
                              enteredKeyword: searchServices.searchKeywordController.text);
                        }
                      } else if (widget.page == 'performer') {
                        if (widget.tabIndex == 0) {
                          tasksServices.runFilter(
                              taskList: tasksServices.tasksPerformerParticipate,
                              tagsMap: searchServices.performerTagsList,
                              enteredKeyword: searchServices.searchKeywordController.text);
                        } else if (widget.tabIndex == 1) {
                          tasksServices.runFilter(
                              taskList: tasksServices.tasksPerformerProgress,
                              tagsMap: searchServices.performerTagsList,
                              enteredKeyword: searchServices.searchKeywordController.text);
                        } else if (widget.tabIndex == 2) {
                          tasksServices.runFilter(
                              taskList: tasksServices.tasksPerformerComplete,
                              tagsMap: searchServices.performerTagsList,
                              enteredKeyword: searchServices.searchKeywordController.text);
                        }
                      }
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
