import 'package:badges/badges.dart' as Badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blockchain/task.dart';

import '../flutter_flow/theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../widgets/tags/tags.dart';
import '../widgets/tags/wrapped_chip.dart';
import 'delete_item_alert.dart';

class TaskItem extends StatefulWidget {
  // final int taskCount;
  final String fromPage;
  final Task object;
  const TaskItem(
      {Key? key,
      // required this.taskCount,
      required this.fromPage,
      required this.object})
      : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late Task task;
  bool enableRatingButton = false;
  double ratingScore = 0;
  int taskCount = 0;

  final bool isAdministrator = false;

  @override
  Widget build(BuildContext context) {
    // var tasksServices = context.watch<TasksServices>();
    // var interface = context.watch<InterfaceServices>();
    task = widget.object;

    if (task.taskState == "new") {
      taskCount = task.participants.length;
    } else if (task.taskState == "audit") {
      taskCount = task.auditors.length;
    }

    return Container(
      // width: double.infinity,
      // height: 86,
      decoration: BoxDecoration(
        color: (() {
          if (task.taskState == "agreed" || task.taskState == "new") {
            return Colors.white;
          } else if (task.taskState == "review") {
            return Colors.lightGreen.shade300;
          } else if (task.taskState == "progress") {
            return Colors.lightBlueAccent;
          } else if (task.taskState == "canceled") {
            return Colors.orange;
          } else if (task.taskState == "audit" && widget.fromPage != 'auditor') {
            return Colors.orangeAccent;
          } else if (task.taskState == "audit" && widget.fromPage == 'auditor') {
            return Colors.white;
          } else {
            return Colors.white;
          }
        }()),
        // boxShadow: const [
        //   BoxShadow(
        //     blurRadius: 5,
        //     color: Color(0x4D000000),
        //     offset: Offset(0, 2),
        //   )
        // ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (true)
            SizedBox(
              width: 50,
              height: 80,
              child: InkWell(
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.deepOrange,
                    size: 30,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showDialog(context: context, builder: (context) => DeleteItemAlert(task: task));
                  });
                },
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 8, 8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          task.title,
                          style: DodaoTheme.of(context).subtitle1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      // Spacer(),
                      if (task.taskState != "new")
                        Expanded(
                          flex: 3,
                          child: Text(
                            task.taskState,
                            style: DodaoTheme.of(context).bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.description,
                          style: DodaoTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: LayoutBuilder(builder: (context, constraints) {
                        final double width = constraints.maxWidth - 66;
                        List<SimpleTags> tags = task.tags.map((name) => SimpleTags(tag: name)).toList();

                        return SizedBox(
                          width: width,
                          child: Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              children: tags.map((e) {
                                return WrappedChip(
                                    interactive: false,
                                    key: ValueKey(e),
                                    theme: 'small-white',
                                    nft: e.nft ?? false,
                                    name: e.tag!,
                                    control: false,
                                    page: 'create');
                              }).toList()),
                        );
                      }))
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          DateFormat('MM/dd/yyyy, hh:mm a').format(task.createTime),
                          style: const TextStyle(
                            // fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      // Spacer(),
                      if (task.tokenValues[0] != 0)
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${task.tokenValues[0]} DEV',
                            style: DodaoTheme.of(context).bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      if (task.tokenValues[0] != 0)
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${task.tokenValues[0]} aUSDC',
                            style: DodaoTheme.of(context).bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      if (task.tokenValues[0] == 0 && task.tokenValues[0] == 0)
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Has no money',
                            style: DodaoTheme.of(context).bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // *********** BADGE ************ //

          if ((task.taskState == "new" || task.taskState == "audit") &&
              (widget.fromPage == 'performer' ||
                  widget.fromPage == 'customer' ||
                  widget.fromPage == 'auditor' ||
                  (widget.fromPage == 'tasks' && taskCount != 0)))
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: Badges.Badge(
                // position: BadgePosition.topEnd(top: 10, end: 10),
                badgeContent: Container(
                  width: 17,
                  height: 17,
                  alignment: Alignment.center,
                  child: Text(taskCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                badgeColor: (() {
                  if (task.taskState == "new") {
                    return Colors.redAccent;
                  } else if (task.taskState == "audit" && widget.fromPage != "auditor") {
                    return Colors.blueGrey;
                  } else if (widget.fromPage == "auditor") {
                    return Colors.green;
                  } else {
                    return Colors.white;
                  }
                }()),
                animationDuration: const Duration(milliseconds: 300),
                animationType: Badges.BadgeAnimationType.scale,
                shape: Badges.BadgeShape.circle,
                borderRadius: BorderRadius.circular(5),
                // child: Icon(Icons.settings),
              ),
            ),
          if (task.justLoaded == false)
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
