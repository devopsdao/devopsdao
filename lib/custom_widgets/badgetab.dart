
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../flutter_flow/flutter_flow_theme.dart';

class BadgeTab extends StatefulWidget {
  final int taskCount;
  final String tabText;
  const BadgeTab({Key? key, required this.taskCount, required this.tabText}) : super(key: key);

  @override
  _BadgeTabState createState() => _BadgeTabState();
}

class _BadgeTabState extends State<BadgeTab> {


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    return
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(widget.taskCount > 0)
          Badge(
            // position: BadgePosition.topEnd(top: 10, end: 10),
            badgeContent: Container(
              width: 9,
              height: 10,
              alignment: Alignment.center,
              child: Text(
                  widget.taskCount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 9, color: Colors.white)
              ),
            ),
          ),
          Text('${widget.taskCount > 0 ? ' ' + widget.tabText : widget.tabText}'),
        ],
      );
  }
}
