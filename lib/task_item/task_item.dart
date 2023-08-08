import 'package:badges/badges.dart' as Badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shimmer/shimmer.dart';

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

    final content = Row(
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
                        style: Theme.of(context).textTheme.titleMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    // Spacer(),
                    if (task.taskState != "new")
                      Expanded(
                        flex: 3,
                        child: Text(
                          task.taskState,
                          style: Theme.of(context).textTheme.titleSmall,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
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
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final double width = constraints.maxWidth - 66;
                    final List<TokenItem> tags = task.tags.map((name) => TokenItem(collection: true, name: name)).toList();
                    for (int i = 0; i < task.tokenNames.length; i++) {
                      // for(int j=0; j < task.tokenBalances[i].length; j++){
                      //   // if (task.tokenBalances[i][j] >  ) {
                      //   //
                      //   // }
                      // }

                      for (var e in task.tokenNames[i]) {
                        // if (task.tokenBalances[i]) {}
                        if (task.tokenNames[i].first == 'ETH') {
                          tags.add(TokenItem(collection: true, nft: false, balance: task.tokenBalances[i], name: e.toString()));
                        } else {
                          if (task.tokenBalances[i] == 0) {
                            tags.add(TokenItem(collection: true, nft: true, inactive: true, name: e.toString()));
                          } else {
                            tags.add(TokenItem(collection: true, nft: true, inactive: false, name: e.toString()));
                          }
                        }
                      }
                    }
                    // for (var tn in task.tokenNames) {}

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
                  }),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        DateFormat('dd MMM HH:mm').format(task.createTime),
                        style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
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
                    //       overflow: TextOverflow.ellipsis,
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
                    //       overflow: TextOverflow.ellipsis,
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
                    //       overflow: TextOverflow.ellipsis,
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
            (widget.fromPage == 'performer' || widget.fromPage == 'customer' || widget.fromPage == 'auditor' || (widget.fromPage == 'tasks')) &&
            taskCount != 0)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: Badges.Badge(
              // position: BadgePosition.topEnd(top: 10, end: 10),
              badgeContent: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                child: Text(taskCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
              ),
              badgeStyle: Badges.BadgeStyle(
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
                elevation: 0,
                shape: Badges.BadgeShape.square,
                borderRadius: BorderRadius.circular(10),
              ),
              badgeAnimation: const Badges.BadgeAnimation.fade(
                disappearanceFadeAnimationDuration: Duration(milliseconds: 300),
                // curve: Curves.easeInCubic,
              ),
              // child: Icon(Icons.settings),
            ),
          ),
        // if (task.loadingIndicator == true)
        //   const Padding(
        //     padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
        //     child: CircularProgressIndicator(),
        //   ),
      ],
    );

    return !task.loadingIndicator ? Container(
      decoration: BoxDecoration(
        borderRadius: DodaoTheme.of(context).borderRadius,
        border: DodaoTheme.of(context).borderGradient,
      ),
      child: content,
    ) : Shimmer.fromColors(
      baseColor: DodaoTheme.of(context).shimmerBaseColor,
      highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: DodaoTheme.of(context).borderRadius,
            border: DodaoTheme.of(context).borderGradient,
          ),
          child: content
      ),
    );
  }
}






class TaskItemShimmer extends StatelessWidget {
  late Task task;
  late String fromPage;
  bool enableRatingButton = false;
  double ratingScore = 0;
  int taskCount = 0;

  TaskItemShimmer({
    Key? key,
    required this.fromPage,
    required this.task,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    final content = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (tasksServices.roleNfts['governor'] > 0)
          const SizedBox(
            width: 50,
            height: 80,
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.deepOrange,
                  size: 30,
                ),
              ),
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
                        style: Theme.of(context).textTheme.titleMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    // Spacer(),
                    if (task.taskState != "new")
                      Expanded(
                        flex: 3,
                        child: Text(
                          task.taskState,
                          style: Theme.of(context).textTheme.titleSmall,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
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
                        style: Theme.of(context).textTheme.bodyMedium,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final double width = constraints.maxWidth - 66;

                    final List<TokenItem> tags = task.tags.map((name) => TokenItem(collection: true, name: name)).toList();
                    for (int i = 0; i < task.tokenNames.length; i++) {
                      // for(int j=0; j < task.tokenBalances[i].length; j++){
                      //   // if (task.tokenBalances[i][j] >  ) {
                      //   //
                      //   // }
                      // }

                      for (var e in task.tokenNames[i]) {
                        // if (task.tokenBalances[i]) {}
                        if (task.tokenNames[i].first == 'ETH') {
                          tags.add(TokenItem(collection: true, nft: false, balance: task.tokenBalances[i], name: e.toString()));
                        } else {
                          if (task.tokenBalances[i] == 0) {
                            tags.add(TokenItem(collection: true, nft: true, inactive: true, name: e.toString()));
                          } else {
                            tags.add(TokenItem(collection: true, nft: true, inactive: false, name: e.toString()));
                          }
                        }
                      }
                    }
                    // for (var tn in task.tokenNames) {}

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
                  }),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        '▇▇ ▇▇▇ ▇▇:▇▇',
                        style: DodaoTheme.of(context).bodyText2.override(fontFamily: 'Inter', color: DodaoTheme.of(context).secondaryText),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
            (fromPage == 'performer' || fromPage == 'customer' || fromPage == 'auditor' || (fromPage == 'tasks')) &&
            taskCount != 0)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: Badges.Badge(
              // position: BadgePosition.topEnd(top: 10, end: 10),
              badgeContent: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                child: Text(taskCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
              ),

              badgeStyle: Badges.BadgeStyle(
                badgeColor: (() {
                  if (task.taskState == "new") {
                    return Colors.redAccent;
                  } else if (task.taskState == "audit" && fromPage != "auditor") {
                    return Colors.blueGrey;
                  } else if (fromPage == "auditor") {
                    return Colors.green;
                  } else {
                    return Colors.white;
                  }
                }()),
                elevation: 0,
                shape: Badges.BadgeShape.square,
                borderRadius: BorderRadius.circular(10),
              ),
              badgeAnimation: const Badges.BadgeAnimation.fade(
                disappearanceFadeAnimationDuration: Duration(milliseconds: 300),
                // curve: Curves.easeInCubic,
              ),
              // child: Icon(Icons.settings),
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: DodaoTheme.of(context).borderRadius,
        color: DodaoTheme.of(context).taskBackgroundColor,
      ),
      child: Shimmer.fromColors(
        baseColor: DodaoTheme.of(context).shimmerBaseColor,
        highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: DodaoTheme.of(context).borderRadius,
              border: DodaoTheme.of(context).borderGradient,
            ),
            child: content
        ),
      ),
    );
  }
}
