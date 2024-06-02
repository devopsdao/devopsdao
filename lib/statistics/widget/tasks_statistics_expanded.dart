import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/goto.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/personal_stats.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/score.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_created.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_process.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter/material.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../config/theme.dart';
import '../../navigation/appbar.dart';
import '../../navigation/navmenu.dart';
import '../../task_dialog/beamer.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../../wallet/services/wallet_service.dart';
import '../model_view/statistics_model_view.dart';
import '/blockchain/task_services.dart';

class StatisticsExpanded extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const StatisticsExpanded({Key? key, this.taskAddress}) : super(key: key);

  @override
  _StatisticsExpandedState createState() => _StatisticsExpandedState();
}


class _StatisticsExpandedState extends State<StatisticsExpanded> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final IndexedChildrenManager _indexedChildrenManager = IndexedChildrenManager();
  late List<Widget> children;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final listenWalletAddress = context.watch<WalletModel>().state.walletAddress;
    children = [
      if (listenWalletAddress != null)
        Container(
          child: const ScoreStats(extended: true),
        ),
      Container(
        child: const TotalProcessStats(extended: true),
      ),
      Container(
        child: const TotalCreatedStats(extended: true),
      ),
      if (listenWalletAddress != null)
        Container(
          child: const PersonalStats(extended: true),
        ),
    ];

    List<int> initialIndexOrder = List<int>.generate(children.length, (i) => i);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      _indexedChildrenManager.reorder(oldIndex, newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      appBar: const StatisticsExpandedHeader(),
      body: ChangeNotifierProvider.value(
        value: _indexedChildrenManager,
        child: Consumer<IndexedChildrenManager>(
          builder: (context, manager, child) {
            List<Widget> orderedChildren = manager.getOrderedChildren(children);

            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  width: context.read<InterfaceServices>().maxStaticDialogWidth,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Container(
                        height: height - 60,
                        child: ReorderableListView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          onReorder: _onReorder,
                          buildDefaultDragHandles: false, // Prevents default drag handle
                            proxyDecorator: (child, index, animation) => child,
                          children: List.generate(orderedChildren.length, (index) {
                            return Padding(
                              key: ValueKey(index),
                              padding: const EdgeInsets.only(bottom: 14.0),
                              child: GestureDetector(
                                onLongPress: () {},
                                child: BlurryContainer(
                                  blur: 3,
                                  color: DodaoTheme.of(context).transparentCloud,
                                  padding: const EdgeInsets.all(0.5),
                                  child: Container(
                                    padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
                                    decoration: BoxDecoration(
                                      borderRadius: DodaoTheme.of(context).borderRadius,
                                      border: DodaoTheme.of(context).borderGradient,
                                    ),
                                    child: Stack(
                                      children: [
                                        orderedChildren[index],
                                        Positioned(
                                          top:0.0,
                                          right: 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ReorderableDragStartListener(
                                              index: index,
                                              child: Container(
                                                color: Colors.transparent,
                                                  width: 30,
                                                  height: 30,
                                                  child: Icon(FontAwesomeIcons.gripVertical, size: 16,)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


class StatisticsExpandedHeader extends StatelessWidget implements PreferredSizeWidget {
  const StatisticsExpandedHeader({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
      actions: [
        InkResponse(
          radius: DodaoTheme.of(context).inkRadius,
          containedInkWell: true,
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.close),
          ),
          onTap: () {
            Navigator.of(context).pop(null);
          },
        ),
      ],
      centerTitle: false,
      elevation: 2,
    );
  }
}
