import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../task_dialog/beamer.dart';
import '../../task_dialog/task_transition_effect.dart';
import '../../widgets/badgetab.dart';
import '../../widgets/loading.dart';
import '../../widgets/tags/search_services.dart';
import '../../widgets/tags/tag_open_container.dart';
import '../../config/theme.dart';
import 'package:flutter/material.dart';
import '../../widgets/tags/tags_old.dart';
import '../../widgets/tags/wrapped_chip.dart';

import 'package:webthree/credentials.dart';

import '../collection_services.dart';
import '../nft_item.dart';

class TreasuryWidget extends StatefulWidget {
  const TreasuryWidget({Key? key}) : super(key: key);

  @override
  _TreasuryWidget createState() => _TreasuryWidget();
}

class _TreasuryWidget extends State<TreasuryWidget> {
  final _searchKeywordController = TextEditingController();
  final PageController pageController = PageController(initialPage: 0);

  late Map<String, TagsCompare> tagsCompare = {};

  final Duration splitDuration = const Duration(milliseconds: 600);
  final Curve splitCurve = Curves.easeInOutQuart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      searchServices.tagSelection(typeSelection: 'treasury', tagName: '', unselectAll: true, tagKey: '');

      // final Map<String, dynamic> emptyCollectionMap = simpleTagsMap.map((key, value) => MapEntry(key, 0));
      // tasksServices.collectMyTokens();
      await tasksServices.collectMyTokens();
      Future.delayed(
        const Duration(milliseconds: 100), () {
          searchServices.refreshLists('treasury');
          searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');
        }
      );
    });
  }

  @override
  void dispose() {
    _searchKeywordController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var tasksServices = context.read<TasksServices>();
    // var collectionServices = context.read<CollectionServices>();
    var searchServices = context.read<SearchServices>();
    var interfaceServices = context.read<InterfaceServices>();

    // if (_searchKeywordController.text.isEmpty) {
    //   searchServices.resetNFTFilter(nftTagsMap);
    //
    // }

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
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 8, right: 8),
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
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const Spacer(),
                          InkResponse(
                            radius: 35,
                            containedInkWell: false  ,
                            onTap: () {
                              model.clearSelectedInManager();
                              searchServices.tagSelection(
                                  unselectAll: true,
                                  tagName: '', typeSelection: 'treasury', tagKey: ''
                              );
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
                          return NftItem(
                            item: model.treasuryNftsInfoSelected.bunch.values.toList()[index],
                            frameHeight: secondPartHeight, page: 'treasury',
                          );
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
        late final maxHeight = constraints.maxHeight - statusBarHeight - 76;
        // late double firstPartHeight = 0.0;
        // late double secondPartHeight = 0.0;
        // late bool splitScreen = false;
        // if (collectionServices.treasuryNftSelected.tag != 'empty') {
        //   splitScreen = true;
        //   firstPartHeight = maxHeight / 2;
        //   secondPartHeight = firstPartHeight;
        // }
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
              height: 70,
              child: Consumer<SearchServices>(
                  builder: (context, model, child) {
                    return TextFormField(
                      controller: _searchKeywordController,
                      onChanged: (searchKeyword) {
                        model.tagsSearchFilter(enteredKeyword: searchKeyword, page: 'treasury');
                        // model.tagsNFTFilter(searchKeyword);
                      },
                      autofocus: true,
                      obscureText: false,
                      onTapOutside: (test) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        // prefixIcon: const Icon(Icons.add),
                        // suffixIcon: model.newTag ? IconButton(
                        //   onPressed: () {
                        //     // NEW TAG
                        //     nftTagsMap[_searchKeywordController.text] =
                        //         TokenItem(collection: true, tag: _searchKeywordController.text, icon: "", selected: true);
                        //     model.tagsUpdate(nftTagsMap);
                        //   },
                        //   icon: const Icon(Icons.add_box),
                        //   padding: const EdgeInsets.only(right: 12.0),
                        //   highlightColor: Colors.grey,
                        //   hoverColor: Colors.transparent,
                        //   color: Colors.blueAccent,
                        //   splashColor: Colors.black,
                        // ) : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF47CBE4),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF47CBE4),
                            width: 2.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Tag name',
                        labelStyle:  Theme.of(context).textTheme.bodyMedium,
                        hintText: '[Enter nft name..]',
                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
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
                  height: maxHeight,
                  alignment: Alignment.topLeft,
                  child:  Consumer<SearchServices>(
                      builder: (context, model, child) {
                        return Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: model.treasuryPageFilterResults.entries.map((e) {

                              if(!tagsCompare.containsKey(e.key)){
                                if (e.value.selected) {
                                  tagsCompare[e.key] = TagsCompare(state: 'remain',);
                                } else {
                                  tagsCompare[e.key] = TagsCompare(state: 'none',);
                                }
                              } else if (tagsCompare.containsKey(e.key)) {
                                if (e.value.selected) {
                                  if (tagsCompare[e.key]!.state == 'start') {
                                    tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'remain',));
                                  }
                                  if (tagsCompare[e.key]!.state == 'none') {
                                    tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'start',));
                                  }
                                  if (tagsCompare[e.key]!.state == 'end') {
                                    tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'start',));
                                  }
                                } else {
                                  if (tagsCompare[e.key]!.state == 'end') {
                                    tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'none',));
                                  }
                                  if (tagsCompare[e.key]!.state == 'start') {
                                    tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'end',));
                                  }
                                  if (tagsCompare[e.key]!.state == 'remain') {
                                    tagsCompare.update(e.key, (val) => val = TagsCompare(state: 'end',));
                                  }
                                }


                                // if (e.value.selected && tagsCompare[e.value.tag]!.state == 'none') {
                                //   // Start animation on clicked Widget
                                //   tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'start',));
                                // } else if (tagsCompare[e.value.tag]!.state == 'none' && !e.value.selected) {
                                //   // End(exit) animation
                                //   tagsCompare.update(e.value.tag, (val) => val = TagsCompare(state: 'end',));
                                // }


                                // for (var entry in entriesCopy.entries) {
                                //   print(DateTime.now().difference(entry.value.timestamp).inSeconds);
                                //   if (DateTime.now().difference(entry.value.timestamp).inSeconds > 1) {
                                //     tagsCompare.remove(e.value.tag);
                                //   }
                                // }
                              }
                              return WrappedChip(
                                  key: ValueKey(e),
                                  item: e,
                                  page: 'treasury',
                                  startScale: false,
                                  selected: e.value.selected,
                                  animationCicle: tagsCompare[e.key]!.state,
                                  wrapperRole: WrapperRole.treasure,
                              );
                            }).toList()
                        );
                      }
                  ),
                ),
                nftInfoField,
              ]
            ),
          ],
        );
      }
    );
  }
}



