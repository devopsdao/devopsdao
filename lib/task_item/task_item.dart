import 'package:badges/badges.dart' as Badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../blockchain/classes.dart';

import '../blockchain/task_services.dart';
import '../config/flutter_flow_util.dart';
import '../config/theme.dart';
import '../config/flutter_flow_util.dart';
import '../widgets/tags/tags_old.dart';
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

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // var interface = context.watch<InterfaceServices>();
    task = widget.object;

    if (task.taskState == "new") {
      taskCount = task.participants.length;
    } else if (task.taskState == "audit") {
      taskCount = task.auditors.length;
    }

    late LinearGradient gradient;
    late GradientBoxBorder gradientBorder;

    if (task.taskState == "agreed" || task.taskState == "new") {
      gradient = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [
        0,
        1
      ], colors: [
        Color(0xFFFFC344),
        Color(0xFFFF8911),
      ]);
      gradientBorder = const GradientBoxBorder(
        gradient: LinearGradient(colors: [Color(0xFFFF8911), Color(0xFFF51179)]),
        width: 2,
      );
    } else if (task.taskState == "review") {
      gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Colors.green.shade800,
        Colors.yellow.shade600,
      ]);
      gradientBorder = const GradientBoxBorder(
        gradient: LinearGradient(colors: [Color(0xFFFFC344), Color(0xFFFF8911)]),
        width: 2,
      );
    } else if (task.taskState == "progress") {
      gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Colors.green.shade800,
        Colors.yellow.shade600,
      ]);
      gradientBorder = const GradientBoxBorder(
        gradient: LinearGradient(colors: [Color(0xFFF51179), Color(0xFFE817D7)]),
        width: 2,
      );
    } else if (task.taskState == "canceled") {
      gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Colors.green.shade800,
        Colors.yellow.shade600,
      ]);
      gradientBorder = const GradientBoxBorder(
        gradient: LinearGradient(colors: [Color(0xFFE817D7), Color(0xFF6F1494)]),
        width: 2,
      );
    } else if (task.taskState == "audit" && widget.fromPage != 'auditor') {
      gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Colors.green.shade800,
        Colors.yellow.shade600,
      ]);
      gradientBorder = const GradientBoxBorder(
        gradient: LinearGradient(colors: [Color(0xFF6F1494), Color(0xFF17A3F5)]),
        width: 2,
      );
    } else {
      gradient = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
        Colors.green.shade800,
        Colors.yellow.shade600,
      ]);
      gradientBorder = const GradientBoxBorder(
        gradient: LinearGradient(colors: [Color(0xFFF51179), Color(0xFFFF8911)]),
        width: 2,
      );
    }

    return Container(
      // width: double.infinity,
      // height: 86,
      decoration: BoxDecoration(
        border: gradientBorder,
        color: Colors.transparent,
        // gradient: gradient,
        // boxShadow: const [
        //   BoxShadow(
        //     blurRadius: 5,
        //     color: Color(0x4D000000),
        //     offset: Offset(0, 2),
        //   )
        // ],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (tasksServices.roleNfts['governor'] > 0)
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
                          style: DodaoTheme.of(context).subtitle1.override(fontFamily: 'Inter', color: DodaoTheme.of(context).primaryText),
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
                            style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
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
                          style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
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

                        final List<TokenItem> tags;
                        tags = task.tags.map((name) => TokenItem(collection: true, name: name)).toList();
                        for(int i=0; i < task.tokenNames.length; i++){

                          for(int j=0; j < task.tokenBalances[i].length; j++){
                            if (task.tokenBalances[i][j] > ) {

                            }
                          }


                          for(var e in task.tokenNames[i]) {
                            if (task.tokenBalances[i]) {

                            }
                            tags.add(
                                TokenItem(collection: true, nft: true, name: e.toString()));
                          }
                        }
                        for (var tn in task.tokenNames) {

                        }


                        return SizedBox(
                          width: width,
                          child: Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              children: tags.map((e) {
                                return WrappedChipSmall(
                                  key: ValueKey(e),
                                  theme: 'small-black',
                                  item: e,
                                  page: 'items',
                                );
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
                          DateFormat('dd MMM HH:mm').format(task.createTime),
                          style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ),
                      // Spacer(),
                      // if (task.tokenBalances[0] != 0)
                      //   Expanded(
                      //     flex: 3,
                      //     child: Text(
                      //       '${task.tokenBalances[0]} ${tasksServices.chainTicker}',
                      //       style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
                      //       softWrap: false,
                      //       overflow: TextOverflow.fade,
                      //       maxLines: 1,
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ),
                      // if (task.tokenValues[0] != 0)
                      //   Expanded(
                      //     flex: 3,
                      //     child: Text(
                      //       '${task.tokenValues[0]} USDC',
                      //       style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
                      //       softWrap: false,
                      //       overflow: TextOverflow.fade,
                      //       maxLines: 1,
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ),
                      // if (task.tokenBalances[0] == 0 && task.tokenBalances[0] == 0)
                      //   Expanded(
                      //     flex: 3,
                      //     child: Text(
                      //       // 'Has no money',
                      //       '',
                      //       style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
                      //       softWrap: false,
                      //       overflow: TextOverflow.fade,
                      //       maxLines: 1,
                      //       textAlign: TextAlign.end,
                      //     ),
                      //   ),
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
                borderRadius: BorderRadius.circular(14),
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
