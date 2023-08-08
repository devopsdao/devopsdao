import 'dart:async';
import 'dart:math';

import 'package:badges/badges.dart' as Badges;
import 'package:animations/animations.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:dodao/widgets/tags/tag_mint_dialog.dart';
import 'package:dodao/widgets/tags/tag_open_container.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../../tags_manager/nft_item.dart';
import '../../tags_manager/widgets/manager_open_container.dart';
import '../../tags_manager/collection_services.dart';
import '../my_tools.dart';
import '../tags_on_page_open_container.dart';
import 'main.dart';

enum WrapperRole {
  mint,
  treasure,
  getMore, // get more with link on home page
  selectNew, // add new tags on "add new Task"
  removeNew, // remove tags on "add new Task" page
  onPages, // select for search filter page
  onStartPage, // tag on home_page (not get more with link)
  hashButton, // button "+ tags" on pages
}

class WrappedChip extends StatefulWidget {
  // static ValueNotifier<List<TokenItem>> tags = ValueNotifier([]);
  final bool selected;
  final MapEntry<String, NftCollection> item;
  final String page;
  final bool startScale;
  final wrapperRole;
  final String animationCicle;
  final int tabIndex;
  // final Map<String, NftCollection> bunch;
  const WrappedChip({Key? key,
    required this.selected,
    required this.item,
    required this.page,
    this.startScale = false,
    required this.wrapperRole,
    this.animationCicle = 'none',
    this.tabIndex = 0,
    // this.bunch = const {},
  }) : super(key: key);

  @override
  _WrappedChipState createState() => _WrappedChipState();
}

class _WrappedChipState extends State<WrappedChip> with TickerProviderStateMixin {
  late Color textColor;
  late Color borderColor;
  late Color bodyColor;
  late Color nftColor;
  late Color nftMintColor;

  late Color textColorSelected;
  late Color borderColorSelected;
  late Color bodyColorSelected;
  late Color nftColorSelected;
  late Color nftMintColorSelected;

  final LinearGradient addTagButton = const LinearGradient(
    colors: [Color(0xffff9900),Colors.purpleAccent],
    stops: [0.1, 1],
  );

  late final AnimationController scaleEffectController;
  // late final AnimationController scaleMoreSpaceForButtonController;
  late final AnimationController expandEffectController;
  // late final AnimationController expandFastEffectController;
  late Tween<double> chipSizeTween;
  late Tween<double> moreSpaceForButtonTween;
  late Animation<double> animationSize;
  late Animation<double> moreSpaceForButtonAnimationSize;
  late Tween<Color?> chipColorTween;
  late Tween<Color?> textColorTween;
  late Tween<Color?> borderColorTween;
  late Animation<Color?> animationTextColor;
  late Animation<Color?> animationColor;
  late Animation<Color?> animationBorderColor;
  late Tween<double> opacityTween;
  late Animation<double> animationOpacity;

  // late  Animation<double> scaleMoreSpaceForButton = CurvedAnimation(
  //   parent: scaleMoreSpaceForButtonController,
  //   curve: Curves.easeOutQuart,
  // );
  late  Animation<double> scaleEffect = CurvedAnimation(
    parent: scaleEffectController,
    curve: Curves.easeOutQuart,
  );
  late Animation<double> expandEffect = CurvedAnimation(
    parent: expandEffectController,
    curve: Curves.easeInOutQuart,
  );
  // late Animation<double> expandFastEffect = CurvedAnimation(
  //   parent: expandFastEffectController,
  //   curve: Curves.easeInOutBack,
  // );



