import 'package:badges/badges.dart';
import 'package:devopsdao/custom_widgets/participants_list.dart';
import 'package:devopsdao/custom_widgets/selectMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';

class TaskItem extends StatefulWidget {
  // final int taskCount;
  final String role;
  final Task object;
  const TaskItem(
      {Key? key,
      // required this.taskCount,
      required this.role,
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

  @override
  Widget build(BuildContext context) {
    // var tasksServices = context.watch<TasksServices>();
    // var interface = context.watch<InterfaceServices>();
    task = widget.object;

    if (task.jobState == "new") {
      taskCount = task.contributors.length;
    } else if (task.jobState == "audit") {
      taskCount = task.auditContributors.length;
    }

    return Container(
      width: double.infinity,
      height: 86,
      decoration: BoxDecoration(
        color: (() {
          if (task.jobState == "agreed" || task.jobState == "new") {
            return Colors.white;
          } else if (task.jobState == "review") {
            return Colors.lightGreen.shade300;
          } else if (task.jobState == "progress") {
            return Colors.lightBlueAccent;
          } else if (task.jobState == "canceled") {
            return Colors.orange;
          } else if (task.jobState == "audit" && widget.role != 'auditor') {
            return Colors.orangeAccent;
          } else if (task.jobState == "audit" && widget.role == 'auditor') {
            return Colors.white;
          } else {
            return Colors.white;
          }
        }()),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x4D000000),
            offset: Offset(0, 2),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
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
                          style: FlutterFlowTheme.of(context).subtitle1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      // Spacer(),
                      if (task.jobState != "new")
                      Expanded(
                        flex: 3,
                        child: Text(
                          task.jobState,
                          style: FlutterFlowTheme.of(context).bodyText2,
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
                          style: FlutterFlowTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          DateFormat('MM/dd/yyyy, hh:mm a')
                              .format(task.createdTime),
                          style: FlutterFlowTheme.of(context).bodyText2,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      // Spacer(),
                      if (task.contractValue != 0)
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${task.contractValue} ETH',
                            style: FlutterFlowTheme.of(context).bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      if (task.contractValueToken != 0)
                        Expanded(
                          flex: 3,
                          child: Text(
                            '${task.contractValueToken} aUSDC',
                            style: FlutterFlowTheme.of(context).bodyText2,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      if (task.contractValue == 0 &&
                          task.contractValueToken == 0)
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Has no money',
                            style: FlutterFlowTheme.of(context).bodyText2,
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

          if ((task.jobState == "new" || task.jobState == "audit" ) &&
              (widget.role == 'performer' || widget.role == 'customer' ||
                  widget.role == 'auditor' ||
                  (widget.role == 'exchange' && taskCount != 0)))
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: Badge(
                // position: BadgePosition.topEnd(top: 10, end: 10),
                badgeContent: Container(
                  width: 17,
                  height: 17,
                  alignment: Alignment.center,
                  child: Text(taskCount.toString(),
                    style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                badgeColor: (() {
                  if (task.jobState == "new") {
                    return Colors.redAccent;
                  } else if (task.jobState == "audit" && widget.role != "auditor") {
                    return Colors.blueGrey;
                  } else if (widget.role == "auditor") {
                    return Colors.green;
                  } else {
                    return Colors.white;
                  }
                }()),
                animationDuration: const Duration(milliseconds: 300),
                animationType: BadgeAnimationType.scale,
                shape: BadgeShape.circle,
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
