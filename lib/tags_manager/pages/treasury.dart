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

import '../manager_services.dart';
import '../nft_templorary.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var searchServices = Provider.of<SearchServices>(context, listen: false);
      var tasksServices = Provider.of<TasksServices>(context, listen: false);
      searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true);
      // final Map<String, dynamic> emptyCollectionMap = simpleTagsMap.map((key, value) => MapEntry(key, 0));
      // tasksServices.collectMyNfts();
      tasksServices.collectMyNfts();
      searchServices.refreshLists('nft_balance');
      searchServices.combineTagsWithNfts();
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
    var tasksServices = context.read<TasksServices>();
    // var managerServices = context.read<ManagerServices>();
    var searchServices = context.read<SearchServices>();
    var interfaceServices = context.read<InterfaceServices>();

    // if (_searchKeywordController.text.isEmpty) {
    //   searchServices.resetNFTFilter(nftTagsMap);
    //
    // }

    final Widget nftInfoField = Consumer<ManagerServices>(
        builder: (context, model, child) {
          late double secondPartHeight = 0.0;
          late bool splitScreen = false;
          final int nftCount = model.treasuryNftsInfoSelected.bunch.length;
          final String collectionName = model.treasuryNftsInfoSelected.bunch.first.tag;
          if (model.treasuryNftsInfoSelected.bunch.first.tag != 'empty') {
            splitScreen = true;
          }
          secondPartHeight = 300;

          return AnimatedContainer(
            duration: splitDuration,
            height: splitScreen ? secondPartHeight : 0.0,
            color: Colors.grey[900],
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
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 24,
                                  color: Colors.white,
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
                                      style: DodaoTheme.of(context).bodyText1.override(
                                          fontFamily: 'Inter',
                                          color: Colors.white
                                      ),
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
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              collectionName,
                              style: DodaoTheme.of(context).bodyText1.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkResponse(
                            radius: 35,
                            containedInkWell: false  ,
                            onTap: () {
                              model.clearSelectedInManager();
                            },
                            child: const Icon(
                              Icons.arrow_downward,
                              size: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: secondPartHeight - 53,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: PageView.builder(
                        onPageChanged: (number) {
                          interfaceServices.treasuryPageCountUpdate(number + 1);
                        },
                        itemCount: nftCount,
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return PageViewTreasuryItem(
                            index: index,
                            item: model.treasuryNftsInfoSelected.bunch[index],
                            frameHeight: secondPartHeight,
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
        late final maxHeight = constraints.maxHeight - statusBarHeight - 84;
        // late double firstPartHeight = 0.0;
        // late double secondPartHeight = 0.0;
        // late bool splitScreen = false;
        // if (managerServices.treasuryNftSelected.tag != 'empty') {
        //   splitScreen = true;
        //   firstPartHeight = maxHeight / 2;
        //   secondPartHeight = firstPartHeight;
        // }
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(2, 6, 2, 2),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16.0, right: 12.0, left: 12.0),
                  height: 70,
                  child: Consumer<SearchServices>(
                      builder: (context, model, child) {
                        return TextFormField(
                          controller: _searchKeywordController,
                          onChanged: (searchKeyword) {
                            model.tagsNFTFilter(searchKeyword);
                          },
                          autofocus: false,
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
                            //         SimpleTags(collection: true, tag: _searchKeywordController.text, icon: "", selected: true);
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
                            labelStyle:  TextStyle(
                                fontSize: 17.0, color: Colors.grey[300]),
                            hintText: '[Enter nft name..]',
                            hintStyle: TextStyle(
                                fontSize: 14.0, color: Colors.grey[300]),
                          ),
                          style: DodaoTheme.of(context).bodyText1.override(
                            fontFamily: 'Inter',
                            color: Colors.grey[300]
                          ),
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
                      height: maxHeight,
                      alignment: Alignment.topLeft,
                      child:  Consumer<SearchServices>(
                          builder: (context, model, child) {
                            return Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: model.nftBalanceFilterResults.entries.map((e) {

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
                                      theme: 'black',
                                      item: e.value.bunch.first,
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
            )
        );
      }
    );
  }
}


class PageViewTreasuryItem extends StatelessWidget {
  final int index;
  final SimpleTags item;
  final double frameHeight;

  const PageViewTreasuryItem({
    Key? key,
    required this.index,
    required this.item,
    required this.frameHeight,
  }) : super(key: key);

  final EdgeInsets padding = const EdgeInsets.all(10.0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(

        elevation: 2,
        color: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: padding,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: frameHeight - 150,
                        filterQuality: FilterQuality.medium,
                        isAntiAlias: true,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: padding,
                    child: RichText(
                        text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                          fontWeight: FontWeight.w400

                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'NFT: ${item.tag}\n'),
                          TextSpan(text: 'Features: ${item.feature}\n'),
                          TextSpan(text: 'Rarity: ${item.nft}\n'),
                          TextSpan(text: 'Total supply: ${item.nft}\n'),
                          TextSpan(text: 'Issued by: ${item.nft}\n'),
                          const TextSpan(text: 'You own: 1\n'),
                        ]))
                  ),
                ],
              ),


              Container(
                padding: padding,
                child: GestureDetector(
                  onTap: () async {
                    Clipboard.setData(ClipboardData(text: '${item.tag}')).then((_) {
                      Flushbar(
                          icon: const Icon(
                            Icons.copy,
                            size: 20,
                            color: Colors.white,
                          ),
                          message: '${item.tag} copied to your clipboard!',
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.blueAccent,
                          shouldIconPulse: false)
                          .show(context);
                    });
                  },
                  child: RichText(
                      text: TextSpan(style: DodaoTheme.of(context).bodyText1.override(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      ),
                          children: [
                            const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                )),
                            TextSpan(text: 'Metadata url: ${item.tag}'),
                          ])),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
