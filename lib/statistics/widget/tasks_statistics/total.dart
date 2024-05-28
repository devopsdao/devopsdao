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
  List<CircularChartAnnotation>? _annotationSources;
  List<Color>? myColors;
  @override
  void initState() {
    super.initState();
    myColors = const <Color>[
      Colors.lightBlue,
      Colors.redAccent,
      Colors.orange,
      Colors.green
    ];
    _annotationSources = <CircularChartAnnotation>[
      CircularChartAnnotation(
        widget: FaIcon(
            FontAwesomeIcons.user,
            size: 12,
            color: myColors?[0]),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
            FontAwesomeIcons.hourglass,
            size: 12,
            color: myColors?[1]),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
            FontAwesomeIcons.handshake,
            size: 12,
            color: myColors?[2]),
      ),
      CircularChartAnnotation(
        widget: FaIcon(
            FontAwesomeIcons.squareCheck,
            size: 12,
            color: myColors?[3]),
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
        final tasksStats = tasksServices.taskStats;
        if (tasksStats == null) {
          return Container(
            height: 145,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Fetching blockchain data', style: TextStyle( fontSize: 12)),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        } else {
          final chartData = [
            ChartData('Created Tasks','100%', _sumBigIntList(tasksStats.topETHAmounts), myColors![0]),
            // // ChartData('Involvement', '100%', _sumBigIntList(account.participantTaskCounts),myColors![1] ),
            // ChartData('Agreed', '100%', _sumBigIntList(tasksStats.agreedTaskCounts), myColors![1]),
            // ChartData('Audit Completed',  '100%', _sumBigIntList(tasksStats.auditCompletedTaskCounts), myColors![2]),
            // ChartData('Completed', '100%', _sumBigIntList(tasksStats.completedTaskCounts), myColors![3]),
          ];

          return LayoutBuilder(
            builder: (context, constraints) {
              return SfCircularChart(
                title:  ChartTitle(text: 'Overall',textStyle: TextStyle( fontSize: 12)),
                margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                legend: Legend(
                  itemPadding: 0,
                  isVisible: true,
                  // overflowMode: LegendItemOverflowMode.wrap,
                  legendItemBuilder:
                      (String name, dynamic series, dynamic point, int index) {
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
                                series: const <RadialBarSeries<ChartData, String>>[
                                ],
                              )),
                          SizedBox(
                              width: 100,
                              child: Text(
                                point.x,
                                style: TextStyle(
                                    color: myColors![index],
                                    fontSize: 12
                                  // fontWeight: FontWeight.bold,
                                ),
                              )),
                        ]));
                  },
                ),
                series: <CircularSeries>[
                  RadialBarSeries<ChartData, String>(
                      sortingOrder: SortingOrder.none,
                      radius: '100%',
                      name: 'sdf',
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle( fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)
                      ),
                      innerRadius: '20%',
                      dataSource: chartData,
                      cornerStyle: CornerStyle.bothFlat,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      pointRadiusMapper: (ChartData data, _) => data.text,
                      pointColorMapper: (ChartData data, _) => data.color,
                      trackColor: Colors.transparent,
                      trackBorderWidth: 0
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