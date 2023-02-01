import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/task.dart';
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


class TaskDialogFAB extends StatefulWidget {
  final String buttonName;
  final Color buttonColorRequired;
  final VoidCallback callback;
  final Task? task;
  final bool inactive;
  final double? padding;
  final bool expand;
  final double widthSize;
  const TaskDialogFAB(
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

  @override
  _TaskDialogFABState createState() => _TaskDialogFABState();
}

class _TaskDialogFABState extends State<TaskDialogFAB> with SingleTickerProviderStateMixin{
  late Color buttonColor;
  late Color textColor = Colors.white;
  late bool _buttonState = true;

  // late AnimationController expandController;
  // late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    // prepareAnimations();
    // _runExpandCheck();
  }

  // void prepareAnimations() {
  //   expandController = AnimationController(
  //       vsync: this,
  //       duration: const Duration(milliseconds: 200)
  //   );
  //   animation = CurvedAnimation(
  //     parent: expandController,
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }
  //
  // void _runExpandCheck() {
  //   if(widget.expand) {
  //     expandController.forward();
  //   }
  //   else {
  //     expandController.reverse();
  //   }
  // }
  //
  // @override
  // void didUpdateWidget(TaskDialogFAB oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // expandController.forward();
  //   _runExpandCheck();
  // }
  //
  // @override
  // void dispose() {
  //   expandController.dispose();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    // final Size widthTextSize = (TextPainter(
    //     text: TextSpan(
    //         text: widget.buttonName,
    //         style: TextStyle(fontSize: 18, color: textColor)),
    //     maxLines: 1,
    //     textScaleFactor: MediaQuery.of(context).textScaleFactor,
    //     textDirection: ui.TextDirection.ltr)
    //   ..layout())
    //     .size;
    buttonColor = widget.buttonColorRequired;

    if (widget.inactive == true) {
      textColor = Colors.white;
      buttonColor = Colors.blueGrey.shade200;
      _buttonState = false;
    } else {
      _buttonState = true;
    }

    // late double? padding = 10.0;
    // if (widget.padding != null) {
    //   padding = widget.padding;
    // }

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
    // onTap: _buttonState ? widget.callback : null,
    // Text(
    //   widget.buttonName,
    //   textAlign: TextAlign.center,
    //   style: TextStyle(fontSize: 18, color: textColor),
    // ),
    // return SizeTransition(
    //     // axisAlignment: 1.0,
    //     sizeFactor: animation,
    //     axis: Axis.vertical,
    //     child: SizedBox(
    //         width: widget.widthSize,
    //         child: Padding(
    //           padding: const EdgeInsets.all(11.0),
    //           child: child,
    //         )
    //     )
    // );


    // return AnimatedSize(
    //   duration: const Duration(milliseconds: 1150),
    //   curve: Curves.fastOutSlowIn,
    //   child: child,
    // );

    return AnimatedContainer(
      // color: Colors.amber,
      duration:  const Duration(milliseconds: 500),
      width:  widget.widthSize,
      child: child,
    );

    // return SizeTransition(
    //     axisAlignment: 1.0,
    //     sizeFactor: animation,
    //     child: child
    // );

    // return SizedBox(
    //   width: widget.widthSize,
    //     // child: widget.inactive ? child  : childWithAnimation
    //     // child: child
    //     child: childWithAnimation
    // );
  }
}


