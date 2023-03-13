import 'package:animations/animations.dart';
import 'package:devopsdao/widgets/tags/main.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../main.dart';



class OpenAddTags extends StatelessWidget {
  final double iconSize;
  final Color textColor;
  final double fontSize;
  final String page;
  final int tabIndex;

  const OpenAddTags(
      {Key? key,
        required this.iconSize,
        required this.textColor,
        required this.fontSize, required this.page, required this.tabIndex
      }) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 400),
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return Container(
            color: Colors.white,
            child: MainTagsPage(page: page, tabIndex: tabIndex)
        );
      },
      closedElevation: 0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(1.0),
        ),
      ),
      openElevation: 2,
      openColor: Colors.transparent,
      closedColor: Colors.transparent,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 4.0, right: 4.0),
              child: Icon(Icons.add, color: Colors.white, size: 16,),
            )
          ],
        );
      }
    );
  }
}



