import 'package:animations/animations.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/theme.dart';
import 'main.dart';

class CreateCallButton extends StatelessWidget {
  const CreateCallButton({Key? key}) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 400),
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return const CreateJob();
        // return const _DetailsPage(
        //   includeMarkAsDoneButton: false,
        // );
      },
      closedElevation: 5,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      openElevation: 0,
      openColor: DodaoTheme.of(context).taskBackgroundColor,
      closedColor: DodaoTheme.of(context).createTaskButton,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: 56.0,
          width: 56.0,
          child: Center(
            child:  FaIcon(FontAwesomeIcons.pencil,
              color: DodaoTheme.of(context).primaryText,
            ),


            // Icon(
            //   Icons.pen,
            //   color: Theme.of(context).colorScheme.onSecondary,
            // ),
          ),
        );
      },
    );
  }
}