  @override
  void initState() {
    super.initState();
    scaleEffectController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: 550),
    );
    // scaleMoreSpaceForButtonController = AnimationController(
    //   vsync: this,
    //   value: 0.0,
    //   duration: const Duration(milliseconds: 250),
    // );
    expandEffectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    if (widget.animationCicle == 'end') {
      expandEffectController.forward();
    } else if (widget.animationCicle == 'start') {
      expandEffectController.forward();
    }

    if (widget.startScale) {
      scaleEffectController.forward();
    }
  }

  @override
  void dispose() {
    scaleEffectController.dispose();
    expandEffectController.dispose();
    // expandFastEffectController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var searchServices = context.read<SearchServices>();
    var collectionServices = context.read<CollectionServices>();
    var tasksServices = context.read<TasksServices>();

    late String icon = 'none';
    late int numOfNFTs = 0;
    final bool nft = widget.item.value.bunch.values.first.nft;
    final String tagName = widget.item.value.name;
    final String tagKey = widget.item.key;
    if (nft && widget.page != 'mint') {  icon = 'nft'; }

    // if (widget.page == 'selection') {
    //   if (searchServices.treasuryPageFilterResults[tagName] != null) {
    //     if (searchServices.treasuryPageFilterResults[tagName]!.bunch.length > 1) {
    //       numOfNFTs = searchServices.treasuryPageFilterResults[tagName]!.bunch.length;
    //     }
    //   }
    // }

    // if (widget.theme == 'white') {
    //   textColor = Colors.black;
    //   borderColor = Colors.grey[400]!;
    //   bodyColor = Colors.white;
    //   nftColor = Colors.deepOrange;
    //   nftMintColor = Colors.white;
    //
    //   textColorSelected = Colors.white;
    //   borderColorSelected = Colors.orangeAccent;
    //   bodyColorSelected = Colors.orangeAccent;
    //   nftColorSelected = Colors.white;
    //   nftMintColorSelected = Colors.white;
    // } else if (widget.theme == 'black') {
    //   textColor = Colors.grey[300]!;
    //   borderColor = Colors.grey[850]!;
    //   bodyColor = Colors.grey[850]!;
    //   nftColor = Colors.deepOrange;
    //   nftMintColor = Colors.white;
    //
    //   textColorSelected = Colors.white;
    //   borderColorSelected = Colors.orange[900]!;
    //   bodyColorSelected = Colors.orange[900]!;
    //   nftColorSelected = Colors.white;
    //   nftMintColorSelected = Colors.white;
    // }


    textColor = DodaoTheme.of(context).chipTextColor;
    borderColor = DodaoTheme.of(context).chipBorderColor;
    bodyColor = DodaoTheme.of(context).chipBodyColor;
    nftColor = DodaoTheme.of(context).chipNftColor;
    nftMintColor = DodaoTheme.of(context).chipNftMintColor;

    textColorSelected = Colors.white;
    borderColorSelected = DodaoTheme.of(context).chipSelectedColor;
    bodyColorSelected = DodaoTheme.of(context).chipSelectedColor;
    nftColorSelected = Colors.white;
    nftMintColorSelected = Colors.white;

    if (widget.item.value.bunch.values.first.inactive) {
      textColor = DodaoTheme.of(context).chipInactiveTextColor;
      borderColor = DodaoTheme.of(context).chipInactiveBorderColor;
      bodyColor = DodaoTheme.of(context).chipInactiveBodyColor;
      nftColor = DodaoTheme.of(context).chipInactiveNftColor;
    }


    // This will show overall count of NFTs in bunch
    if (widget.page == 'treasury' || widget.page == 'selection' || widget.page == 'filter') {
      if (widget.item.value.bunch.length > 1) {
        numOfNFTs = widget.item.value.bunch.length;
      }
    }

    // Only selected NFTs in bunch:
    if (widget.wrapperRole == WrapperRole.removeNew) {
      for (var e in widget.item.value.bunch.entries ) {
        if (e.value.selected) {
          numOfNFTs++;
        }
      }
    }

    late bool selectedNftAvailable = false;

    if (widget.page == 'selection') {
      if (widget.item.value.bunch.length > 1) {
        numOfNFTs = widget.item.value.bunch.length;
      }
      if (nft) {
        for (var e in widget.item.value.bunch.values) {
          if (e.selected) {
            print(e.selected);
            selectedNftAvailable = true;
            break;
          }
        }
        if (!selectedNftAvailable) {
          bodyColorSelected = DodaoTheme.of(context).chipBodyColor;
          textColorSelected = DodaoTheme.of(context).chipTextColor;
          nftMintColorSelected = DodaoTheme.of(context).chipNftColor;
          nftMintColor = DodaoTheme.of(context).chipNftColor;
          if (widget.selected) {
            nftColorSelected = DodaoTheme.of(context).chipNftColor;
          }
        }
      }
    }

    // sizes
    late double iconSize = 17;
    late double fontSize = 14;
    late double containerMainHeight = 28.0;
    late EdgeInsets containerMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    late EdgeInsets centerTextPadding = const EdgeInsets.only(left: 6.0, right: 6.0);
    if(!nft) {
      centerTextPadding = const EdgeInsets.only(left: 1.0, right: 6.0);
    }

    var textSize = calcTextSize(
      tagName == 'ETH' ? "${widget.item.value.bunch.values.first.balance}  ${tagName}" : tagName,
      DodaoTheme.of(context).bodyText3.override(
        fontFamily: 'Inter',
        color: textColor,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
      )
    );

    late Color colorBodyBegin = bodyColor;
    late Color colorBodyEnd = bodyColor;
    late Color colorTextBegin = textColor;
    late Color colorTextEnd = textColor;
    late Color colorBorderBegin = borderColor;
    late Color colorBorderEnd = borderColor;
    late double opacityBegin = 0.0;
    late double opacityEnd = 1.0;

    final double tagWidthInit = textSize.width + 10;
    late double sizeRegular = tagWidthInit;
    late double sizeExpanded = tagWidthInit;
    late double sizeBegin = 0;
    late double sizeEnd = 0;

    if (widget.wrapperRole == WrapperRole.treasure) {
      sizeRegular += 52;
      sizeExpanded += 68;
    } else if (widget.wrapperRole == WrapperRole.mint) {
      sizeRegular += 20;
      sizeExpanded += 36;

    } else if (widget.wrapperRole == WrapperRole.selectNew  || widget.wrapperRole == WrapperRole.removeNew) {
      sizeRegular += 24;
      sizeExpanded += 60;
      if (nft) {
        sizeRegular += 20;
        sizeExpanded += 20;
      } else if (numOfNFTs < 1) {
        sizeRegular += 0;
        sizeExpanded += 0;
      }
    } else if (widget.wrapperRole == WrapperRole.getMore) {
      sizeRegular += 38;
      sizeExpanded += 38;
    } else if (widget.wrapperRole == WrapperRole.onPages || widget.wrapperRole == WrapperRole.onStartPage) {
      sizeRegular += 18;
      sizeExpanded += 18;
      if (nft) {
        sizeRegular += 18;
        sizeExpanded += 18;
      }

    } else if (widget.wrapperRole == WrapperRole.hashButton) {
      sizeRegular += 30;
      sizeExpanded += 30;
    }

    if (widget.selected && (widget.animationCicle == 'remain' )) {
      textColor = textColorSelected;
      borderColor = borderColorSelected;
      bodyColor = bodyColorSelected;
      nftColor = nftColorSelected;
      nftMintColor = nftMintColorSelected;
      opacityBegin = 1.0;
      opacityEnd = 0.0;
      sizeBegin = sizeExpanded;
      sizeEnd = sizeRegular;
    } else if (widget.animationCicle == 'start') {
      nftColor = nftColorSelected;
      colorBodyBegin = bodyColor;
      colorBodyEnd = bodyColorSelected;
      colorTextBegin = textColor;
      colorTextEnd = textColorSelected;
      colorBorderBegin = borderColor;
      colorBorderEnd = borderColorSelected;
      // scaleMoreSpaceForButtonController.forward();
      sizeBegin += sizeRegular;
      sizeEnd += sizeExpanded;

    } else if (widget.animationCicle == 'end') {
      // tagWidthInit += 12;
      // expandExtra = -12;
      // if (icon == 'extra_icon') {
      //   tagWidthInit += 22;
      //   expandExtra = -34;
      // }
      // scaleMoreSpaceForButtonController.reverse();
      sizeBegin += sizeExpanded;
      sizeEnd += sizeRegular;

      colorBodyBegin = bodyColorSelected;
      colorBodyEnd = bodyColor;
      colorTextBegin = textColorSelected;
      colorTextEnd = textColor;
      colorBorderBegin = borderColorSelected;
      colorBorderEnd = borderColor ;
      opacityBegin = 1.0;
      opacityEnd = 0.0;


    } else if (widget.animationCicle == 'remain') {
      // if (icon == 'extra_icon') { tagWidthInit += 22; }
      // tagWidthInit += 12;
      sizeBegin += sizeRegular;
      sizeEnd += sizeRegular;

      opacityBegin = 1.0;
      opacityEnd = 0.0;


    } else if (widget.animationCicle == 'none') {
      sizeBegin += sizeRegular;
      sizeEnd += sizeExpanded;
    }


    chipSizeTween = Tween(begin: sizeBegin, end: sizeEnd);
    animationSize = chipSizeTween.animate(expandEffect);

    // moreSpaceForButtonTween = Tween(begin: sizeButtonBegin, end: sizeButtonEnd);
    // moreSpaceForButtonAnimationSize = moreSpaceForButtonTween.animate(expandFastEffect);

    opacityTween = Tween(begin: opacityBegin, end: opacityEnd);
    animationOpacity = opacityTween.animate(expandEffect);

    chipColorTween = ColorTween(begin: colorBodyBegin, end: colorBodyEnd);
    animationColor = chipColorTween.animate(expandEffect);

    textColorTween = ColorTween(begin: colorTextBegin, end: colorTextEnd);
    animationTextColor = textColorTween.animate(expandEffect);

    borderColorTween = ColorTween(begin: colorBorderBegin, end: colorBorderEnd);
    animationBorderColor = borderColorTween.animate(expandEffect);


    void onTapGesture() {
      setState(() {
        FocusManager.instance.primaryFocus?.unfocus();
        if (widget.wrapperRole == WrapperRole.onPages || widget.wrapperRole == WrapperRole.removeNew) {
          scaleEffectController.reverse();
          Future.delayed(
              const Duration(milliseconds: 550), () {
            searchServices.removeTagOnPages(tagKey, page: widget.page, );

            if (widget.page == 'audit') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(
                  taskList: tasksServices.tasksAuditPending,
                  tagsMap: searchServices.auditorTagsList,
                  enteredKeyword: searchServices.searchKeywordController.text, );
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(
                  taskList: tasksServices.tasksAuditApplied,
                  tagsMap: searchServices.auditorTagsList,
                  enteredKeyword: searchServices.searchKeywordController.text, );
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(
                  taskList: tasksServices.tasksAuditWorkingOn,
                  tagsMap: searchServices.auditorTagsList,
                  enteredKeyword: searchServices.searchKeywordController.text, );
              } else if (widget.tabIndex == 3) {
                tasksServices.runFilter(
                  taskList: tasksServices.tasksAuditComplete,
                  tagsMap: searchServices.auditorTagsList,
                  enteredKeyword: searchServices.searchKeywordController.text, );
              }

            } else if (widget.page == 'tasks') {
              tasksServices.runFilter(
                  taskList: tasksServices.tasksNew,
                  tagsMap: searchServices.tasksTagsList,
                  enteredKeyword: searchServices.searchKeywordController.text);
            } else if (widget.page == 'customer') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(
                    taskList:tasksServices.tasksCustomerSelection,
                    tagsMap: searchServices.customerTagsList,
                    enteredKeyword: searchServices.searchKeywordController.text);
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(
                    taskList:tasksServices.tasksCustomerProgress,
                    tagsMap: searchServices.customerTagsList,
                    enteredKeyword: searchServices.searchKeywordController.text);
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(
                    taskList:tasksServices.tasksCustomerComplete,
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
            } else if (widget.page == 'customer') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(
                    taskList: tasksServices.tasksCustomerSelection,
                    enteredKeyword: searchServices.searchKeywordController.text,
                    tagsMap: searchServices.customerTagsList );
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(
                    taskList: tasksServices.tasksCustomerProgress,
                    enteredKeyword: searchServices.searchKeywordController.text,
                    tagsMap: searchServices.customerTagsList );
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(
                    taskList: tasksServices.tasksCustomerComplete,
                    enteredKeyword: searchServices.searchKeywordController.text,
                    tagsMap: searchServices.customerTagsList );
              }
            }  else if (widget.page == 'create') {

            }
          });

        } else if(widget.page == 'selection') {
          if (!selectedNftAvailable && !nft) {
            searchServices.tagSelection(
                typeSelection: 'selection',
                tagName: tagName,
                tagKey: tagKey,
                unselectAll: false
            );
            collectionServices.clearSelectedInManager();
            // reset nft tags when regular tags tapped:
            searchServices.specialTagSelection(tagName: '', tagKey: '', unselectAll: true);
          } else {
            searchServices.specialTagSelection(tagName: tagName, tagKey: tagKey);

            if (!widget.selected) {
              collectionServices.updateTreasuryNft(
                  searchServices.selectionPageFilterResults[tagName]!
              );
            } else {
              collectionServices.clearSelectedInManager();
            }
          }
        } else if(widget.page == 'filter') {
          searchServices.tagSelection(
              typeSelection: 'selection',
              tagName: tagName,
              tagKey: tagKey,
              unselectAll: false
          );
          // collectionServices.clearSelectedInManager();
          // reset nft tags when regular tags tapped:
          // searchServices.specialTagSelection(tagName: '', tagKey: '');
        } else if(widget.page == 'treasury') {
          searchServices.tagSelection(unselectAll: false, tagName: tagName, typeSelection: 'treasury', tagKey: '');
          if (widget.animationCicle != 'remain' && widget.animationCicle != 'start') {
            collectionServices.updateTreasuryNft(searchServices.treasuryPageFilterResults[tagName]!);
          } else {
            searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'treasury', tagKey: '');
            collectionServices.clearSelectedInManager();
          }
        } else if (widget.page == 'mint') {
          searchServices.tagSelection( unselectAll: false, tagName: tagName, typeSelection: 'mint', tagKey: tagKey);
          if (widget.animationCicle != 'remain' && widget.animationCicle != 'start') {
            // collectionServices.updateMintNft(searchServices.mintPageFilterResults[tagName]!.bunch.values.first);
            collectionServices.updateMintNft(widget.item.value.bunch.values.first);
          } else {
            searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'mint', tagKey: tagKey, );
            collectionServices.clearSelectedInManager();
          }
        }
        // else if (widget.item.name == ' #') {
        //   TagOpenContainerButton(
        //     page: widget.page,
        //     tabIndex: widget.tabIndex,
        //   );
        // }
      });
    }

    return ScaleTransition(
      scale: scaleEffect,
      child: AnimatedBuilder(
        animation: animationSize,
        builder: (context, child) {
          return GestureDetector(
            onTap: onTapGesture,
            child: Container(
              width: widget.wrapperRole == WrapperRole.hashButton ? 74 : animationSize.value,

              margin: containerMargin,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(14.0),
                ),
                border: Border.all(
                    color: widget.wrapperRole == WrapperRole.hashButton ? DodaoTheme.of(context).background : animationBorderColor.value!,
                    width: 1
                ),
                gradient: widget.wrapperRole == WrapperRole.hashButton ? addTagButton : null,
                color: animationColor.value,
              ),
              child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mind !(true || true) --> false:
                    if (!(widget.wrapperRole == WrapperRole.selectNew || widget.wrapperRole == WrapperRole.removeNew))
                    Container(
                      width: 9,
                    ),
                    if (widget.wrapperRole == WrapperRole.selectNew  || widget.wrapperRole == WrapperRole.removeNew)
                    Flexible(
                      flex: 10,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        // widget.selected ? uses to ignore GestureDetector if item not selected:
                        onTap: widget.selected ? () {
                          // showDialog(context: context, builder: (context) {
                          //   return TagMintDialog(tagName: tagName);
                          // });
                          // NftItem(
                          //   item: widget.item,
                          //   frameHeight: 300,
                          // );
                          searchServices.specialTagSelection(tagName: '', tagKey: '', unselectAll: true);
                          collectionServices.updateTreasuryNft(searchServices.selectionPageFilterResults[tagKey]!);
                        } : null,
                        child: Opacity(
                          opacity: animationOpacity.value,
                          child: Container(
                            padding: const EdgeInsets.only(left: 0, right:5),
                            width: 25,
                            child: Icon(
                              shadows: const <Shadow>[Shadow(color: Colors.black26, blurRadius: 0.01, offset: Offset(0, 1))],
                              Icons.arrow_circle_up_rounded,
                              size: iconSize + 3,
                              color: nftMintColor
                            ),
                          ),
                        ),
                      ),
                    ),


                    if (icon == 'nft' && numOfNFTs < 1)
                      Flexible(
                        flex: 14,
                        child: Container(
                          padding: const EdgeInsets.only(left: 0, right: 6),
                          width: 17,
                          height: containerMainHeight,
                          child: Icon(
                              shadows: const <Shadow>[Shadow(color: Colors.black26, blurRadius: 0.01, offset: Offset(0, 1))],
                              Icons.star,
                              size: iconSize,
                              color:nftColor
                          ),
                        ),
                      ),
                    if ((
                        widget.page == 'treasury' || widget.page == 'selection' ||
                            widget.page == 'filter' || widget.page == 'create')
                        && (numOfNFTs > 1 ) || (nft && widget.page == 'create'))
                      Flexible(
                        flex: 15,
                        child: SizedBox(
                          height: containerMainHeight,
                          width: 18,
                          child: Badges.Badge(
                            badgeStyle: Badges.BadgeStyle(
                              badgeColor: nftColor,
                              elevation: 1,
                              shape: Badges.BadgeShape.circle,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            badgeAnimation: const Badges.BadgeAnimation.fade(
                              disappearanceFadeAnimationDuration: Duration(milliseconds: 300),
                              // curve: Curves.easeInCubic,
                            ),
                            // position: BadgePosition.topEnd(top: 10, end: 10),
                            badgeContent: Container(
                              // width: 8,
                              // height: 8,
                              alignment: Alignment.center,
                              child: Text(numOfNFTs.toString(), style: TextStyle(fontWeight: FontWeight.w700, color: animationColor.value, fontSize: 12)),
                            ),
                            // badgeColor: Colors.white,
                            // animationDuration: const Duration(milliseconds: 600),
                            // animationType: Badges.BadgeAnimationType.fade,
                            // child: Icon(Icons.settings),
                          ),


                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: nftColor,
                          //     border: Border.all(
                          //       color: nftColor,
                          //     ),
                          //     borderRadius: const BorderRadius.all(Radius.circular(12)),
                          //
                          //   ),
                          //   width: 15,
                          //   height: 15,
                          //   // color: nftColor,
                          //   child: Align(
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       numOfNFTs.toString(),
                          //       style: DodaoTheme.of(context).bodyText3.override(
                          //         fontFamily: 'Inter',
                          //         color: animationColor.value,
                          //         fontWeight: FontWeight.w700,
                          //         fontSize: fontSize - 4,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    if (
                          widget.wrapperRole != WrapperRole.getMore &&
                          widget.wrapperRole != WrapperRole.hashButton
                    )
                    Container(
                      alignment: Alignment.center,
                      height: containerMainHeight,
                      child: Padding(
                        padding: centerTextPadding,
                        child: Text(

                          tagName == 'ETH' ? "${widget.item.value.bunch.values.first.balance}  ${tagName}" : tagName,
                          style: DodaoTheme.of(context).bodyText3.override(
                            fontFamily: 'Inter',
                            color: animationTextColor.value,
                            fontWeight: FontWeight.w400,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ),
                    if (widget.wrapperRole == WrapperRole.getMore)
                      SizedBox(
                        height: containerMainHeight,
                        child: GetMore(
                          leftSpanPadding: centerTextPadding,
                          iconSize: iconSize,
                          textColor: textColor, fontSize: fontSize,
                        ),
                      ),
                    if (widget.wrapperRole == WrapperRole.hashButton)
                      SizedBox(
                          height: containerMainHeight,
                          child: OpenAddTags(
                            fontSize: fontSize,
                            page: widget.page,
                            tabIndex: widget.tabIndex,
                          ),
                        ),

                    // Close button (will be not visible if item.selected false)
                    Flexible(
                      flex: 3,
                      child: Opacity(
                        opacity: animationOpacity.value,
                        child: Icon(
                            shadows: const <Shadow>[Shadow(color: Colors.black26, blurRadius: 0.01, offset: Offset(0, 1))],
                            Icons.clear_rounded,
                            size: iconSize,
                            color: textColorSelected
                        ),
                      ),
                    ),
                    Container(
                      width: 7,
                    )
                  ],
                ),
            ),
          );
        }
      ),
    );
  }
}

