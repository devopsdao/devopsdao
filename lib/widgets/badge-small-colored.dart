import 'package:animations/animations.dart';
import 'package:badges/badges.dart' as Badges;
import 'package:flutter/material.dart';

import '../../config/theme.dart';
import '../main.dart';

class BadgeSmallColored extends StatelessWidget {
  final Color color;
  final int count;

  const BadgeSmallColored({
    Key? key,
    required this.color,
    required this.count,
  }) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Badges.Badge(
      badgeStyle: Badges.BadgeStyle(
        badgeColor: color,
        elevation: 0,
        shape: Badges.BadgeShape.circle,
        borderRadius: BorderRadius.circular(4),
      ),
      badgeAnimation: const Badges.BadgeAnimation.fade(
          // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
          // curve: Curves.easeInCubic,
          ),
      badgeContent: Container(
        width: 20,
        height: 12,
        alignment: Alignment.center,
        child: Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8, color: Colors.white)),
      ),
    );
  }
}

class BadgeSmallRatingColored extends StatelessWidget {
  final Color color;
  final double count;

  const BadgeSmallRatingColored({
    Key? key,
    required this.color,
    required this.count,
  }) : super(key: key);

  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Badges.Badge(
      badgeStyle: Badges.BadgeStyle(
        badgeColor: color,
        elevation: 0,
        shape: Badges.BadgeShape.circle,
        borderRadius: BorderRadius.circular(4),
      ),
      badgeAnimation: const Badges.BadgeAnimation.fade(
          // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
          // curve: Curves.easeInCubic,
          ),
      badgeContent: Container(
        width: 14,
        height: 12,
        alignment: Alignment.center,
        child: Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8, color: Colors.white)),
      ),
    );
  }
}

class BadgeWideColored extends StatelessWidget {
  final Color color;
  final String name;
  final double width;

  const BadgeWideColored({
    Key? key,
    required this.color,
    required this.name,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badges.Badge(
      badgeStyle: Badges.BadgeStyle(
        badgeColor: color,
        elevation: 0,
        shape: Badges.BadgeShape.square,
        borderRadius: BorderRadius.circular(4),
      ),
      badgeAnimation: const Badges.BadgeAnimation.fade(),
      badgeContent: Container(
        width: width,
        height: 10,
        alignment: Alignment.center,
        child: Text(name.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8, color: Colors.white)),
      ),
    );
  }
}
