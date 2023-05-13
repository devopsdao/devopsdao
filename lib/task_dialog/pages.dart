import 'package:dodao/task_dialog/pages/0_topup.dart';
import 'package:dodao/task_dialog/pages/1_main.dart';
import 'package:dodao/task_dialog/pages/3_selection.dart';
import 'package:dodao/task_dialog/pages/2_description.dart';
import 'package:dodao/task_dialog/pages/4_chat.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';
import '../widgets/chat/main.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class TaskDialogPages extends StatefulWidget {
  // final String buttonName;
  final Task task;
  final String fromPage;
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;
  // bool shimmerEnabled;

  const TaskDialogPages({
    Key? key,
    // required this.buttonName,
    required this.task,
    required this.fromPage,
    // required this.shimmerEnabled,
    required this.screenHeightSize,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  @override
  _TaskDialogPagesState createState() => _TaskDialogPagesState();
}

class _TaskDialogPagesState extends State<TaskDialogPages> {

  late bool initDone;
  @override
  void initState() {
    super.initState();
    initDone = true;
  }

  @override
  void dispose() {
    // Don't forget to dispose all of your controllers!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    // var tasksServices = context.watch<TasksServices>();

    Task task = widget.task;
    String fromPage = widget.fromPage;

    // init first page in dialog:
    if (interface.dialogCurrentState['pages']['main'] != null && initDone == true) {
      initDone = false;
      interface.dialogPageNum = interface.dialogCurrentState['pages']['main'];
      interface.dialogPagesController = PageController(initialPage: interface.dialogCurrentState['pages']['main']);
      // print(interface.dialogCurrentState['pages']['main']);
    }
    // else {
    //   print('Initial page in dialog not set! Default is 0');
    //   interface.dialogPageNum = 0;
    //   interface.dialogPagesController = PageController(initialPage: 0);
    // }

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 50;
      // print (dialogConstraints.maxWidth);

        return PageView(
          scrollDirection: Axis.horizontal,
          controller: interface.dialogPagesController,
          onPageChanged: (number) {
            Provider.of<InterfaceServices>(context, listen: false).updateDialogPageNum(number);
          },
          children: <Widget>[
            if (interface.dialogCurrentState['pages'].containsKey('topup'))
              TopUpPage(
                screenHeightSize: widget.screenHeightSize,
                innerPaddingWidth: innerPaddingWidth,
                task: task,
              ),
            if (interface.dialogCurrentState['pages'].containsKey('empty')) const Center(),
            if (interface.dialogCurrentState['pages'].containsKey('main'))
              MainTaskPage(
                innerPaddingWidth: innerPaddingWidth,
                task: task,
                borderRadius: interface.borderRadius,
                fromPage: fromPage,
              ),
            if (interface.dialogCurrentState['pages'].containsKey('description'))
              DescriptionPage(
                screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,
                innerPaddingWidth: innerPaddingWidth,
                task: task,
                fromPage: fromPage,
              ),
            if (interface.dialogCurrentState['pages'].containsKey('select'))
              SelectionPage(
                  screenHeightSize: widget.screenHeightSize,
                  innerPaddingWidth: innerPaddingWidth,
                  task: task
              ),

            if (interface.dialogCurrentState['pages'].containsKey('widgets.chat'))
              ChatPage(task: task, innerPaddingWidth: innerPaddingWidth)
          ],
        );
    });
  }
}
