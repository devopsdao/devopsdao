import 'package:animations/animations.dart';
import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';



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

    // black BIG is default:

    late Color textColor = Colors.grey[300]!;
    late Color borderColor = Colors.grey[900]!;
    late Color bodyColor = Colors.grey[800]!;
    late Color nftColor = Colors.deepOrange;

    late double iconSize = 17;
    late double fontSize = 14;
    late EdgeInsets containerPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
    late EdgeInsets containerMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 4);
    late EdgeInsets spanPadding = const EdgeInsets.only(right: 8.0);


    if (theme == 'white') {
      textColor = Colors.black;
      borderColor = Colors.grey[400]!;
      bodyColor = Colors.transparent;
      nftColor = Colors.deepOrange;
    } else if (theme == 'small-white') {
      textColor = Colors.black;
      borderColor = Colors.grey[400]!;
      bodyColor = Colors.transparent;
      nftColor = Colors.deepOrange;
      iconSize = 10;
      fontSize = 11;
      containerPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 3);
      containerMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 4);
      spanPadding = const EdgeInsets.only(right: 4.0);
    }


    return GestureDetector(
      // onTap: callback,
      onTap: control ? () {
        _controller.reverse();
        widget.onDeleted?.call();
        Future.delayed(
          const Duration(milliseconds: 750), () {
            interface.removeTag(widget.name, page: widget.page, );


        });
      } : callback,





      child: ScaleTransition(
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
                  if (nft == true)
                    WidgetSpan(
                      child: Padding(
                        padding: spanPadding,
                        child: Icon(
                            Icons.star,
                            size: iconSize,
                            color:nftColor
                        ),
                      ),
                    ),
                  TextSpan(
                      text: name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize
                      )
                  ),
                  if (interactive)
                  WidgetSpan(
                    child: Padding(
                      padding: spanPadding,
                      child: Icon(Icons.clear_rounded, size: iconSize, color: textColor, ),
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}

