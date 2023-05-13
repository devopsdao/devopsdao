import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../blockchain/accounts.dart';
import '../../blockchain/empty_classes.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/classes.dart';
import '../../blockchain/task_services.dart';
import '../../widgets/chat/main.dart';

class AccountsChatPage extends StatelessWidget {
  final double innerPaddingWidth;
  final Account account;


  const AccountsChatPage(
      {Key? key,
        required this.innerPaddingWidth,
        required this.account,
      })
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var emptyClasses = context.watch<EmptyClasses>();

    return Center(
        child: Container(
          // padding: const EdgeInsets.all(12),
          child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(interface.borderRadius),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // maxWidth: interface.maxStaticInternalDialogWidth,
                ),
                child: Container(
                    // padding: const EdgeInsets.all(6.0),
                    // height: widget.topConstraints.maxHeight,
                    // width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(interface.borderRadius),
                    ),
                    child: ChatWidget(
                        // account: account,
                        task: emptyClasses.emptyTask,
                        tasksServices: tasksServices)),
              )),
        ));
  }
}