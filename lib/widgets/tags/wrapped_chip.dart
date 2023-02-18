import 'package:animations/animations.dart';
import 'package:devopsdao/widgets/tags/search_services.dart';
import 'package:devopsdao/widgets/tags/tag_mint_dialog.dart';
import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../flutter_flow/theme.dart';
import '../my_tools.dart';
import 'main.dart';



class WrappedChip extends StatefulWidget {
  // static ValueNotifier<List<SimpleTags>> tags = ValueNotifier([]);
  final String theme;
  final SimpleTags item;
  final VoidCallback? callback;
  final bool delete;
  final bool interactive;
  final VoidCallback? onDeleted;
  final String page;
  final bool animation;
  final bool mint;
  const WrappedChip({Key? key,
    required this.theme,
    required this.item,
    required this.interactive,
    this.callback,
    required this.delete,
    this.onDeleted,
    required this.page,
    this.animation = false,
    this.mint = false
  }) : super(key: key);

  @override
  _WrappedChipState createState() => _WrappedChipState();
}

class _WrappedChipState extends State<WrappedChip> with TickerProviderStateMixin {
late bool initDone = false;

  late final AnimationController _controller = AnimationController(
      duration:  const Duration(
          milliseconds: 450
      ),
      vsync: this,
      value: 1.0,
      lowerBound: 0.0,
      upperBound: 1.0
  );
  late final AnimationController _expandEffectController = AnimationController(
      duration:  const Duration(
          milliseconds:  450
      ),
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCirc,
  );
  late final Animation<double> _expandEffect = CurvedAnimation(
    parent: _expandEffectController,
    curve: Curves.easeInCirc,
  );

  @override
  void initState() {
    super.initState();
    if (widget.animation) {
      _controller.forward();
    }
    if (widget.item.selected) {
      _expandEffectController.forward();
    }
    // _runExpandCheck();
  }

  @override
  void dispose() {
    _controller.dispose();
    _expandEffectController.dispose();
    super.dispose();
  }

  // TagsValueController tags = TagsValueController([]);
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var searchServices = context.watch<SearchServices>();
    final String theme = widget.theme;
    final SimpleTags item = widget.item;
    final VoidCallback? callback = widget.callback;
    late bool interactive = widget.interactive;

    final nft = widget.item.nft ?? false;



    late bool getMore = false;
    if (item.tag == 'Get more...') {
      getMore = true;
    }

    // Colors (black BIG is default):
    late Color textColor = Colors.grey[300]!;
    late Color borderColor = Colors.grey[900]!;
    late Color bodyColor = Colors.grey[800]!;
    late Color nftColor = Colors.deepOrange;
    late Color nftMintColor = Colors.grey[600]!;



