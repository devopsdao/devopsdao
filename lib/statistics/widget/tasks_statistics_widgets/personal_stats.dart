import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../blockchain/accounts.dart';
import '../../../blockchain/classes.dart';
import '../../../blockchain/task_services.dart';
import '../../../wallet/model_view/wallet_model.dart';

class PersonalStats extends StatefulWidget {
  final bool extended;

  const PersonalStats({Key? key, required this.extended}) : super(key: key);

  @override
  State<PersonalStats> createState() => _PersonalStatsState();
}

class _PersonalStatsState extends State<PersonalStats> {
  TooltipBehavior? _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: false,
      format: 'point.x : point.y',
      header: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    final fontSize = widget.extended ? 13.0 : 10.0;
    final axisLabelFontSize = widget.extended ? 9.0 : 7.0;
    final dataLabelFontSize = widget.extended ? 13.0 : 10.0;

    return SizedBox(
      height: widget.extended ? 200 : 170,
      child: FutureBuilder<Map<String, Account>>(
        future: tasksServices.getAccountsData(requestedAccountsList: [listenWalletAddress!]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final account = snapshot.data!.values.first;
            final chartData = _prepareChartData(account);
            final maxCount = _findMaxCount(account);

            return SfCartesianChart(
              margin: const EdgeInsets.fromLTRB(2, 0, 2, 0),
              plotAreaBorderWidth: 0,
              title: ChartTitle(
                text: 'Personal statistics',
                textStyle: TextStyle(fontSize: fontSize),
              ),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(fontSize: axisLabelFontSize),
                axisLine: const AxisLine(width: 2),
                labelPosition: ChartDataLabelPosition.outside,
                majorTickLines: const MajorTickLines(width: 0),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                isVisible: true,
                axisLine: AxisLine(width: 0),
                majorTickLines: MajorTickLines(size: 0),
                maximum: maxCount.toDouble(),
              ),
              series: [
                ColumnSeries<ChartData, String>(
                  width: 0.9,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(fontSize: dataLabelFontSize),
                  ),
                  dataSource: chartData,
                  borderRadius: BorderRadius.circular(6),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  pointColorMapper: (ChartData data, _) => data.color,
                ),
              ],
              tooltipBehavior: _tooltipBehavior,
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  List<ChartData> _prepareChartData(Account account) {
    return [
      ChartData('Task\ncreated', account.customerTasks.length, Colors.lightBlue),
      ChartData('Customer\nAgreed', account.customerAgreedTasks.length, Colors.blue),
      ChartData('Customer\nCompleted', account.customerCompletedTasks.length, Colors.blueAccent),
      ChartData('Task\nparticipated', account.participantTasks.length, Colors.lightGreen),
      ChartData('Performer\nagreed', account.performerAgreedTasks.length, Colors.green),
      ChartData('Performer\ncompleted', account.performerCompletedTasks.length, Colors.green.shade700),
      if(widget.extended)
        ChartData('Audit\nparticipated', account.auditParticipantTasks.length, Colors.orangeAccent),
      if(widget.extended)
        ChartData('Audit\nagreed', account.auditAgreed.length, Colors.orange),
      if(widget.extended)
        ChartData('Audit\ncompleted', account.auditCompleted.length, Colors.orange.shade700),
    ];
  }

  int _findMaxCount(Account account) {
    return [
      account.customerTasks.length,
      account.customerAgreedTasks.length,
      account.customerCompletedTasks.length,
      account.participantTasks.length,
      account.performerAgreedTasks.length,
      account.performerCompletedTasks.length,
    ].reduce((value, element) => value > element ? value : element);
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}
