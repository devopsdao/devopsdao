import 'package:flutter/cupertino.dart';

import '../../blockchain/task.dart';

import 'package:rive/rive.dart';

class RateAnimatedWidget extends StatefulWidget {
  final Task? task;
  const RateAnimatedWidget({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  _RateAnimatedWidgetState createState() => _RateAnimatedWidgetState();
}

class _RateAnimatedWidgetState extends State<RateAnimatedWidget> {
  @override
  Widget build(BuildContext context) {

    SMINumber? rating;

    void _onRiveInit(Artboard artboard) {
      final StateMachineController? controller =
      StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
        // onStateChange: (stateMachineName, animationName) {
        //   print(stateMachineName);
        //   print(animationName);
        //   print(rating!.value);
        // },
      );
      artboard.addController(controller!);
      // rating = controller.findInput<double>('Rating') as SMINumber;
    }

    // void hitBump() => debugPrint("${rating!.value}");
    void hitBump() => print('test');
    return SizedBox.fromSize(
      // dimension: 200,
        size: const Size.fromHeight(60),
        // constraints: const BoxConstraints.expand(),
        child: GestureDetector(
          onTap: hitBump,
          child: RiveAnimation.asset(
            'assets/rive_animations/rating_animation.riv',
            fit: BoxFit.contain,
            alignment: Alignment.center,
            onInit: _onRiveInit,
          ),
        ));
  }
}