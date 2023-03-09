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
            badgeContent: Container(
              width: 9,
              height: 11,
              alignment: Alignment.center,
              child: Text(widget.taskCount.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      color: Colors.white)),
            ),
          ),
        Expanded(
          flex: 1,
          child: Text(
            ' ${widget.taskCount > 0 ? ' ${widget.tabText}' : widget.tabText}',
            softWrap: false,
            overflow: TextOverflow.fade,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
