import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dodao/statistics/model_view/task_stats_model.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/goto.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/my.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/personal_stats.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/score.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_created.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_process.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../horizontal_list/horizontal_list_view.dart';

class TasksStatistics extends StatefulWidget {
  const TasksStatistics({super.key});

  @override
  State<TasksStatistics> createState() => _TasksStatisticsState();
}

class _TasksStatisticsState extends State<TasksStatistics> with TickerProviderStateMixin {
  final HorizontalListViewController _controller = HorizontalListViewController();
  final TaskStatsModel taskStatsModel = TaskStatsModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateChildren();
  }

  List<Widget> children = [];

  void _updateChildren() {
    final listenWalletAddress = context.read<WalletModel>().state.walletAddress;

    children = [
      if (listenWalletAddress != null)
        Container(
          width: 180,
          child: const ScoreStats(extended: false),
        ),
      Container(
        width: 280,
        child: const TotalProcessStats(extended: false),
      ),
      Container(
        width: 250,
        child: const TotalCreatedStats(extended: false),
      ),
      if (listenWalletAddress != null)
        Container(
          width: 300,
          child: const PersonalStats(extended: false),
        ),
      Container(
        width: 220,
        child: const GotoStatistics(extended: false),
      ),
    ];

    List<double> itemWidths = children.map((child) {
      if (child is Container) {
        return child.constraints?.minWidth ?? 0.0;
      }
      return 0.0;
    }).toList();

    _controller.itemWidths = itemWidths;
    taskStatsModel.updateItemWidths(itemWidths);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch to listen for changes in the WalletModel's state
    final listenWalletAddress = context.watch<WalletModel>().state.walletAddress;

    // Update children whenever listenWalletAddress changes
    _updateChildren();

    return ChangeNotifierProvider.value(
      value: taskStatsModel,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SizedBox(
          height: 170,
          child: HorizontalListView.builder(
            alignment: CrossAxisAlignment.start,
            crossAxisSpacing: 12,
            controller: _controller,
            itemWidths: _controller.itemWidths,
            itemCount: _controller.itemWidths.length,
            itemBuilder: (BuildContext context, int index) {
              return BlurryContainer(
                blur: 3,
                color: DodaoTheme.of(context).transparentCloud,
                padding: const EdgeInsets.all(0.5),
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
                  decoration: BoxDecoration(
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    border: DodaoTheme.of(context).borderGradient,
                  ),
                  child: children[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

