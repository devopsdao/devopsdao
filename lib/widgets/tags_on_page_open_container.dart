import 'package:animations/animations.dart';
import 'package:dodao/widgets/tags/main.dart';
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../main.dart';



class OpenAddTags extends StatelessWidget {
  final double fontSize;
  final String page;
  final int tabIndex;

  const OpenAddTags(
      {Key? key,
        required this.fontSize,
        required this.page,
        required this.tabIndex
      }) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 300),
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
      // openColor: Colors.transparent,
      closedColor: Colors.transparent,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Row(
            children: [
              const Icon(Icons.add, color: Colors.white, size: 16,),
              Text('Tags',
                  style: DodaoTheme.of(context).bodyText3.override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  )
              )
            ],
          ),
        );
      }
    );
  }
}




class OpenMyAddTags extends StatelessWidget {
  final String page;
  final int tabIndex;

  const OpenMyAddTags(
      {Key? key,
        required this.page,
        required this.tabIndex
      }) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
        transitionDuration: const Duration(milliseconds: 450),
        transitionType: _transitionType,
        openElevation: 0,
        closedElevation: 0,
        openBuilder: (BuildContext context, VoidCallback _) {
          return Container(
              color: DodaoTheme.of(context).taskBackgroundColor,
              child: MainTagsPage(page: page, tabIndex: tabIndex)
          );
        },
        middleColor: Colors.red,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        openColor: DodaoTheme.of(context).taskBackgroundColor,
        closedColor: Colors.transparent,

        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Container(
            height: 30,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.purpleAccent, Colors.deepOrangeAccent, Color(0xfffadb00)],
                stops: [0.1, 0.5, 1],
              ),
            ),
            child: const InkWell(
                highlightColor: Colors.white,
                // onTap: () async {
                //   OpenAddTags(
                //     fontSize: 14,
                //     page: 'tasks',
                //     tabIndex: 0,
                //   );
                // },
                child: Text(
                  '#Tags',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )
            ),

          );
        }
    );
  }
}






