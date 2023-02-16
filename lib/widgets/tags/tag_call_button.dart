import 'package:animations/animations.dart';
import 'package:devopsdao/widgets/tags/tags.dart';
import 'package:flutter/material.dart';

import 'main.dart';



class TagCallButton extends StatelessWidget {
  const TagCallButton({Key? key, required this.page}) : super(key: key);
  final String page;

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {

    if (page != 'create') {


      return OpenContainer(
        transitionDuration: const Duration(milliseconds: 300),
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return Container(
              color: Colors.white,
              child: MainTagsPage(page: page)
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
    } else {


      return Material(
        elevation: 9,
        borderRadius: BorderRadius.circular(6),
        color: Colors.lightBlue.shade600,
        child: OpenContainer(
          transitionDuration: const Duration(milliseconds: 500),
          transitionType: _transitionType,
          openBuilder: (BuildContext context, VoidCallback _) {
            return Container(
                color: Colors.white,
                child: TagsPage(page: page)
            );
          },
          closedElevation: 0,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            ),
          ),
          openElevation: 2,
          openColor: Colors.white,

          closedColor: Colors.lightBlue.shade600,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return InkWell(
              // onTap: _buttonState ? widget.callback : null,
              child: Container(
                padding: const EdgeInsets.all(8),
                // height: 40.0,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Tags',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
              ),
            );
          },
        )
      );
    }
  }
}



