import 'package:badges/badges.dart' as Badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadgeTab extends StatefulWidget {
  final int taskCount;
  final String tabText;
  const BadgeTab({Key? key, required this.taskCount, required this.tabText})
      : super(key: key);

  @override
  _BadgeTabState createState() => _BadgeTabState();
}

class _BadgeTabState extends State<BadgeTab> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.taskCount > 0)
          // Expanded(
          //   flex: 1,
          //   child:
          Badges.Badge(
            shape: Badges.BadgeShape.square,
            borderRadius: BorderRadius.circular(4),
            animationType: Badges.BadgeAnimationType.fade,
            badgeContent: Container(
              width: 8,
              height: 10,
              alignment: Alignment.center,
              child: Text(widget.taskCount.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.white)),
            ),
          ),
        Text(
          ' ${widget.taskCount > 0 ? ' ${widget.tabText}' : widget.tabText}',
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
