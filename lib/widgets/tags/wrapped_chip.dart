import 'dart:async';
import 'dart:math';

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
import '../../tags_manager/widgets/manager_open_container.dart';
import '../../tags_manager/manager_services.dart';
import '../my_tools.dart';
import '../tags_on_page_open_container.dart';
import 'main.dart';

enum WrapperRole {
  mint,
  treasure,
  getMore,
  selectNew,
  onPages,
  hash,
}

class WrappedChip extends StatefulWidget {
  // static ValueNotifier<List<SimpleTags>> tags = ValueNotifier([]);
  final String theme;
  final bool selected;
  final SimpleTags item;
  final String page;
  final bool startScale;
  final wrapperRole;
  final String animationCicle;
  final int tabIndex;
  const WrappedChip({Key? key,
    required this.theme,
    required this.selected,
    required this.item,
    required this.page,
    this.startScale = false,
    required this.wrapperRole,
    this.animationCicle = 'none',
    this.tabIndex = 0,
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

  late final AnimationController scaleEffectController;
  late final AnimationController expandEffectController;
  late Tween<double> chipSizeTween;
  late Animation<double> animationSize;
  late Tween<Color?> chipColorTween;
  late Tween<Color?> textColorTween;
  late Tween<Color?> borderColorTween;
  late Animation<Color?> animationTextColor;
  late Animation<Color?> animationColor;
  late Animation<Color?> animationBorderColor;
  late Tween<double> opacityTween;
  late Animation<double> animationOpacity;

  late  Animation<double> scaleEffect = CurvedAnimation(
    parent: scaleEffectController,
    curve: Curves.easeOutQuart,
  );
  late Animation<double> expandEffect = CurvedAnimation(
    parent: expandEffectController,
    curve: Curves.easeInOutQuart,
  );


  @override
  void initState() {
    super.initState();
    scaleEffectController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: 550),
    );
    expandEffectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var searchServices = context.read<SearchServices>();
    var managerServices = context.read<ManagerServices>();
    var tasksServices = context.read<TasksServices>();

    late String icon = 'none';
    late int numOfNFTs = 0;
    if (widget.item.nft && widget.page != 'mint') {  icon = 'nft'; }

    if (widget.page == 'treasury') {
      if (searchServices.nftFilterResults[widget.item.tag] != null) {
        if (searchServices.nftFilterResults[widget.item.tag]!.bunch.length > 1) {
          numOfNFTs = searchServices.nftFilterResults[widget.item.tag]!.bunch.length;
        }
      }
    }

    if (widget.theme == 'white') {
      textColor = Colors.black;
      borderColor = Colors.grey[400]!;
      bodyColor = Colors.white;
      nftColor = Colors.deepOrange;
      nftMintColor = Colors.white;

      textColorSelected = Colors.white;
      borderColorSelected = Colors.orangeAccent;
      bodyColorSelected = Colors.orangeAccent;
      nftColorSelected = Colors.white;
      nftMintColorSelected = Colors.white;
    } else if (widget.theme == 'black') {
      textColor = Colors.grey[300]!;
      borderColor = Colors.grey[850]!;
      bodyColor = Colors.grey[850]!;
      nftColor = Colors.deepOrange;
      nftMintColor = Colors.white;

      textColorSelected = Colors.white;
      borderColorSelected = Colors.orange[900]!;
      bodyColorSelected = Colors.orange[900]!;
      nftColorSelected = Colors.white;
      nftMintColorSelected = Colors.white;
    }

    // sizes
    late double iconSize = 17;
    late double fontSize = 14;
    late EdgeInsets containerPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 6);
    late EdgeInsets containerMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    late EdgeInsets rightSpanPadding = const EdgeInsets.only(right: 4.0);
    late EdgeInsets leftSpanPadding = const EdgeInsets.only(left: 4.0);

    var textSize = calcTextSize(widget.item.tag, DodaoTheme.of(context).bodyText3.override(
      fontFamily: 'Inter',
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    ));


    // // sizes for all states:
    // late double sizeTreasure = 22;
    // late double sizeTreasureExpanded = 44;
    // late double sizeMint = 0;
    // late double sizeMintExpanded = 22;
    // late double sizeSelectNew = 0;
    // late double sizeSelectNewExpanded = 44;
    // if (widget.item.nft) {
    //   sizeSelectNew += nftIconSize;
    // }
    // late double sizeGetMore = 22;
    // late double sizeOnPages = 0;
    // late double sizeHash = 0;
    late Color colorBodyBegin = bodyColor;
    late Color colorBodyEnd = bodyColor;
    late Color colorTextBegin = textColor;
    late Color colorTextEnd = textColor;
    late Color colorBorderBegin = borderColor;
    late Color colorBorderEnd = borderColor;
    late double opacityBegin = 0.0;
    late double opacityEnd = 1.0;