class WrappedChipSmall extends StatelessWidget {
  // static ValueNotifier<List<TokenItem>> tags = ValueNotifier([]);
  final String theme;
  final TokenItem item;
  final String page;
  const WrappedChipSmall({Key? key,
    required this.theme,
    required this.item,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors (black BIG is default):
    late Color textColor = DodaoTheme.of(context).chipTextColor;
    late Color borderColor = DodaoTheme.of(context).chipBorderColor;
    late Color bodyColor = DodaoTheme.of(context).chipBodyColor;
    late Color nftColor = DodaoTheme.of(context).chipNftColor;

    if (item.inactive) {
      textColor = DodaoTheme.of(context).chipInactiveTextColor;
      borderColor = DodaoTheme.of(context).chipInactiveBorderColor;
      bodyColor = DodaoTheme.of(context).chipInactiveBodyColor;
      nftColor = DodaoTheme.of(context).chipInactiveNftColor;
    }


    if (theme == 'small-white') {
      textColor = Colors.black;
      borderColor = Colors.grey[400]!;
      bodyColor = Colors.transparent;
      nftColor = Colors.deepOrange;
    }

    late double iconSize = 10;
    late double fontSize = 11;
    late EdgeInsets containerPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
    late EdgeInsets containerMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 2);
    late EdgeInsets rightSpanPadding = const EdgeInsets.only(right: 2.0);
    late EdgeInsets leftSpanPadding = const EdgeInsets.only(left: 2.0);

    var textSize = calcTextSize(
      item.name == 'ETH' ? "${item.balance}  ${item.name}" : item.name,
      DodaoTheme.of(context).bodyText3.override(
      fontFamily: 'Inter',
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    ),);

    // tag width
    late double tagWidth = textSize.width + 22;
    late double tagWidthFull = tagWidth;
    if (item.nft) {
      tagWidthFull += 20;
    }

    return Container(
      width: tagWidthFull,
      padding: containerPadding,
      margin: containerMargin,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        border: Border.all(
            color: borderColor,
            width: 1
        ),
        color: bodyColor,
      ),
      child: Row(
        children: [
          if (item.nft)
          Flexible(
            flex: 3,
            child: Padding(
              padding: rightSpanPadding,
              child: Icon(
                  Icons.star,
                  size: iconSize,
                  color:nftColor
              ),
            ),
          ),

          Flexible(
            flex: 7,
            child: Container(
              width: tagWidth,
              alignment: Alignment.center,
              child:  Text(
                item.name == 'ETH' ? "${item.balance}  ${item.name}" : item.name,
                style: DodaoTheme.of(context).bodyText3.override(
                  fontFamily: 'Inter',
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

