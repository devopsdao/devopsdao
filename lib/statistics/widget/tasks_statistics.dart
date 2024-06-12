import 'dart:ui';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dodao/statistics/model_view/horizontal_list_view_model.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/goto.dart';
import 'package:dodao/statistics/widget/tasks_statistics_widgets/main_widget_list.dart';
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
  // final StatisticsWidgetsManager _statisticsWidgetsManager = StatisticsWidgetsManager();
  late List<Widget> children;
  late Future<List<Widget>> orderedWidgetsFuture;
  double widgetHeight = 164;
  @override
  void initState() {
    super.initState();
    // _initializeChildren();
  }

  // void _initializeChildren() {
  //   final listenWalletAddress = context.read<WalletModel>().state.walletAddress;
  //   children = initializeWidgets(false, walletConnected: listenWalletAddress != null);
  //   orderedWidgetsFuture = _statisticsWidgetsManager.getStatsWidgets(children);
  // }

  bool _containsGotoStatisticsContainer(List<Widget> widgets) {
    return widgets.any((widget) => widget is Container && widget.child is GotoStatistics);
  }

  @override
  Widget build(BuildContext context) {
    final listenWalletConnected = context.watch<WalletModel>().state.walletConnected;
    final statisticsWidgetsManager = context.watch<StatisticsWidgetsManager>();


    return ChangeNotifierProvider.value(
      value: horizontalListViewModel,
      child: FutureBuilder<List<Widget>>(
        future: statisticsWidgetsManager.getStatsWidgets(initializeWidgets(false, walletConnected: listenWalletConnected)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: SizedBox(
                height: widgetHeight,
                child: const CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            late List<int> order = List.from(statisticsWidgetsManager.getOrderList(listenWalletConnected));
            late List<Widget> items = snapshot.data!;
            if (!_containsGotoStatisticsContainer(items)) {
              items.add(
                Container(
                  width: 220,
                  child: const GotoStatistics(extended: false),
                ),
              );
            }
            order.add(order.length); // for extra widget "goto stat page"

            final orderedWidgets = order.map((index) => items[index]).toList();
            List<double> itemWidths = orderedWidgets.map((child) {
              if (child is Container) {
                return child.constraints?.minWidth ?? 0.0;
              }
              return 0.0;
            }).toList();
            // itemWidths.add(220); // for extra widget "goto stat page"
            // if (!_containsGotoStatisticsContainer(items)) {
            // }
              order.removeLast(); // don't forget to remove an extra order value

            _controller.itemWidths = itemWidths;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              horizontalListViewModel.updateItemWidths(itemWidths);
            });

            return ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SizedBox(
                height: widgetHeight,
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
                        child: orderedWidgets[index],
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
//
// class TasksStatistics extends StatefulWidget {
//   const TasksStatistics({super.key});
//
//   @override
//   State<TasksStatistics> createState() => _TasksStatisticsState();
// }
//
// class _TasksStatisticsState extends State<TasksStatistics> with TickerProviderStateMixin {
//   final HorizontalListViewController _controller = HorizontalListViewController();
//   final HorizontalListViewModel horizontalListViewModel = HorizontalListViewModel();
//   late StatisticsWidgetsManager _statisticsWidgetsManager;
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _statisticsWidgetsManager = context.read<StatisticsWidgetsManager>();
//   }
//
//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //   _updateChildren();
//   // }
//
//   // late List<Widget> initialWidgetList;
//
//   // List<Widget> _updateChildren() {
//   //   final listenWalletAddress = context.read<WalletModel>().state.walletAddress;
//   //   List<Container> initialWidgetList;
//   //   return  initialWidgetList = [
//   //     if (listenWalletAddress != null)
//   //       Container(
//   //         width: 180,
//   //         child: const ScoreStats(extended: false),
//   //       ),
//   //     Container(
//   //       width: 280,
//   //       child: const TotalProcessStats(extended: false),
//   //     ),
//   //     Container(
//   //       width: 250,
//   //       child: const TotalCreatedStats(extended: false),
//   //     ),
//   //     if (listenWalletAddress != null)
//   //       Container(
//   //         width: 300,
//   //         child: const PersonalStats(extended: false),
//   //       ),
//   //   ];
//   //
//   //   // initialWidgetList.add(
//   //   //   Container(
//   //   //     width: 220,
//   //   //     child: const GotoStatistics(extended: false),
//   //   //   ),
//   //   // );
//   //
//   //   // List<double> itemWidths = [
//   //   //   if (listenWalletAddress != null)
//   //   //     180,
//   //   //   280,
//   //   //   250,
//   //   //   if (listenWalletAddress != null)
//   //   //     300,
//   //   //   220];
//   //
//   //
//   //
//   //   // setState(() {});
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final listenWalletConnected = context.watch<WalletModel>().state.walletConnected;
//     final statisticsWidgetsManager = context.watch<StatisticsWidgetsManager>();
//
//     List<Widget> initialWidgetList = [
//       if (listenWalletConnected)
//         Container(
//           width: 180,
//           child: const ScoreStats(extended: false),
//         ),
//       Container(
//         width: 280,
//         child: const TotalProcessStats(extended: false),
//       ),
//       Container(
//         width: 250,
//         child: const TotalCreatedStats(extended: false),
//       ),
//       if (listenWalletConnected)
//         Container(
//           width: 300,
//           child: const PersonalStats(extended: false),
//         ),
//     ];
//
//     return ChangeNotifierProvider.value(
//       value: horizontalListViewModel,
//       child: ChangeNotifierProvider.value(
//         value: _statisticsWidgetsManager,
//         child: FutureBuilder<List<Widget>>(
//           future: statisticsWidgetsManager.getStatsWidgets(initialWidgetList),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('No data available'));
//             } else {
//
//               // return ValueListenableBuilder<List<int>>(
//               //     valueListenable: _statisticsWidgetsManager.orderNotifier,
//               //     builder: (context, order, child) {
//               late List<int> order = _statisticsWidgetsManager.getOrderList(listenWalletConnected);
//               print(order);
//               // late List<int> order;
//               // if (listenWalletConnected) {
//               //   order = _statisticsWidgetsManager.largeListOrderIndex;
//               // } else {
//               //   order = _statisticsWidgetsManager.smallListOrderIndex;
//               // }
//               // go to stat page
//               snapshot.data!.add(
//                 Container(
//                   width: 220,
//                   child: const GotoStatistics(extended: false),
//                 ),
//               );
//               order.add(order.length); // for extra widget "goto stat page"
//               final orderedWidgets = order.map((index) => snapshot.data![index]).toList();
//               List<double> itemWidths = orderedWidgets.map((child) {
//                 if (child is Container) {
//                   return child.constraints?.minWidth ?? 0.0;
//                 }
//                 return 0.0;
//               }).toList();
//               // itemWidths.add(220); // for extra widget "goto stat page"
//               order.removeLast(); // don't forget to remove an extra order value
//
//               _controller.itemWidths = itemWidths;
//               WidgetsBinding.instance.addPostFrameCallback((_) async {
//                 horizontalListViewModel.updateItemWidths(itemWidths);
//               });
//
//               return ScrollConfiguration(
//                 behavior: ScrollConfiguration.of(context).copyWith(
//                   dragDevices: {
//                     PointerDeviceKind.touch,
//                     PointerDeviceKind.mouse,
//                   },
//                 ),
//                 child: SizedBox(
//                   height: 164,
//                   child: HorizontalListView.builder(
//                     alignment: CrossAxisAlignment.start,
//                     crossAxisSpacing: 12,
//                     controller: _controller,
//                     itemWidths: _controller.itemWidths,
//                     itemCount: _controller.itemWidths.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return BlurryContainer(
//                         blur: 3,
//                         color: DodaoTheme.of(context).transparentCloud,
//                         padding: const EdgeInsets.all(0.5),
//                         child: Container(
//                           padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
//                           decoration: BoxDecoration(
//                             borderRadius: DodaoTheme.of(context).borderRadius,
//                             border: DodaoTheme.of(context).borderGradient,
//                           ),
//                           child: orderedWidgets[index],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               );
//               //   } // *** builder
//               // ); // *** ValueListenableBuilder
//             }
//
//           },
//         ),
//       ),
//     );
//   }
// }
