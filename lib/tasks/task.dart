import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../custom_widgets/task_dialog.dart';

class TaskDialog extends StatefulWidget {
  final String taskAddress;
  const TaskDialog({
    Key? key,
    required this.taskAddress,
  }) : super(key: key);

  @override
  _TaskDialog createState() => _TaskDialog();
}

class _TaskDialog extends State<TaskDialog> {
  late Task task;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();

    task = tasksServices.filterResults[widget.taskAddress]!;
    print('taskAddress: ${widget.taskAddress}');

    return TaskInformationDialog(
      role: 'tasks',
      object: task,
    );
  }
}
