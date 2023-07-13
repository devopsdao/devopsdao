// import 'package:dodao/widgets/tags/search_services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../blockchain/task_services.dart';
//
//
// class SearchFilterRoute extends StatelessWidget {
//   final String page;
//   final int tabIndex;
//   const SearchFilterRoute({
//     Key? key,
//     required this.page,
//     required this.tabIndex,
//   }) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     var searchServices = context.read<SearchServices>();
//     var tasksServices = context.read<TasksServices>();
//     if (page == 'audit') {
//       if (tabIndex == 0) {
//         tasksServices.runFilter(taskList: tasksServices.tasksAuditPending,
//           tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
//       } else if (tabIndex == 1) {
//         tasksServices.runFilter(taskList: tasksServices.tasksAuditApplied,
//           tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
//       } else if (tabIndex == 2) {
//         tasksServices.runFilter(taskList: tasksServices.tasksAuditWorkingOn,
//           tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
//       } else if (tabIndex == 3) {
//         tasksServices.runFilter(taskList: tasksServices.tasksAuditComplete,
//           tagsMap: searchServices.auditorTagsList, enteredKeyword: searchServices.searchKeywordController.text, );
//       }
//
//     } else if (page == 'tasks') {
//       tasksServices.runFilter(
//           taskList: tasksServices.tasksNew,
//           tagsMap: searchServices.tasksTagsList,
//           enteredKeyword: searchServices.searchKeywordController.text);
//     } else if (page == 'customer') {
//       if (tabIndex == 0) {
//         tasksServices.runFilter(taskList:tasksServices.tasksCustomerSelection,
//             tagsMap: searchServices.customerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
//       } else if (tabIndex == 1) {
//         tasksServices.runFilter(taskList:tasksServices.tasksCustomerProgress,
//             tagsMap: searchServices.customerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
//       } else if (tabIndex == 2) {
//         tasksServices.runFilter(taskList:tasksServices.tasksCustomerComplete,
//             tagsMap: searchServices.customerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
//       }
//     } else if (page == 'performer') {
//       if (tabIndex == 0) {
//         tasksServices.runFilter(taskList: tasksServices.tasksPerformerParticipate,
//             tagsMap: searchServices.performerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
//       } else if (tabIndex == 1) {
//         tasksServices.runFilter(taskList: tasksServices.tasksPerformerProgress,
//             tagsMap: searchServices.performerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
//       } else if (tabIndex == 2) {
//         tasksServices.runFilter(taskList: tasksServices.tasksPerformerComplete,
//             tagsMap: searchServices.performerTagsList, enteredKeyword: searchServices.searchKeywordController.text);
//       }
//     } else if (page == 'customer') {
//       if (tabIndex == 0) {
//         tasksServices.runFilter(
//             taskList: tasksServices.tasksCustomerSelection,
//             enteredKeyword: searchServices.searchKeywordController.text,
//             tagsMap: searchServices.customerTagsList );
//       } else if (tabIndex == 1) {
//         tasksServices.runFilter(
//             taskList: tasksServices.tasksCustomerProgress,
//             enteredKeyword: searchServices.searchKeywordController.text,
//             tagsMap: searchServices.customerTagsList );
//       } else if (tabIndex == 2) {
//         tasksServices.runFilter(
//             taskList: tasksServices.tasksCustomerComplete,
//             enteredKeyword: searchServices.searchKeywordController.text,
//             tagsMap: searchServices.customerTagsList );
//       }
//     }
//
//     return const Center();
//   }
// }