import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../flutter_flow/theme.dart';
import 'main.dart';



class GetMore extends StatelessWidget {
  final EdgeInsets leftSpanPadding;
  final double iconSize;
  final Color textColor;
  final double fontSize;

  const GetMore(
      {Key? key,
        required this.leftSpanPadding,
        required this.iconSize,
        required this.textColor,
        required this.fontSize,
      }) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 300),
      transitionType: _transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        // return Container(
        //     color: Colors.white,
        //     child: const TagManagerPage()
        // );
        return TagManagerPage();
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
          children: [
            Text(
              'Get more...',
              style: DodaoTheme.of(context).bodyText3.override(
                fontFamily: 'Inter',
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: fontSize,
              ),
            ),
            Padding(
              padding: leftSpanPadding,
              child: Icon(Icons.more_outlined, size: iconSize, color: textColor),
            ),
          ],
        );
      }
    );
  }
}



