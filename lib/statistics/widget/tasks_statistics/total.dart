import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';

class TotalStats extends StatefulWidget {
  final bool extended;

  const TotalStats({Key? key, required this.extended}) : super(key: key);

  @override
  State<TotalStats> createState() => _TotalStatsState();
}

class _TotalStatsState extends State<TotalStats> {
  late Future<TaskStats> _taskStatsFuture;
  List<CircularChartAnnotation>? _annotationSources;

  @override
  void initState() {
    super.initState();

    _annotationSources = [
      CircularChartAnnotation(
        widget: FaIcon(
          FontAwesomeIcons.user,
          size: 12,
          color: Colors.green,
        ),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
          FontAwesomeIcons.handshake,
          size: 12,
          color: Colors.blue,
        ),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
          FontAwesomeIcons.hourglass,
          size: 12,
          color: Colors.orange,
        ),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
          FontAwesomeIcons.squareCheck,
          size: 12,
          color: Colors.orange,
        ),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
          FontAwesomeIcons.handshake,
          size: 12,
          color: Colors.green,
        ),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
          FontAwesomeIcons.handshake,
          size: 12,
          color: Colors.red,
        ),
      ),
    ];
  }

  int _sumBigIntList(List<BigInt> list) {
    return list.fold(0, (sum, item) => sum + item.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksServices>(
      builder: (context, tasksServices, child) {
        final taskStats = tasksServices.taskStats;
        if (taskStats == null) {
          return Container(
            height: 145,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Fetching blockchain data', style: TextStyle(fontSize: 12)),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        } else {
          final totalTaskCount = taskStats.countPrivate.toInt() +
              taskStats.countPublic.toInt() +
              taskStats.countHackaton.toInt();

          final chartData = [
            ChartData('New', '100%', taskStats.countNew.toInt(), Colors.green),
            ChartData('Agreed', '100%', taskStats.countAgreed.toInt(), Colors.blue),
            ChartData('In progress', '100%', taskStats.countProgress.toInt(), Colors.orange),
            ChartData('Review', '100%', taskStats.countReview.toInt(), Colors.orange),
            ChartData('Completed', '100%', taskStats.countCompleted.toInt(), Colors.green),
            ChartData('Canceled', '100%', taskStats.countCanceled.toInt(), Colors.red),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              return SfCircularChart(
                title: ChartTitle(text: 'Overall', textStyle: TextStyle(fontSize: 12)),
                margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                legend: Legend(
                  itemPadding: 0,
                  isVisible: true,
                  legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
                    return SizedBox(
                      height: 20,
                      width: 120,
                      child: Row(children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: SfCircularChart(
                            margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                            annotations: <CircularChartAnnotation>[
                              _annotationSources![index],
                            ],
                            series: <RadialBarSeries<ChartData, String>>[],
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
                    sortingOrder: SortingOrder.none,
                    radius: '100%',
                    name: 'Tasks',
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    innerRadius: '20%',
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

class ChartData {
  ChartData(this.x, this.text, this.y, this.color);
  final String x;
  final int y;
  final String text;
  final Color color;
}