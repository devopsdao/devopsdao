import 'package:dodao/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../blockchain/classes.dart';
import 'package:rive/rive.dart';
import '../../../blockchain/interface.dart';
import '../../model_view/task_model_view.dart';

class RateTask extends StatefulWidget {
  final Task task;
  final double innerPaddingWidth;
  const RateTask({
    Key? key,
    required this.task,
    required this.innerPaddingWidth,
  }) : super(key: key);

  @override
  State<RateTask> createState() => _RateTaskState();
}

class _RateTaskState extends State<RateTask> {

  bool showRateTaskSection = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var taskModelView = context.read<TaskModelView>();
      bool result = await taskModelView.onShowRateStars(widget.task);
      setState(() {
        showRateTaskSection = result;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    var taskModelView = context.read<TaskModelView>();

    final BoxDecoration materialMainBoxDecoration = BoxDecoration(
      borderRadius: DodaoTheme.of(context).borderRadius,
      border: DodaoTheme.of(context).borderGradient,
    );
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

      Shape star5Glow = artboard.component('Star_5_glow');
      (star5Glow.strokes.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateGlowAndSparks).value;

      Shape star4Glow = artboard.component('Star_4_glow');
      (star4Glow.strokes.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateGlowAndSparks).value;

      Shape star5Sparks = artboard.component('Star_5_sparks');
      (star5Sparks.strokes.first.children[0] as SolidColor).colorValue = (DodaoTheme.of(context).rateGlowAndSparks).value;

      artboard.forEachComponent((child) {
        if (child is Shape) {
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
      });

      final StateMachineController? controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
        onStateChange: (stateMachineName, animationName) {
          taskModelView.onUpdateRatingValue(rating!.value);
        },
      );

      artboard.addController(controller!);
      rating = controller.findInput<double>('Rating') as SMINumber;
    }

    return showRateTaskSection ? Container(
      padding: const EdgeInsets.only(top: 14.0),
      child: Material(
        elevation: DodaoTheme.of(context).elevation,
        borderRadius: DodaoTheme.of(context).borderRadius,
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            width: widget.innerPaddingWidth,
            decoration: materialMainBoxDecoration,
            child: Padding(
              padding: DodaoTheme.of(context).inputEdge,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: <TextSpan>[
                        TextSpan(text: 'Rate the task:', style: Theme.of(context).textTheme.bodySmall),
                      ])),
                  ),
                  SizedBox.fromSize(
                    size: const Size.fromHeight(56),
                    child: RiveAnimation.asset(
                      'assets/rive_animations/rating_animation.riv',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      onInit: _onRiveInit,
                    )),
                ],
              ),
            )
        ),
      ),
    ) : const SizedBox(height: 0,);
  }
}


