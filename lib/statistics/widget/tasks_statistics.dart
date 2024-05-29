import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dodao/statistics/widget/tasks_statistics/goto.dart';
import 'package:dodao/statistics/widget/tasks_statistics/my.dart';
import 'package:dodao/statistics/widget/tasks_statistics/score.dart';
import 'package:dodao/statistics/widget/tasks_statistics/total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../horizontal_list/horizontal_list_view.dart';
import '../model_view/statistics_model_view.dart';


class TasksStatistics extends StatefulWidget {
  const TasksStatistics({super.key});

  @override
  State<TasksStatistics> createState() => _TasksStatisticsState();
}

class _TasksStatisticsState extends State<TasksStatistics> with TickerProviderStateMixin {
  late StatisticsModel _model;

  List<Widget> children = [
    Container(
      width: 180,
      child: const ScoreStats(extended: false,),
    ),
    Container(
      width: 240,
      child: const TotalStats(extended: false,),
    ),
    Container(
      width: 250,
      height: 150,
      child: const MyStats(extended: false,),
    ),
    Container(
      width: 300,
      color: Colors.deepPurple,
      child: const Center(
        child: Text(
          'item: 1',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    Container(
      width: 220,
      height: 150,
      child: const GotoStatistics(extended: false,),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _model = StatisticsModel(this);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }




  final HorizontalListViewController _controller =
  HorizontalListViewController();
  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    List<double> itemWidths = children.map((child) {
      if (child is Container) {
        return child.constraints?.minWidth ?? 0.0;
      }
      return 0.0;
    }).toList();

    return ChangeNotifierProvider.value(
      value: _model,
      child: Consumer<StatisticsModel>(
        builder: (context, model, child) {
          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: SizedBox(
              height: 150,
              child: HorizontalListView.builder(
                alignment: CrossAxisAlignment.start,
                crossAxisSpacing: 12,
                controller: _controller,
                itemWidths: itemWidths,
                itemCount: itemWidths.length,
                itemBuilder: (BuildContext context, int index) {
                  return  BlurryContainer(
                    blur: 3,
                    color: DodaoTheme.of(context).transparentCloud,
                    padding: const EdgeInsets.all(0.5),
                    child: Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(14, 8, 14, 8),
                        decoration: BoxDecoration(
                          borderRadius: DodaoTheme.of(context).borderRadius,
                          border: DodaoTheme.of(context).borderGradient,
                        ),
                        child: children[index]
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}