import 'package:badges/badges.dart' as Badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadgeTab extends StatefulWidget {
  final int taskCount;
  final int index;
  final String tabText;
  const BadgeTab({Key? key, required this.taskCount, required this.tabText, this.index = 3})
      : super(key: key);

  @override
  _BadgeTabState createState() => _BadgeTabState();
}

class _BadgeTabState extends State<BadgeTab> {
  final colors = [
    const Color(0xFFF67FC5),
    const Color(0xFFF89771),
    const Color(0xFF87B5FA),
    Colors.green.shade700
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Text(
                ' ${widget.taskCount > 0 ? ' ${widget.tabText}' : widget.tabText}',
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (widget.taskCount > 0)
            Container(
              padding: const EdgeInsets.only(left: 6, right: 0.0),
              child: Badges.Badge(
                shape: Badges.BadgeShape.circle,
                borderRadius: BorderRadius.circular(4),
                animationType: Badges.BadgeAnimationType.fade,
                badgeColor: colors[widget.index],
                badgeContent: Container(
                  width: 8,
                  height: 10,
                  alignment: Alignment.center,
                  child: Text(widget.taskCount.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.white)
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
