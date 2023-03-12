import 'package:animations/animations.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';
import 'main.dart';

class CreateCallButton extends StatelessWidget {
  const CreateCallButton({Key? key}) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 300),
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return const CreateJob();
        // return const _DetailsPage(
        //   includeMarkAsDoneButton: false,
        // );
      },
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      openElevation: 0,
      openColor: Colors.white,
      closedColor: DodaoTheme.of(context).maximumBlueGreen,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return SizedBox(
          height: 56.0,
          width: 56.0,
          child: Center(
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        );
      },
    );
  }
}
