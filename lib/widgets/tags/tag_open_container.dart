import 'package:animations/animations.dart';
import 'package:dodao/widgets/tags/tags_old.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../config/theme.dart';
import 'main.dart';

class TagCallButton extends StatelessWidget {
  final String page;
  final int tabIndex;
  const TagCallButton({Key? key, required this.page, required this.tabIndex}) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();

    if (page != 'create') {
      return OpenContainer(
        transitionDuration: const Duration(milliseconds: 300),
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return Container(color: Colors.white, child: MainTagsPage(page: page, tabIndex: tabIndex));
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
          elevation: 0,
          borderRadius: DodaoTheme.of(context).borderRadius,
          color: Colors.transparent,
          child: OpenContainer(
            transitionDuration: const Duration(milliseconds: 500),
            transitionType: _transitionType,
            openBuilder: (BuildContext context, VoidCallback _) {
              return Container(
                  color: Colors.white,
                  child: MainTagsPage(
                    page: page,
                    tabIndex: tabIndex,
                  ));
            },
            closedElevation: 0,
            closedShape: RoundedRectangleBorder(
              borderRadius: DodaoTheme.of(context).borderRadius,
            ),
            openElevation: 2,
            openColor: DodaoTheme.of(context).background,
            closedColor: DodaoTheme.of(context).smallButtonGradient.colors.last,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {

              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: DodaoTheme.of(context).smallButtonGradient,
                  borderRadius: DodaoTheme.of(context).borderRadius,
                ),
                child: const IconButton(
                  icon: Icon(Icons.tag_rounded, size: 18, color: Colors.white),
                  tooltip: 'Add tags or NFT\'s',
                  onPressed: null,
                  // onPressed: () {
                  //   interface.dialogPagesController.animateToPage(
                  //       interface.dialogCurrentState['pages']['topup'] ?? 99,
                  //       duration: const Duration(milliseconds: 400), curve: Curves.ease
                  //   );
                  // },
                ),
              );

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
          ));
    }
  }
}
