import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../blockchain/classes.dart';

class TagsFAB extends StatefulWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final SimpleTags? tags;
  final bool inactive;
  final double? padding;
  final bool expand;
  final double widthSize;
  const TagsFAB(
      {Key? key,
      required this.buttonName,
      required this.buttonColorRequired,
      required this.callback,
      required this.inactive,
      required this.widthSize,
      this.tags,
      this.padding,
      this.expand = false})
      : super(key: key);

  @override
  _TagsFABState createState() => _TagsFABState();
}

class _TagsFABState extends State<TagsFAB> with SingleTickerProviderStateMixin {
  late Color buttonColor;
  late Color textColor = Colors.white;
  late bool _buttonState = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buttonColor = widget.buttonColorRequired;

    if (widget.inactive == true) {
      textColor = Colors.white;
      buttonColor = Colors.blueGrey.shade200;
      _buttonState = false;
    } else {
      _buttonState = true;
    }

    late Widget child = FloatingActionButton.extended(
      onPressed: _buttonState ? widget.callback : null,
      backgroundColor: buttonColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17.0))),
      label: Text(
        widget.buttonName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: textColor),
      ),
    );

    return AnimatedContainer(
      // color: Colors.amber,
      duration: const Duration(milliseconds: 500),
      width: widget.widthSize,
      child: child,
    );
  }
}
