import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/chat/main.dart';

class ChatPage extends StatefulWidget {
  final double innerPaddingWidth;
  final Task task;


  const ChatPage(
      {Key? key,
        required this.innerPaddingWidth,
        required this.task,
      })
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    final double innerPaddingWidth = widget.innerPaddingWidth;
    final Task task = widget.task;

    return Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(interface.borderRadius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: interface.maxStaticInternalDialogWidth,
                ),
                child: Container(
                    padding: const EdgeInsets.all(6.0),
                    // height: widget.topConstraints.maxHeight,
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(interface.borderRadius),
                    ),
                    child: ChatWidget(task: task, tasksServices: tasksServices)),
              )),
        ));
  }
}