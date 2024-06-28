//
// import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
// import 'package:easy_infinite_pagination/easy_infinite_pagination.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../blockchain/classes.dart';
// import '../blockchain/task_services.dart';
// import '../task_dialog/task_transition_effect.dart';
//
// class PawRefreshAndTasksList extends StatefulWidget {
//   final String pageName;
//   const PawRefreshAndTasksList({Key? key, required this.pageName, }) : super(key: key);
//
//   @override
//   PawRefreshAndTasksListState createState() => PawRefreshAndTasksListState();
// }
//
// class PawRefreshAndTasksListState extends State<PawRefreshAndTasksList> {
//   final GlobalKey<CustomRefreshIndicatorState> indicator = GlobalKey<CustomRefreshIndicatorState>();
//   @override
//   void initState() {
//     super.initState();
//     // _fetchData();
//   }
//
//   List<Task> filterResults = [];
//   List<Task> _newList = [];
//   bool _isLoading = false;
//   int _currentIndex = 0;
//   final int batchSize = 20;
//   int end = 0;
//
//   void _fetchData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     await Future.delayed(const Duration(milliseconds: 600));
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     var tasksServices = context.watch<TasksServices>();
//     final filterResults = tasksServices.filterResults.values.toList();
//     if (_currentIndex >= filterResults.length) {
//       _currentIndex = 0;
//       end = 0;
//       _newList.clear();
//     }
//
//     end = (_currentIndex + batchSize < filterResults.length) ? _currentIndex + batchSize : filterResults.length;
//     _newList.addAll(filterResults.sublist(_currentIndex, end));
//     _currentIndex = end;
//
//     return InfiniteListView(
//
//       delegate: PaginationDelegate(
//         itemCount: _newList.length,
//         itemBuilder: (_, index) => Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
//             child: TaskTransition(
//               fromPage: widget.pageName,
//               task: _newList[index],
//             )
//         ),
//         // hasReachedMax: true,
//         isLoading: _isLoading,
//         onFetchData: _fetchData,
//       ),
//     );
//   }
// }
