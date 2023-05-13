import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/empty_classes.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
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

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(bottom: 14),
            child: Material(
                elevation: DodaoTheme.of(context).elevation,
                borderRadius: DodaoTheme.of(context).borderRadius,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: interface.maxStaticInternalDialogWidth,
                  ),
                  child: Container(
                      padding: const EdgeInsets.all(6.0),
                      // height: widget.topConstraints.maxHeight,
                      width: innerPaddingWidth,
                      decoration: BoxDecoration(
                        borderRadius: DodaoTheme.of(context).borderRadius,
                        border: DodaoTheme.of(context).borderGradient,
                      ),
                      child:
                      ChatWidget(
                        task: task,
                        tasksServices: tasksServices
                      )
                  ),
                )),
          ),
        ));
  }
}