import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dodao/statistics/model_view/horizontal_list_view_model.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/goto.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/score.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_created.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_process.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/personal_stats.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';

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
  final HorizontalListViewController _controller = HorizontalListViewController();
  final HorizontalListViewModel horizontalListViewModel = HorizontalListViewModel();
  late IndexedChildrenManager _indexedChildrenManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateChildren();
  }

  List<Widget> _buildChildren(EthereumAddress? listenWalletAddress) {
    return [
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
  }

  void _updateChildren() {
    final listenWalletAddress = context.read<WalletModel>().state.walletAddress;
    List<Widget> children = _buildChildren(listenWalletAddress);

    List<int> initialIndexOrder = List<int>.generate(children.length, (i) => i);

    _indexedChildrenManager = IndexedChildrenManager(children, initialIndexOrder);

    List<double> itemWidths = children.map((child) {
      if (child is Container) {
        return child.constraints?.minWidth ?? 0.0;
      }
      return 0.0;
    }).toList();

    _controller.itemWidths = itemWidths;
    horizontalListViewModel.updateItemWidths(itemWidths);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.watch<WalletModel>().state.walletAddress;

    _updateChildren();

    return ChangeNotifierProvider.value(
      value: horizontalListViewModel,
      child: ChangeNotifierProvider.value(
        value: _indexedChildrenManager,
        child: Consumer<IndexedChildrenManager>(
          builder: (context, manager, child) {
            List<Widget> orderedChildren = manager.getOrderedChildren();

            return ScrollConfiguration(
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
                        child: orderedChildren[index],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
