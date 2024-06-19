import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../config/theme.dart';
import '../../../wallet/model_view/wallet_model.dart';
import '../../../widgets/loading/loading_model.dart';

class TotalProcessStats extends StatefulWidget {
  final bool extended;

  const TotalProcessStats({Key? key, required this.extended}) : super(key: key);

  @override
  State<TotalProcessStats> createState() => _TotalProcessStatsState();
}

class _TotalProcessStatsState extends State<TotalProcessStats> {
  List<ChartItem>? _chartItems;

  @override
  void initState() {
    super.initState();

    _chartItems = [
        ChartItem(
          label: 'All tasks',
          color: Colors.lightBlue.shade400,
          icon: FontAwesomeIcons.handshake,
          valueGetter: (TaskStats stats) {
            int sum = stats.countPrivate.toInt()
              + stats.countPublic.toInt()
              + stats.countHackaton.toInt();
            return sum;
          },
        ),
      // if(widget.extended)
      //   ChartItem(
      //     label: 'Public tasks',
      //     color: Colors.lightBlue.shade300,
      //     icon: FontAwesomeIcons.handshake,
      //     valueGetter: (TaskStats stats) => stats.countPublic.toInt(),
      //   ),
      // if(widget.extended)
      //   ChartItem(
      //     label: 'Hackaton tasks',
      //     color: Colors.lightBlue.shade500,
      //     icon: FontAwesomeIcons.handshake,
      //     valueGetter: (TaskStats stats) => stats.countHackaton.toInt(),
      //   ),
      ChartItem(
        label: 'New',
        color: Colors.purple,
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
      if(widget.extended)
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



    return SizedBox(
      height: widget.extended ? 250.0 : 170.0,
      child: Consumer<TasksServices>(
        builder: (context, tasksServices, child) {
          final taskStats = tasksServices.taskStats;
          if (taskStats == null) {

            return Consumer<LoadingModel>(
                builder: (context, loadingModel, child) {
                // if (loadingModel) {
                //   progress = loadingModel.onLoadingPublicStats(tasksServices.tasksLoaded, tasksServices.totalTaskLen);
                // } else {
                //   progress = 0.0;
                // }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Overall Stats', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Container(
                      height: 130,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Fetching data will start after other tasks.', style: TextStyle(fontSize: 12)),
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
            final chartData = _chartItems!.map((item) => ChartData(
              ' [${item.valueGetter(taskStats).toString()}] ${item.label}',
              '100%',
              item.valueGetter(taskStats),
              item.color,
            )).toList();

            final annotations = _chartItems!.map((item) => CircularChartAnnotation(
              widget: FaIcon(
                item.icon,
                size: widget.extended ? 11 : 8,
                color: item.color,
              ),
            )).toList();

            final textSize = widget.extended ? 13.0 : 10.0;
            final itemSize = widget.extended ? 25.0 : 18.0;

            return LayoutBuilder(
              builder: (context, constraints) {
                return SfCircularChart(
                  selectionGesture: widget.extended ? ActivationMode.doubleTap : ActivationMode.none,
                  title: ChartTitle(text: 'Overall', textStyle: TextStyle(fontSize: textSize)),
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  legend: Legend(
                    position: LegendPosition.right,
                    itemPadding: 0,
                    isVisible: true,
                    legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
                      return SizedBox(
                        height: itemSize,
                        width:  widget.extended ? 155 : 130,
                        child: Row(children: <Widget>[
                          SizedBox(
                            height: itemSize,
                            width: itemSize,
                            child: SfCircularChart(

                              selectionGesture: widget.extended ? ActivationMode.doubleTap : ActivationMode.none,
                              margin: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                              annotations: <CircularChartAnnotation>[
                                annotations[index],
                              ],
                              series: <RadialBarSeries<ChartData, String>>[
                                RadialBarSeries<ChartData, String>(
                                  animationDuration: widget.extended ? 0 : 2400,
                                  dataSource: <ChartData>[chartData[index]],
                                  maximumValue: chartData.first.y.toDouble(),
                                  trackColor: Colors.transparent,
                                  radius: '100%',
                                  cornerStyle: CornerStyle.bothCurve,
                                  xValueMapper: (ChartData data, _) => point.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  pointColorMapper: (ChartData data, _) => data.color,
                                  innerRadius: '80%',
                                  pointRadiusMapper: (ChartData data, _) => data.text,
                                  selectionBehavior: SelectionBehavior(
                                    enable: false,
                                    toggleSelection: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: widget.extended ? 120 : 100,
                            child: Text(
                              point.x,
                              style: TextStyle(
                                color: chartData[index].color,
                                fontSize: textSize - 1,
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                  series: <CircularSeries>[
                    RadialBarSeries<ChartData, String>(
                      enableTooltip: widget.extended ? true : false,
                      animationDuration: widget.extended ? 0 : 2400,
                      radius: '100%',
                      name: 'Tasks',
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: Theme.of(context).textTheme.bodySmall?.apply(fontSizeFactor: widget.extended ? 0.8 : 0.6),
                      ),
                      maximumValue: chartData.first.y.toDouble() + 400,
                      innerRadius: '36%',
                      dataSource: chartData,
                      cornerStyle: CornerStyle.bothFlat,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      pointRadiusMapper: (ChartData data, _) => data.text,
                      pointColorMapper: (ChartData data, _) => data.color,
                      trackColor: Colors.transparent,
                      trackBorderWidth: 0,
                      selectionBehavior: SelectionBehavior(
                        enable: false,
                        toggleSelection: false,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
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
