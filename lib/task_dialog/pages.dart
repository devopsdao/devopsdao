import 'package:devopsdao/task_dialog/pages/0_topup.dart';
import 'package:devopsdao/task_dialog/pages/1_main.dart';
import 'package:devopsdao/task_dialog/pages/3_selection.dart';
import 'package:devopsdao/task_dialog/pages/2_description.dart';
import 'package:devopsdao/task_dialog/pages/4_chat.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blockchain/interface.dart';
import '../blockchain/task.dart';
import '../blockchain/task_services.dart';
import '../chat/main.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, chat)

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
  double ratingScore = 0;

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
    var tasksServices = context.watch<TasksServices>();


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

        // pageSnapping: false,
        // physics: ((
        //   fromPage == 'tasks' ||
        //   fromPage == 'auditor' ||
        //   fromPage == 'performer') &&
        //   interface.di6666Num == 1)
        //     ? const RightBlockedScrollPhysics() : null,
        // physics: BouncingScrollPhysics(),
        // physics: const NeverScrollableScrollPhysics(),
        controller: interface.dialogPagesController,
        onPageChanged: (number) {
          Provider.of<InterfaceServices>(context, listen: false).updateDialogPageNum(number);
        },
        children: <Widget>[
          // GestureDetector(
          //   child: RiveAnimation.file(
          //     'assets/rive_animations/rating_animation.riv',
          //     fit: BoxFit.fitWidth,
          //     onInit: _onRiveInit,
          //   ),
          //   onTap: _hitBump,
          // ),
          // Shimmer.fromColors(
          //   baseColor: Colors.grey[300]!,
          //   highlightColor: Colors.grey[100]!,
          //   enabled: shimmerEnabled,
          //   child:
          if (interface.dialogCurrentState['pages'].containsKey('topup'))
            TopUpPage(
              screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,
              screenHeightSize: widget.screenHeightSize,
              innerPaddingWidth: innerPaddingWidth,
              task: task,),
          if (interface.dialogCurrentState['pages'].containsKey('empty'))
            const Center(),
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
              fromPage: fromPage,),
          if (interface.dialogCurrentState['pages'].containsKey('select'))
            SelectionPage(screenHeightSize: widget.screenHeightSize, innerPaddingWidth: innerPaddingWidth, task: task),

          if (interface.dialogCurrentState['pages'].containsKey('chat'))
            ChatPage(
              task: task,
              innerPaddingWidth: innerPaddingWidth)
        ],
      );
    });
  }
}

