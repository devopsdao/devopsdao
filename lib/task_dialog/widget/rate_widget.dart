import 'package:dodao/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/classes.dart';

import 'package:rive/rive.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';

class RateAnimatedWidget extends StatefulWidget {
  final Task? task;
  const RateAnimatedWidget({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  _RateAnimatedWidgetState createState() => _RateAnimatedWidgetState();
}

double ratingNum = 0;


class _RateAnimatedWidgetState extends State<RateAnimatedWidget> {

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();

    SMINumber? rating;

    void _onRiveInit(Artboard artboard) {
      Shape starBase1 = artboard.component('Star_base_1');
      starBase1.strokes.first.paint.color = DodaoTheme.of(context).rateStroke;
      starBase1.fills.first.paint.color = DodaoTheme.of(context).rateBody;
      starBase1.strokes.first.thickness = 1;

      Shape starBase2 = artboard.component('Star_base_2');
      starBase2.strokes.first.paint.color = DodaoTheme.of(context).rateStroke;
      starBase2.fills.first.paint.color = DodaoTheme.of(context).rateBody;
      starBase2.strokes.first.thickness = 1;

      Shape starBase3 = artboard.component('Star_base_3');
      starBase3.strokes.first.paint.color = DodaoTheme.of(context).rateStroke;
      starBase3.fills.first.paint.color = DodaoTheme.of(context).rateBody;
      starBase3.strokes.first.thickness = 1;

      Shape starBase4 = artboard.component('Star_base_4');
      starBase4.strokes.first.paint.color = DodaoTheme.of(context).rateStroke;
      starBase4.fills.first.paint.color = DodaoTheme.of(context).rateBody;
      starBase4.strokes.first.thickness = 1;

      Shape starBase5 = artboard.component('Star_base_5');
      starBase5.strokes.first.paint.color = DodaoTheme.of(context).rateStroke;
      starBase5.fills.first.paint.color = DodaoTheme.of(context).rateBody;
      starBase5.strokes.first.thickness = 1;

      // Shape star1 = artboard.component('Star_1');
      // // star1.strokes.first.paint.color = Colors.red;
      // (star1.fills.first.children[0] as SolidColor).colorValue = (Colors.yellow).value;
      //
      // Shape star2 = artboard.component('Star_2');
      // // star2.strokes.first.paint.color = Colors.red;
      // (star2.fills.first.children[0] as SolidColor).colorValue = (Colors.yellow).value;

      Shape star5Glow = artboard.component('Star_5_glow');
      (star5Glow.strokes.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateGlowAndSparks).value;

      Shape star4Glow = artboard.component('Star_4_glow');
      (star4Glow.strokes.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateGlowAndSparks).value;

      Shape star5Sparks = artboard.component('Star_5_sparks');
      (star5Sparks.strokes.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateGlowAndSparks).value;

      // Shape star4 = artboard.component('Star_4');
      // // star4.strokes.first.paint.color = Colors.red;
      // (star4.fills.first.children[0] as SolidColor).colorValue = (Colors.yellow).value;
      //
      // Shape star5 = artboard.component('Star_5');
      // // star5.strokes.first.paint.color = Colors.red;
      // (star5.fills.first.children[0] as SolidColor).colorValue = (Colors.yellow).value;


      artboard.forEachComponent((child) {
        if (child is Shape) {
          // if (child.name == 'Star_base_4') {
          //   final Shape shape = child;
          //   shape.strokes.first.paint.color = Colors.green;
          //   shape.fills.first.paint.color = Colors.red;
          // }
          if (child.name == 'Star_1') {
            (child.fills.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateBodySelected).value;
          }
          if (child.name == 'Star_2') {
            (child.fills.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateBodySelected).value;
          }
          if (child.name == 'Star_3') {
            (child.fills.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateBodySelected).value;
          }
          if (child.name == 'Star_4') {
            (child.fills.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateBodySelected).value;
          }
          if (child.name == 'Star_5') {
            (child.fills.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateBodySelected).value;
          }
        }



        // if (child is Shape) {
        //   print(child);
        //   // final Shape shape = child;
        //   // for (var e in shape.fills ) {
        //   //   // e.paint.color  = Colors.red;
        //   // }
        //   // // shape.strokes.first.paint.color = Colors.green;
        //   //
        //   // shape.fills.first.paint.color = Colors.red;
        //   // shape.fills.first.paint.;
        // }

        // if (child is Shape) {
        //   final Shape shape = child;
        //
        //   print(shape);
        //   // shape.fills.first.paint.color = Colors.red;
        // }
      });

      final StateMachineController? controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
        onStateChange: (stateMachineName, animationName) {
          // print(stateMachineName);
          // print(animationName);
          // print(rating!.value);
          ratingNum = rating!.value;
        },
      );

      artboard.addController(controller!);
      rating = controller.findInput<double>('Rating') as SMINumber;
      // print(controller.findInput<double>('Rating')!.value);
    }
    // void hitBump() => debugPrint("${rating?.value}");



    // void hitBump() => print(this);
    return SizedBox.fromSize(
      // dimension: 200,
        size: const Size.fromHeight(56),
        // constraints: const BoxConstraints.expand(),
        child: GestureDetector(
          onTap: () {
            interface.updateRatingValue(ratingNum);
            // print(ratingNum);
          },
          child: RiveAnimation.asset(
              'assets/rive_animations/rating_animation.riv',
            fit: BoxFit.contain,
            alignment: Alignment.center,
            onInit: _onRiveInit,
            // artboard: 'new',

          ),
        ));
  }
}




