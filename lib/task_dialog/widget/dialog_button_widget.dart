import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import 'dart:ui' as ui;

class TaskDialogButton extends StatefulWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final Task? task;
  final bool inactive;
  final double? padding;
  final bool animate;
  const TaskDialogButton(
      {Key? key,
        required this.buttonName,
        required this.buttonColorRequired,
        required this.callback,
        required this.inactive,
        this.task,
        this.padding,
        this.animate = false})
      : super(key: key);

  @override
  _TaskDialogButtonState createState() => _TaskDialogButtonState();
}

class _TaskDialogButtonState extends State<TaskDialogButton> with SingleTickerProviderStateMixin{
  late Color buttonColor;
  late Color textColor = Colors.white;
  late bool _buttonState = true;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 450),
    vsync: this,
    value: 0.0,
    lowerBound: 0.0,
    upperBound: 1.0
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    _controller.forward();
    // Future.delayed(
    //   const Duration(milliseconds: 250),
    //     () { });
  }



  @override
  Widget build(BuildContext context) {
    final Size widthTextSize = (TextPainter(
        text: TextSpan(
            text: widget.buttonName,
            style: TextStyle(fontSize: 18, color: textColor)),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: ui.TextDirection.ltr)
      ..layout())
        .size;
    buttonColor = widget.buttonColorRequired;

    if (widget.inactive == true) {
      textColor = Colors.white;
      buttonColor = Colors.grey;
      _buttonState = false;
    } else {
      _buttonState = true;
    }

    // // this check for WITHDRAW button:
    // if (widget.task != null) {
    //   if (widget.task!.contractValue != 0) {
    //     _buttonState = true;
    //   } else if (widget.task!.contractValueToken != 0) {
    //     if (widget.task!.contractValueToken > tasksServices.transferFee ||
    //         tasksServices.destinationChain == 'Moonbase') {
    //       _buttonState = true;
    //     } else {
    //       textColor = Colors.white;
    //       buttonColor = Colors.grey;
    //       _buttonState = false;
    //     }
    //   }
    // }

    late double? padding = 10.0;
    if (widget.padding != null) {
      padding = widget.padding;
    }

    late Widget child = Container(
      width: widthTextSize.width + 100,
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 9,
        borderRadius: BorderRadius.circular(6),
        color: buttonColor,
        child: InkWell(
          onTap: _buttonState ? widget.callback : null,
          child: Container(
            padding: EdgeInsets.all(padding!),
            // height: 40.0,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.buttonName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
          ),
        ),
      ),
    );

    late Widget childWithAnimation = ScaleTransition(
      scale: _animation,
      child: child
    );

    return Expanded(
      child: widget.inactive ? child  : childWithAnimation
    );
  }
}


class TaskDialogFAB extends StatelessWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final Task? task;
  final bool inactive;
  final double? padding;
  final bool expand;
  final double widthSize;
  TaskDialogFAB(
      {Key? key,
        required this.buttonName,
        required this.buttonColorRequired,
        required this.callback,
        required this.inactive,
        required this.widthSize,
        this.task,
        this.padding,
        this.expand = false})
      : super(key: key);

  late Color buttonColor;

  late Color textColor = Colors.white;

  late bool _buttonState = true;

  @override
  Widget build(BuildContext context) {
    buttonColor = buttonColorRequired;

    if (inactive == true) {
      textColor = Colors.white;
      buttonColor = Colors.blueGrey.shade200;
      _buttonState = false;
    } else {
      _buttonState = true;
    }

    late Widget child = FloatingActionButton.extended(
      onPressed: _buttonState ? callback : null,
      backgroundColor: buttonColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17.0))),
      label: Text(
        buttonName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: textColor),
      ),
    );

    return AnimatedContainer(
      duration:  const Duration(milliseconds: 500),
      width:  widthSize,
      child: child,
    );
  }
}

class TaskDialogConnectWallet extends StatefulWidget {
  final String buttonName;
  final VoidCallback callback;
  final double widthSize;
  const TaskDialogConnectWallet(
      {Key? key,
        required this.buttonName,
        required this.callback,
        required this.widthSize,})
      : super(key: key);

  @override
  _TaskDialogConnectWalletState createState() => _TaskDialogConnectWalletState();
}

class _TaskDialogConnectWalletState extends State<TaskDialogConnectWallet> with SingleTickerProviderStateMixin{
  late Color buttonColor;
  late Color textColor = Colors.white;
  late bool _buttonState = true;


  @override
  Widget build(BuildContext context) {

    late Widget child = Container(
      decoration: BoxDecoration(
        // shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(17.0)),
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepOrangeAccent, Color(0xfffadb00)],
            stops: [0.1, 0.5, 1],
          )
      ),
      child: FloatingActionButton.extended(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: _buttonState ? widget.callback : null,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(17.0))),
        label: Text(
          widget.buttonName,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: textColor),
        ),
      ),
    );

    return AnimatedContainer(
      duration:  const Duration(milliseconds: 500),
      width:  widget.widthSize,
      child: child,
    );
  }
}


