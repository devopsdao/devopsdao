import 'package:flutter/material.dart';
import 'package:webthree/credentials.dart';
import '../blockchain/classes.dart';
import 'main.dart';
import 'package:beamer/beamer.dart';

class TaskDialogBeamer extends StatefulWidget {
  final String fromPage;
  final EthereumAddress? taskAddress;
  const TaskDialogBeamer({Key? key, this.taskAddress, required this.fromPage}) : super(key: key);

  @override
  _TaskDialogBeamerState createState() => _TaskDialogBeamerState();
}

class _TaskDialogBeamerState extends State<TaskDialogBeamer> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String taskAddressString = widget.taskAddress.toString();
    RouteInformation routeInfo = RouteInformation(location: '/${widget.fromPage}/$taskAddressString');
    Beamer.of(context).updateRouteInformation(routeInfo);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
        alignment: Alignment.center,
        child: TaskDialogFuture(fromPage: widget.fromPage, taskAddress: widget.taskAddress!),
      )
    );
  }
}
