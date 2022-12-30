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
  final VoidCallback? onDeleted;
  final String page;
  const WrappedChip({Key? key,
    required this.theme,
    required this.nft,
    required this.name,
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

  // void _runExpandCheck() {
  //   if(scaleout) {
  //     _controller.forward();
  //   }
  //   else {
  //     _controller.reverse();
  //   }
  // }
  //
  // @override
  // void didUpdateWidget(WrappedChip oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _runExpandCheck();
  // }


  @override
  void initState() {
    super.initState();

    _controller.forward();

    // _runExpandCheck();
  }

  @override
  void dispose() {
    // Provider.of<InterfaceServices>(context, listen: false);
    // var interface = context.watch<InterfaceServices>();
    // interface.removeTag(widget.name);
    // print('wow');
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

    late Color textColor;
    late Color borderColor;
    late Color bodyColor;
    late Color nftColor;



    if (theme == 'black') {
      textColor = Colors.grey[300]!;
      borderColor = Colors.grey[900]!;
      bodyColor = Colors.grey[800]!;
      nftColor = Colors.deepOrange;
    } else if (theme == 'white') {
      textColor = Colors.black;
      borderColor = Colors.grey[400]!;
      bodyColor = Colors.transparent;
      nftColor = Colors.deepOrange;
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),

              border: Border.all(
                  color: borderColor,
                  width: 1
              ),
              color: bodyColor!,
            ),

            child: RichText(
              text: TextSpan(
                children: [
                  if (nft == true)
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                            Icons.star,
                            size: 17,
                            color:nftColor
                        ),
                      ),
                    ),
                  TextSpan(
                      text: '${name}',
                      style: TextStyle(
                        color: textColor,
                      )
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.clear_rounded, size: 17, color: textColor, ),
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

