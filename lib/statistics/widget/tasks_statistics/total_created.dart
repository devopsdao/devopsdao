import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

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
    return Consumer<TasksServices>(
      builder: (context, tasksServices, child) {
        final taskStats = tasksServices.taskStats;
        if (taskStats == null) {
          return Container(
            height: 170,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Fetching blockchain data', style: TextStyle(fontSize: 12)),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        } else {
          final chartData = _generateChartData(taskStats.createTimestamps);
          return SfCartesianChart(
            title: ChartTitle(text: 'Tasks Created for last 31 days', textStyle: TextStyle(fontSize: 10)),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat.yMd(),
              interval: 7,
              intervalType: DateTimeIntervalType.days,
              majorGridLines: const MajorGridLines(width: 0),
                labelStyle:TextStyle(fontSize: 8)
                // edgeLabelPlacement: EdgeLabelPlacement.none
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Number of Tasks', textStyle: TextStyle(fontSize: 10)),
              majorGridLines: const MajorGridLines(width: 0),
                labelStyle:TextStyle(fontSize: 8)
            ),
            series: [
              ColumnSeries<ChartData, DateTime>(
                name: 'Tasks created',
                gradient: LinearGradient(colors: [Colors.blue, Colors.lightBlue]),
                borderColor: Colors.blue,
                // borderRadius:BorderRadius.circular(15.0) ,
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.count,
              ),
            ],
            tooltipBehavior: TooltipBehavior(
              duration: 2000,
              canShowMarker: false,
              enable: true,
              tooltipPosition: TooltipPosition.pointer
            ),
          );
        }
      },
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

