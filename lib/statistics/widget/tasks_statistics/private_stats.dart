import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';

class PrivateStats extends StatefulWidget {
  final bool extended;

  const PrivateStats({Key? key, required this.extended}) : super(key: key);

  @override
  State<PrivateStats> createState() => _PrivateStatsState();
}

class _PrivateStatsState extends State<PrivateStats> {
  List<ChartItem>? _chartItems;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var tasksServices = context.read<TasksServices>();
      tasksServices.
    });
    _chartItems = [
      ChartItem(
        label: 'New',
        color: Colors.lightBlue.shade200,
        icon: FontAwesomeIcons.user,
        valueGetter: (TaskStats stats) => stats.countNew.toInt(),
      ),
      ChartItem(
        label: 'Agreed',
        color: Colors.blueAccent.shade400,
        icon: FontAwesomeIcons.handshake,
        valueGetter: (TaskStats stats) => stats.countAgreed.toInt(),
      ),
      ChartItem(
        label: 'In progress',
        color: Colors.orange,
        icon: FontAwesomeIcons.hourglass,
        valueGetter: (TaskStats stats) => stats.countProgress.toInt(),
      ),
      ChartItem(
        label: 'Review',
        color: Colors.lightGreen,
        icon: FontAwesomeIcons.squareCheck,
        valueGetter: (TaskStats stats) => stats.countReview.toInt(),
      ),
      ChartItem(
        label: 'Completed',
        color: Colors.green,
        icon: FontAwesomeIcons.handshake,
        valueGetter: (TaskStats stats) => stats.countCompleted.toInt(),
      ),
      ChartItem(
        label: 'Canceled',
        color: Colors.red,
        icon: FontAwesomeIcons.handshake,
        valueGetter: (TaskStats stats) => stats.countCanceled.toInt(),
      ),
    ];
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
          final chartData = _chartItems!.map((item) => ChartData(
            ' [${item.valueGetter(taskStats).toString()}] ${item.label}',
            '100%',
            item.valueGetter(taskStats),
            item.color,
          )).toList();

          final annotations = _chartItems!.map((item) => CircularChartAnnotation(
            widget: FaIcon(
              item.icon,
              size: 8,
              color: item.color,
            ),
          )).toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              return SfCircularChart(

                title: ChartTitle(text: 'Overall', textStyle: TextStyle(fontSize: 10)),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                legend: Legend(
                  itemPadding: 0,
                  isVisible: true,
                  legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
                    return SizedBox(
                      height: 20,
                      width: 130,
                      child: Row(children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: SfCircularChart(
                            margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                            annotations: <CircularChartAnnotation>[
                              annotations[index],
                            ],
                            series: <RadialBarSeries<ChartData, String>>[
                              RadialBarSeries<ChartData, String>(
                                dataSource: <ChartData>[chartData[index]],
                                maximumValue: chartData.first.y.toDouble(),
                                // gap: '1%',
                                trackColor: Colors.transparent,
                                radius: '100%',
                                cornerStyle: CornerStyle.bothCurve,
                                xValueMapper: (ChartData data, _) => point.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                pointColorMapper: (ChartData data, _) =>
                                data.color,
                                innerRadius: '80%',
                                pointRadiusMapper: (ChartData data, _) =>
                                data.text,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            point.x,
                            style: TextStyle(
                              color: chartData[index].color,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
                series: <CircularSeries>[
                  RadialBarSeries<ChartData, String>(
                    // sortingOrder: SortingOrder.ascending,
                    // sortFieldValueMapper: (ChartData data, _) => data.y,
                    radius: '100%',
                    name: 'Tasks',
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: 0.6),
                    ),
                    maximumValue: chartData.first.y.toDouble() + 400,
                    innerRadius: '44%',
                    dataSource: chartData,
                    cornerStyle: CornerStyle.bothFlat,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    pointRadiusMapper: (ChartData data, _) => data.text,
                    pointColorMapper: (ChartData data, _) => data.color,
                    trackColor: Colors.transparent,
                    trackBorderWidth: 0,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class ChartItem {
  final String label;
  final Color color;
  final IconData icon;
  final int Function(TaskStats) valueGetter;

  ChartItem({
    required this.label,
    required this.color,
    required this.icon,
    required this.valueGetter,
  });
}

class ChartData {
  ChartData(this.x, this.text, this.y, this.color);
  final String x;
  final int y;
  final String text;
  final Color color;
}