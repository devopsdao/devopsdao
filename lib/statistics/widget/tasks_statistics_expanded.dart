import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/main_widget_list.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/personal_stats.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/score.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_created.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/total_process.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:webthree/credentials.dart';

import '../../blockchain/interface.dart';
import '../../config/theme.dart';
import '../../wallet/model_view/wallet_model.dart';
import '../model_view/horizontal_list_view_model.dart';
import '../model_view/statistics_model_view.dart';


class StatisticsExpandedMain extends StatelessWidget {
  StatisticsExpandedMain({super.key});
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: const StatisticsExpandedHeader(),
      body: const StatisticsExpanded(),
    );
  }
}


class StatisticsExpanded extends StatefulWidget {
  final EthereumAddress? taskAddress;
  const StatisticsExpanded({Key? key, this.taskAddress}) : super(key: key);

  @override
  _StatisticsExpandedState createState() => _StatisticsExpandedState();
}


class _StatisticsExpandedState extends State<StatisticsExpanded> {
  final HorizontalListViewModel horizontalListViewModel = HorizontalListViewModel();
  final StatisticsWidgetsManager _statisticsWidgetsManager = StatisticsWidgetsManager();
  late List<Widget> children;
  late Future<List<Widget>> orderedWidgetsFuture;
  @override
  void initState() {
    super.initState();
    _initializeChildren();
  }

  void _initializeChildren() {
    final listenWalletAddress = context.read<WalletModel>().state.walletAddress;
    children = initializeWidgets(true, walletConnected: listenWalletAddress != null);
    orderedWidgetsFuture = _statisticsWidgetsManager.getOrderedChildren(children, listenWalletAddress != null);
  }

  void _onReorder(int oldIndex, int newIndex) {
    final listenWalletConnected = context.read<WalletModel>().state.walletConnected;
    context.read<StatisticsWidgetsManager>().reorder(oldIndex, newIndex, listenWalletConnected);

    // setState(() {
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    final listenWalletConnected = context.read<WalletModel>().state.walletConnected;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder<List<Widget>>(
        future: orderedWidgetsFuture , /// feature in _initializeChildren() to prevent full screen rebuild
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            // return ValueListenableBuilder<List<int>>(
            //   valueListenable: _statisticsWidgetsManager.orderNotifier,
            //   builder: (context, order, child) {
            // late List<int> order = _statisticsWidgetsManager.getOrderList(listenWalletConnected);
                // final orderedWidgets = order.map((index) => snapshot.data![index]).toList();

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
                              onReorder: (oldIndex, newIndex) {
                                _onReorder(oldIndex, newIndex);
                                setState(() {
                                  if(newIndex > oldIndex){
                                    newIndex -= 1;
                                  }
                                  final items = snapshot.data!.removeAt(oldIndex);
                                  snapshot.data!.insert(newIndex, items);
                                });
                              },
                              buildDefaultDragHandles: false, // Prevents default drag handle
                              proxyDecorator: (child, index, animation) => child,
                              children: List.generate(snapshot.data!.length, (index) {
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
                                            snapshot.data![index],
                                            Positioned(
                                              top: 0.0,
                                              right: 0.0,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ReorderableDragStartListener(
                                                  index: index,
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    width: 30,
                                                    height: 30,
                                                    child: Icon(FontAwesomeIcons.gripVertical, size: 16),
                                                  ),
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
            //   },
            // );
          }
        },
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
            context.read<StatisticsWidgetsManager>().update();
            Navigator.of(context).pop(null);
          },
        ),
      ],
      centerTitle: false,
      elevation: 2,
    );
  }
}
