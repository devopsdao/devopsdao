import 'package:dodao/statistics/widget/tasks_statistics_widgets/personal_stats.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/score.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_created.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_process.dart';
import 'package:flutter/cupertino.dart';

List<Widget> initializeWidgets(bool extended, {required bool walletConnected}) {
  final double scoreStatsWidth = extended ? double.infinity : 180.0;
  final double totalProcessStatsWidth = extended ? double.infinity : 280.0;
  final double totalCreatedStatsWidth = extended ? double.infinity : 250.0;
  final double personalStatsWidth = extended ? double.infinity : 310.0;

  return [
    if (walletConnected)
      Container(
        width: scoreStatsWidth,
        child: ScoreStats(extended: extended),
      ),
    Container(
      width: totalProcessStatsWidth,
      child: TotalProcessStats(extended: extended),
    ),
    Container(
      width: totalCreatedStatsWidth,
      child: TotalCreatedStats(extended: extended),
    ),
    if (walletConnected)
      Container(
        width: personalStatsWidth,
        child: PersonalStats(extended: extended),
      ),
  ];
}
