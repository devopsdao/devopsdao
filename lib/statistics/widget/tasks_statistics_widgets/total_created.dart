import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../../wallet/model_view/wallet_model.dart';
import '../../../widgets/loading/loading_model.dart';

class TotalCreatedStats extends StatefulWidget {
  final bool extended;

  const TotalCreatedStats({Key? key, required this.extended}) : super(key: key);

  @override
  State<TotalCreatedStats> createState() => _TotalCreatedStatsState();
}

class _TotalCreatedStatsState extends State<TotalCreatedStats> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.extended ? 13.0 : 10.0;
    final axisLabelFontSize = widget.extended ? 11.0 : 8.0;

    return SizedBox(
      height: widget.extended ? 200 : 170,
      child: Consumer<TasksServices>(
        builder: (context, tasksServices, child) {
          final taskStats = tasksServices.taskStats;
          if (taskStats == null) {
            return Consumer<LoadingModel>(
                builder: (context, loadingModel, child) {
                  int handled = loadingModel.totalOverStats - loadingModel.loadedOverStats;
                  int total = loadingModel.totalOverStats;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Tasks Created for last 31 days', style: TextStyle(fontSize: 12,)),
                      Container(
                        height: widget.extended ? 180.0 : 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (total == 0)
                              const Text('Fetching data will start soon.', style: TextStyle(fontSize: 12)),
                            if (total > 0)
                              Text('Handled $handled Tasks of $total', style: const TextStyle(fontSize: 12)),
                            Center(child: LoadingAnimationWidget.prograssiveDots(
                              size: 25,
                              color: DodaoTheme.of(context).secondaryText,
                            )),
                          ],
                        ),
                      )

                    ],
                  );
                }
            );
          } else {
            final chartData = _generateChartData(taskStats.createTimestamps);
            return SfCartesianChart(
              title: ChartTitle(
                text: 'Tasks Created for last 31 days',
                textStyle: TextStyle(fontSize: fontSize),
              ),
              margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat.yMd(),
                interval: 9,
                intervalType: DateTimeIntervalType.days,
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: axisLabelFontSize),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Number of Tasks',
                  textStyle: TextStyle(fontSize: fontSize),
                ),
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: TextStyle(fontSize: axisLabelFontSize),
              ),
              series: [
                ColumnSeries<ChartData, DateTime>(
                  enableTooltip: widget.extended ? true : false,
                  animationDuration: widget.extended ? 0 : 2400,
                  name: 'Tasks created',
                  gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
                  borderColor: Colors.blue,
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.date,
                  yValueMapper: (ChartData data, _) => data.count,
                ),
              ],
              tooltipBehavior: TooltipBehavior(
                duration: 2000,
                canShowMarker: false,
                enable: true,
                tooltipPosition: TooltipPosition.pointer,
              ),
            );
          }
        },
      ),
    );
  }

  List<ChartData> _generateChartData(List<BigInt> timestamps) {
    DateTime now = DateTime.now();
    DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);

    Map<DateTime, int> dateCountMap = {};
    for (var timestamp in timestamps) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);
      if (date.isAfter(oneMonthAgo)) {
        DateTime day = DateTime(date.year, date.month, date.day);  // Strip the time
        dateCountMap[day] = (dateCountMap[day] ?? 0) + 1;
      }
    }

    List<ChartData> chartData = dateCountMap.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();
    return chartData;
  }
}

class ChartData {
  final DateTime date;
  final int count;

  ChartData(this.date, this.count);
}