    // sizes of Tags (black BIG is default):
    late double iconSize = 17;
    late double fontSize = 14;
    late EdgeInsets containerPadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 6);
    late EdgeInsets containerMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    late EdgeInsets rightSpanPadding = const EdgeInsets.only(right: 4.0);
    late EdgeInsets leftSpanPadding = const EdgeInsets.only(left: 4.0);



    if (theme == 'white' || theme == 'small-white') {
      textColor = Colors.black;
      borderColor = Colors.grey[400]!;
      bodyColor = Colors.transparent;
      nftColor = Colors.deepOrange;
      // Colors for selected items:

      if (item.selected) {
        interactive = true;
        textColor = Colors.white;
        borderColor = Colors.orangeAccent;
        bodyColor = Colors.orangeAccent;
        nftColor = Colors.white;
        nftMintColor = Colors.white;
      }
    }

    if (theme == 'small-white' || theme == 'small-black') {
      iconSize = 10;
      fontSize = 11;
      containerPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
      containerMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 2);
      rightSpanPadding = const EdgeInsets.only(right: 2.0);
      leftSpanPadding = const EdgeInsets.only(left: 2.0);
    }

    var textSize = calcTextSize(item.tag, DodaoTheme.of(context).bodyText3.override(
      fontFamily: 'Inter',
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    ),);

    // tag width
    late double tagWidth = textSize.width + 22;
    if (item.selected && widget.delete) {
      tagWidth += 22;
    }
    if (widget.mint && item.selected) {
      tagWidth += 42;
    }
    if (nft && !item.selected) {
      tagWidth += 22;
    }
    if (nft && widget.delete) {
      tagWidth += 22;
    }
    // if () {
    //
    // }


    return ScaleTransition(
      scale: _animation,
      child: AnimatedContainer(
        width: tagWidth,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds:  350),
        child: Container(
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
                  if (widget.mint && !nft)
                    Flexible(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds:  400),
                        opacity: item.selected ? 1.0 : 0.0,
                        curve: Curves.easeInQuad,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (context) {
                              return TagMintDialog(tagName: item.tag);
                            });
                          },
                          child: AnimatedContainer(
                            width: item.selected ? iconSize + 4 : 0,
                            // height: item.selected ? 100.0 : 200.0,
                            // color: bodyColor,
                            curve: Curves.fastOutSlowIn,
                            duration: const Duration(milliseconds:  350),
                            child: Padding(
                              padding: rightSpanPadding,
                              child: Icon(
                                  Icons.tag_rounded,
                                  size: item.selected ? iconSize : 0,
                                  color: nftMintColor
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (nft)
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

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.delete) {
                          _controller.reverse();
                          widget.onDeleted?.call();
                          Future.delayed(
                              const Duration(milliseconds: 750), () {
                            searchServices.removeTag(item.tag, page: widget.page, );
                          });
                        } else {
                          for (String key in searchServices.tagsFilterResults.keys) {
                            if (searchServices.tagsFilterResults[key]?.tag.toLowerCase() ==
                                item.tag.toLowerCase()) {
                              searchServices.tagsFilterResults[key]!.selected ?
                              searchServices.tagsFilterResults[key]!.selected = false :
                              searchServices.tagsFilterResults[key]!.selected = true;
                            }
                          }
                        }
                      });
                      // if (item.selected) {
                      //   _expandEffectController.forward();
                      //   Future.delayed(
                      //       const Duration(milliseconds: 350), () {
                      //
                      //   });
                      // } else {
                      //   _expandEffectController.reverse();
                      // }
                    },
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


                  Flexible(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds:  400),
                      opacity: item.selected ? 1.0 : 0.0,
                      curve: Curves.easeInQuad,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.delete) {
                              _controller.reverse();
                              widget.onDeleted?.call();
                              Future.delayed(
                                  const Duration(milliseconds: 750), () {
                                searchServices.removeTag(item.tag, page: widget.page, );
                              });
                            } else {
                              for (String key in searchServices.tagsFilterResults.keys) {
                                if (searchServices.tagsFilterResults[key]?.tag.toLowerCase() ==
                                    item.tag.toLowerCase()) {
                                  searchServices.tagsFilterResults[key]!.selected ?
                                  searchServices.tagsFilterResults[key]!.selected = false :
                                  searchServices.tagsFilterResults[key]!.selected = true;
                                }
                              }
                            }
                          });
                          // if (item.selected) {
                          //   _expandEffectController.forward();
                          //   Future.delayed(
                          //       const Duration(milliseconds: 350), () {
                          //
                          //   });
                          // } else {
                          //   _expandEffectController.reverse();
                          // }
                        },
                        child: Padding(
                          padding: item.selected ? leftSpanPadding :const EdgeInsets.only(left: 0),
                          child: Icon(Icons.clear_rounded, size: item.selected ? iconSize : 0, color: textColor),
                        ),
                      ),
                    ),
                  ),
                  if (getMore)
                    Flexible(
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Padding(
                        padding: leftSpanPadding,
                        child: Icon(Icons.more_outlined, size: iconSize, color: textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}

