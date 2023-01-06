import 'package:animations/animations.dart';
import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';



class TagCallButton extends StatelessWidget {
  const TagCallButton({Key? key, required this.page}) : super(key: key);
  final String page;

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 300),
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return Container(
          color: Colors.white,
            child: TagsPage(page: page)
        );
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
      openElevation: 2,
      openColor: Colors.white,
      closedColor: Colors.purpleAccent,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purple, Colors.purpleAccent],
              stops: [0.2, 0.7, 1],
              begin: AlignmentDirectional(1, -1),
              end: AlignmentDirectional(-1, 1),
            ),
          ),
          height: 56.0,
          width: 56.0,
          child: const Center(
            child: Icon(
              Icons.playlist_add_check_circle_outlined,
              size: 30,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

