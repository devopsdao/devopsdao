import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../custom_widgets/task_dialog.dart';

class TaskDialog extends StatefulWidget {
  final String nanoId;
  const TaskDialog({
    Key? key,
    required this.nanoId,
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

    // final index = widget.nanoId;
    task = tasksServices.filterResults[widget.nanoId]!;
    print('nanoId: ${widget.nanoId}');

    return TaskInformationDialog(role: 'exchange', object: task!,);

  }
}
