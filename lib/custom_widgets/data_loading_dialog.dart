import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';

class AppDataLoadingDialog extends StatefulWidget {
  const AppDataLoadingDialog({Key? key}) : super(key: key);

  @override
  _AppDataLoadingDialog createState() => _AppDataLoadingDialog();
}

class _AppDataLoadingDialog extends State<AppDataLoadingDialog> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // if (tasksServices.tasksCustomerSelection[widget.taskAddress] != null) {
    //   task = tasksServices.tasksCustomerSelection[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerProgress[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerProgress[widget.taskAddress]!;
    // } else if (tasksServices.tasksCustomerComplete[widget.taskAddress] !=
    //     null) {
    //   task = tasksServices.tasksCustomerComplete[widget.taskAddress]!;
    // }

    return const AppDataLoadingDialogWidget();
  }
}

class AppDataLoadingDialogWidget extends StatefulWidget {
  // final int taskCount;
  const AppDataLoadingDialogWidget({Key? key}) : super(key: key);

  @override
  _AppDataLoadingDialogWidgetState createState() =>
      _AppDataLoadingDialogWidgetState();
}

class _AppDataLoadingDialogWidgetState
    extends State<AppDataLoadingDialogWidget> {
  late Task task;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    final double borderRadius = interface.borderRadius;

    return Dialog(
        insetPadding: const EdgeInsets.all(30),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: 400,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    child: InkWell(
                      onTap: () {
                        interface.controller.animateToPage(0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        height: 30,
                        width: 30,
                        child: Row(
                          children: const <Widget>[
                            Expanded(
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
