import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task.dart';
import '../../blockchain/task_services.dart';

class SelectedPage extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerWidth;
  final Task task;


  const SelectedPage(
      {Key? key,
        required this.screenHeightSizeNoKeyboard,
        required this.innerWidth,
        required this.task,
      })
      : super(key: key);

  @override
  _SelectedPageState createState() => _SelectedPageState();
}

class _SelectedPageState extends State<SelectedPage> {


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double innerWidth = widget.innerWidth;
    final Task task = widget.task;

    return Center(

    );
  }
}