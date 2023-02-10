import 'package:animations/animations.dart';
import 'package:devopsdao/widgets/tags/tag_mint_dialog.dart';
import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../flutter_flow/theme.dart';



class WrappedChip extends StatefulWidget {
  // static ValueNotifier<List<SimpleTags>> tags = ValueNotifier([]);
  final String theme;
  final bool nft;
  final String name;
  final VoidCallback? callback;
  final bool control;
  final bool interactive;
  final VoidCallback? onDeleted;
  final String page;
  const WrappedChip({Key? key,
    required this.theme,
    required this.nft,
    required this.name,
    required this.interactive,
    this.callback,
    required this.control,
    this.onDeleted, required this.page
  }) : super(key: key);

  @override
  _WrappedChipState createState() => _WrappedChipState();
}

class _WrappedChipState extends State<WrappedChip> with TickerProviderStateMixin {
late bool control = widget.control;
late bool initDone = false;

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutBack,
  );

  @override
  void initState() {
    super.initState();

    _controller.forward();

    // _runExpandCheck();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // TagsValueController tags = TagsValueController([]);
  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    final String theme = widget.theme;
    final bool nft = widget.nft;
    final String name = widget.name;
    final VoidCallback? callback = widget.callback;
    final bool interactive = widget.interactive;

    late bool getMore = false;
    if (name == 'Get more...') {
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
    }

    if (theme == 'small-white' || theme == 'small-black') {
      iconSize = 10;
      fontSize = 11;
      containerPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
      containerMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 2);
      rightSpanPadding = const EdgeInsets.only(right: 2.0);
      leftSpanPadding = const EdgeInsets.only(left: 2.0);
    }


    return ScaleTransition(
      scale: _animation,
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

          child: RichText(
            text: TextSpan(
              children: [
                if (interactive || nft)
                WidgetSpan(
                  child: Column(
                    children: [
                      if (!nft)
                      GestureDetector(
                        onTap: () {
                          showDialog(context: context, builder: (context) => TagMintDialog(tagName: widget.name));
                        },
                        child: Padding(
                          padding: rightSpanPadding,
                          child: Icon(
                              Icons.tag_rounded,
                              size: iconSize,
                              color:nftMintColor
                          ),
                        ),
                      ),
                      if (nft)
                      Padding(
                        padding: rightSpanPadding,
                        child: Icon(
                          Icons.star,
                          size: iconSize,
                          color:nftColor
                        ),
                      ),
                    ],
                  ),
                ),
                TextSpan(
                  text: name,
                  style: DodaoTheme.of(context).bodyText3.override(
                    fontFamily: 'Inter',
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
                ),
                if (interactive)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: control ? () {
                      _controller.reverse();
                      widget.onDeleted?.call();
                      Future.delayed(
                        const Duration(milliseconds: 750), () {
                          interface.removeTag(widget.name, page: widget.page, );
                      });
                    } : callback,
                    child: Padding(
                      padding: leftSpanPadding,
                      child: Icon(Icons.clear_rounded, size: iconSize, color: textColor),
                    ),
                  ),
                ),
                if (getMore)
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      _controller.reverse();
                      widget.onDeleted?.call();
                      Future.delayed(
                          const Duration(milliseconds: 750), () {
                        interface.removeTag(widget.name, page: widget.page, );
                      });
                    },
                    child: Padding(
                      padding: leftSpanPadding,
                      child: Icon(Icons.more_outlined, size: iconSize, color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}