    final double tagWidthInit = textSize.width;
    late double sizeRegular = tagWidthInit;
    late double sizeExpanded = tagWidthInit;
    late double sizeBegin = 0;
    late double sizeEnd = 0;

    if (widget.wrapperRole == WrapperRole.treasure) {
      sizeRegular += 42;
      sizeExpanded += 58;
    } else if (widget.wrapperRole == WrapperRole.mint) {
      sizeRegular += 18;
      sizeExpanded += 36;
    } else if (widget.wrapperRole == WrapperRole.selectNew) {
      sizeRegular += 18;

      sizeExpanded += 36;
      if (widget.item.nft) {
        sizeRegular += 18;
        sizeExpanded += 18;
      }

    } else if (widget.wrapperRole == WrapperRole.getMore) {
      sizeRegular += 38;
      sizeExpanded += 38;
    } else if (widget.wrapperRole == WrapperRole.onPages) {
      sizeRegular += 18;
      sizeExpanded += 18;
      if (widget.item.nft) {
        sizeRegular += 18;
        sizeExpanded += 18;
      }
    } else if (widget.wrapperRole == WrapperRole.hash) {
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

      sizeBegin += sizeRegular;
      sizeEnd += sizeExpanded;

    } else if (widget.animationCicle == 'end') {
      // tagWidthInit += 12;
      // expandExtra = -12;
      // if (icon == 'extra_icon') {
      //   tagWidthInit += 22;
      //   expandExtra = -34;
      // }

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
    // if (widget.item.tag == 'JAVA') {
    //   print(textSize.width);
    //   print('animationCicle: ${widget.animationCicle} ${widget.item.tag} sizeBegin: $sizeBegin sizeEnd: $sizeEnd widget.wrapperRole: ${widget.wrapperRole}' );
    // }


    chipSizeTween = Tween(begin: sizeBegin, end: sizeEnd);
    animationSize = chipSizeTween.animate(expandEffect);

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
        if (widget.wrapperRole == WrapperRole.onPages) {
          scaleEffectController.reverse();
          Future.delayed(
              const Duration(milliseconds: 550), () {
            searchServices.removeTagOnTasksPages(widget.item.tag, page: widget.page, );

            if (widget.page == 'audit') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(taskList: tasksServices.tasksAuditPending,
                  tagsMap: searchServices.auditorTagsList, enteredKeyword: '', );
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(taskList: tasksServices.tasksAuditApplied,
                  tagsMap: searchServices.auditorTagsList, enteredKeyword: '', );
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(taskList: tasksServices.tasksAuditWorkingOn,
                  tagsMap: searchServices.auditorTagsList, enteredKeyword: '', );
              } else if (widget.tabIndex == 3) {
                tasksServices.runFilter(taskList: tasksServices.tasksAuditComplete,
                  tagsMap: searchServices.auditorTagsList, enteredKeyword: '', );
              }

            } else if (widget.page == 'tasks') {
              tasksServices.runFilter(
                  taskList: tasksServices.tasksNew,
                  tagsMap: searchServices.tasksTagsList,
                  enteredKeyword: '');
            } else if (widget.page == 'customer') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(taskList:tasksServices.tasksCustomerSelection,
                    tagsMap: searchServices.customerTagsList, enteredKeyword: '');
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(taskList:tasksServices.tasksCustomerProgress,
                    tagsMap: searchServices.customerTagsList, enteredKeyword: '');
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(taskList:tasksServices.tasksCustomerComplete,
                    tagsMap: searchServices.customerTagsList, enteredKeyword: '');
              }
            } else if (widget.page == 'performer') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(taskList: tasksServices.tasksPerformerParticipate,
                    tagsMap: searchServices.performerTagsList, enteredKeyword: '');
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(taskList: tasksServices.tasksPerformerProgress,
                    tagsMap: searchServices.performerTagsList, enteredKeyword: '');
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(taskList: tasksServices.tasksPerformerComplete,
                    tagsMap: searchServices.performerTagsList, enteredKeyword: '');
              }
            } else if (widget.page == 'customer') {
              if (widget.tabIndex == 0) {
                tasksServices.runFilter(
                    taskList: tasksServices.tasksCustomerSelection,
                    enteredKeyword: '',
                    tagsMap: searchServices.customerTagsList );
              } else if (widget.tabIndex == 1) {
                tasksServices.runFilter(
                    taskList: tasksServices.tasksCustomerProgress,
                    enteredKeyword: '',
                    tagsMap: searchServices.customerTagsList );
              } else if (widget.tabIndex == 2) {
                tasksServices.runFilter(
                    taskList: tasksServices.tasksCustomerComplete,
                    enteredKeyword: '',
                    tagsMap: searchServices.customerTagsList );
              }
            }
          });

        } else if(widget.page == 'selection') {
          searchServices.tagSelection(unselectAll: false, typeSelection: widget.page, tagName: widget.item.tag);
        } else if(widget.page == 'treasury') {
          searchServices.nftSelection(unselectAll: false, tagName: widget.item.tag);
          if (widget.animationCicle != 'remain' && widget.animationCicle != 'start') {
            managerServices.updateTreasuryNft(searchServices.nftFilterResults[widget.item.tag]!);
          } else {
            searchServices.nftSelection(unselectAll: true, tagName: '', );
            managerServices.clearSelectedInManager();
          }
        } else if (widget.page == 'mint') {
          searchServices.tagSelection( unselectAll: false, tagName: widget.item.tag, typeSelection: 'mint');
          if (widget.animationCicle != 'remain' && widget.animationCicle != 'start') {
            managerServices.updateMintNft(searchServices.tagsFilterResults[widget.item.tag]!);
          } else {
            searchServices.tagSelection(unselectAll: true, tagName: '', typeSelection: 'mint', );
            managerServices.clearSelectedInManager();
          }
        }
        // else if (widget.item.tag == ' #') {
        //   TagCallButton(
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
          return Container(
            width: animationSize.value,
            padding: containerPadding,
            margin: containerMargin,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              border: Border.all(
                  color: animationBorderColor.value!,
                  width: 1
              ),
              color: animationColor.value,
            ),
            child: Row(
                children: [
                  if (icon == 'extra_icon')
                    Flexible(
                      child: Opacity(
                        opacity: animationOpacity.value,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (context) {
                              return TagMintDialog(tagName: widget.item.tag);
                            });
                          },
                          child: Padding(
                            padding: rightSpanPadding,
                            child: Icon(
                                Icons.tag_rounded,
                                size: iconSize,
                                color: nftMintColor
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (icon == 'nft' && numOfNFTs < 1)
                  Flexible(
                    flex: 10,
                    child: Padding(
                      padding: rightSpanPadding,
                      child: Icon(
                          Icons.star,
                          size: iconSize,
                          color:nftColor
                      ),
                    ),
                  ),
                  if (widget.page == 'treasury' && numOfNFTs > 1)
                    Flexible(
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0, left: 3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: nftColor,
                              border: Border.all(
                                color: nftColor,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          width: 15,
                          height: 15,
                          // color: nftColor,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              numOfNFTs.toString(),
                              style: DodaoTheme.of(context).bodyText3.override(
                                fontFamily: 'Inter',
                                color: animationColor.value,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize - 4,
                              ),
                            ),
                          ),
                        )
                      ),
                    ),


                  // Gesture for TEXT field
                  if (
                        widget.wrapperRole != WrapperRole.getMore &&
                        widget.wrapperRole != WrapperRole.hash
                  )
                  GestureDetector(
                    onTap: onTapGesture,
                    child: Text(
                      widget.item.tag,
                      style: DodaoTheme.of(context).bodyText3.override(
                        fontFamily: 'Inter',
                        color: animationTextColor.value,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                  if (widget.wrapperRole == WrapperRole.getMore)
                    GetMore(
                      leftSpanPadding: leftSpanPadding,
                      iconSize: iconSize,
                      textColor: textColor, fontSize: fontSize,
                    ),
                  if (widget.wrapperRole == WrapperRole.hash)
                    OpenAddTags(
                      iconSize: iconSize,
                      textColor: textColor,
                      fontSize: fontSize,
                      page: widget.page,
                      tabIndex: widget.tabIndex,
                    ),

                  // Close button (will be not visible if item.selected false)
                  Flexible(
                    child: Opacity(
                      opacity: animationOpacity.value,
                      child: GestureDetector(
                        onTap: onTapGesture,
                        child: Padding(
                          padding: leftSpanPadding,
                          child: Icon(
                              Icons.clear_rounded,
                              size: iconSize,
                              color: textColorSelected
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          );
        }
      ),
    );
  }
}





class WrappedChipSmall extends StatelessWidget {
  // static ValueNotifier<List<SimpleTags>> tags = ValueNotifier([]);
  final String theme;
  final SimpleTags item;
  final String page;
  const WrappedChipSmall({Key? key,
    required this.theme,
    required this.item,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors (black BIG is default):
    late Color textColor = Colors.grey[300]!;
    late Color borderColor = Colors.grey[850]!;
    late Color bodyColor = Colors.grey[850]!;
    late Color nftColor = Colors.deepOrange;
    late Color nftMintColor = Colors.grey[600]!;


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

    var textSize = calcTextSize(item.tag, DodaoTheme.of(context).bodyText3.override(
      fontFamily: 'Inter',
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    ),);

    // tag width
    late double tagWidth = textSize.width + 22;
    late double tagWidthFull = tagWidth;
    if (item.nft) {
      tagWidthFull += 15;
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
              child: Text(
                item.tag,
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

