import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';

import '../../blockchain/empty_classes.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/chat/main.dart';

class ChatPage extends StatelessWidget {
  final double innerPaddingWidth;
  final Task task;


  const ChatPage(
      {Key? key,
        required this.innerPaddingWidth,
        required this.task,
      })
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var emptyClasses = context.watch<EmptyClasses>();

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
                    child: ChatWidget(
                      task: task, account:
                      emptyClasses.emptyAccount,
                      tasksServices: tasksServices
                    )),
              )),
        ));
  }
}