import 'package:dodao/blockchain/empty_classes.dart';
import 'package:dodao/task_dialog/pages.dart';
import 'package:dodao/task_dialog/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webthree/credentials.dart';
import '../blockchain/interface.dart';
import '../blockchain/classes.dart';
import '../blockchain/task_services.dart';

import '../config/theme.dart';
import '../wallet/model_view/wallet_model.dart';
import 'header.dart';
import 'model_view/task_model_view.dart';
import 'model_view/task_update_model_view.dart';
import 'shimmer.dart';

// Name of Widget & TaskDialogBeamer > TaskDialogFuture > Skeleton > Header > Pages > (topup, main, deskription, selection, widgets.chat)

class TaskDialogFuture extends StatelessWidget {
  const TaskDialogFuture({super.key, required this.fromPage, required this.taskAddress});
  final String fromPage;
  final EthereumAddress taskAddress;
  @override
  Widget build(BuildContext context) {
      return  MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TaskModelView()),
          ChangeNotifierProvider(create: (context) => TaskUpdateModelView()),
        ],
        child: _TaskDialogFuture(fromPage: fromPage, taskAddress: taskAddress,),
      );
  }
}


class _TaskDialogFuture extends StatefulWidget {
  final String fromPage;
  final EthereumAddress taskAddress;
  const _TaskDialogFuture({
    Key? key,
    required this.fromPage,
    required this.taskAddress,
  }) : super(key: key); 

  @override
  _TaskDialogFutureState createState() => _TaskDialogFutureState();
}

class _TaskDialogFutureState extends State<_TaskDialogFuture> {
  late Map<String, dynamic> dialogState;


  @override
  void initState() {
    super.initState();
    TaskUpdateModelView taskUpdateModelView = context.read<TaskUpdateModelView>();
    taskUpdateModelView.subscribeToTaskUpdate();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   var tasksServices = context.read<TasksServices>();
    // });
  }


  //// unsubscribe statistics broadcast:
  late TaskUpdateModelView _disposeSub;
  @override
  void didChangeDependencies() {
    _disposeSub = context.read<TaskUpdateModelView>();
    super.didChangeDependencies();
  }
  @override
  Future<void> dispose() async {
    _disposeSub.unsubscribeTaskUpdate();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    TaskUpdateModelView taskUpdateModelView = context.watch<TaskUpdateModelView>();
    final emptyClasses = EmptyClasses();

    return FutureBuilder<Task>(
      future: tasksServices.loadOneTask(widget.taskAddress), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Task> snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            emptyClasses.loadingTask.description = snapshot.error.toString();
            return TaskDialogSkeleton(fromPage: widget.fromPage, task: emptyClasses.loadingTask, isLoading: false);
          } else if (snapshot.hasData) {
            taskUpdateModelView.onOpenedTask(snapshot.data!.taskAddress);
            return TaskDialogSkeleton(fromPage: widget.fromPage, task: snapshot.data!, isLoading: false);
          } else {
            return const Text('Empty data');
          }
        }
        return TaskDialogSkeleton(fromPage: widget.fromPage, task: emptyClasses.loadingTask, isLoading: true);
      }
    );
  }
}

class TaskDialogSkeleton extends StatefulWidget {
  final String fromPage;
  final Task task;
  final bool isLoading;
  const TaskDialogSkeleton({
    Key? key,
    required this.task,
    required this.fromPage,
    required this.isLoading,
  }) : super(key: key);

  @override
  _TaskDialogSkeletonState createState() => _TaskDialogSkeletonState();
}

class _TaskDialogSkeletonState extends State<TaskDialogSkeleton> {
  // String backgroundPicture = "assets/images/niceshape.png";

  late Map<String, dynamic> dialogState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.read<InterfaceServices>();
    var tasksServices = context.read<TasksServices>();
    final listenAllowedChainId = context.select((WalletModel vm) => vm.state.allowedChainId);
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    final task = widget.task;

    String fromPage = widget.fromPage;

    // if (widget.fromPage == 'customer') {
    //   backgroundPicture = "assets/images/cross.png";
    // } else if (widget.fromPage == 'performer') {
    //   backgroundPicture = "assets/images/cyrcle.png";
    // } else if (widget.fromPage == 'audit') {
    //   backgroundPicture = "assets/images/cross.png";
    // }

    if (task.taskState == 'empty' || task.taskState == 'loading') {
      interface.dialogCurrentState = dialogStates['empty'];
    } else if (fromPage == 'last-activities') {
      interface.dialogCurrentState = dialogStates['last-activities'];
    } else if (fromPage == 'tasks' && listenWalletAddress == null && !listenAllowedChainId) {
      interface.dialogCurrentState = dialogStates['tasks-new-not-logged'];
    } else if (fromPage == 'tasks' && listenWalletAddress != null && listenAllowedChainId) {
      interface.dialogCurrentState = dialogStates['tasks-new-logged'];
    } else if (fromPage == 'customer' && task.taskState == 'new') {
      interface.dialogCurrentState = dialogStates['customer-new'];
    } else if (fromPage == 'performer' && task.taskState == 'new') {
      interface.dialogCurrentState = dialogStates['performer-new'];
    } else if (task.taskState == 'agreed' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-agreed'];
    } else if (task.taskState == 'progress' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-progress'];
    } else if (task.taskState == 'review' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-review'];
    } else if (task.taskState == 'completed' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-completed'];
    } else if (task.taskState == 'canceled' && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-canceled'];
    } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-audit-requested'];
    } else if ((task.taskState == 'audit' && task.auditState == 'performing') && (fromPage == 'customer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['customer-audit-performing'];
    } else if (task.taskState == 'agreed' && fromPage == 'performer') {
      interface.dialogCurrentState = dialogStates['performer-agreed'];
    } else if (task.taskState == 'progress' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-progress'];
    } else if (task.taskState == 'review' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-review'];
    } else if (task.taskState == 'completed' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-completed'];
    } else if (task.taskState == 'canceled' && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-canceled'];
    } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-audit-requested'];
    } else if ((task.taskState == 'audit' && task.auditState == 'performing') && (fromPage == 'performer' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['performer-audit-performing'];
    } else if ((task.taskState == 'audit' && task.auditState == 'requested') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      if (task.auditors.isNotEmpty) {
        for (var i = 0; i < task.auditors.length; i++) {
          if (task.auditors[i] == listenWalletAddress) {
            interface.dialogCurrentState = dialogStates['auditor-applied'];
            break;
          } else {
            interface.dialogCurrentState = dialogStates['auditor-new'];
          }
        }
      } else {
        interface.dialogCurrentState = dialogStates['auditor-new'];
      }
    } else if ((task.taskState == 'audit' && task.auditState == 'performing') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['auditor-performing'];
    } else if ((task.taskState == 'audit' && task.auditState == 'finished') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      // taskState = audit & auditState = finished - will not fires anyway. Should be deleted
      interface.dialogCurrentState = dialogStates['auditor-finished'];
    } else if ((task.taskState == 'completed' && task.auditState == 'finished') && (fromPage == 'auditor' || tasksServices.hardhatDebug == true)) {
      interface.dialogCurrentState = dialogStates['auditor-finished'];
    }

    return LayoutBuilder(builder: (context, constraints) {
      // ****** Count Screen size with keyboard and without ***** ///
      // final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
      // final double screenHeightSizeNoKeyboard = constraints.maxHeight;
      // final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;

      final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
      final double screenHeightSizeNoKeyboard = constraints.maxHeight;
      final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
      final statusBarHeight = MediaQuery.of(context).viewPadding.top;
      return Container(
        color: DodaoTheme.of(context).taskBackgroundColor,
        // decoration: BoxDecoration(
        //   borderRadius: DodaoTheme.of(context).borderRadius,
        //   border: DodaoTheme.of(context).borderGradient,
        // ),
        // color: Colors.redAccent,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: statusBarHeight,
          ),
          TaskDialogHeader(
            task: task,
            fromPage: fromPage,
          ),
          SizedBox(
            height: screenHeightSizeNoKeyboard - 58 -statusBarHeight,
            width: InterfaceSettings.maxStaticDialogWidth,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeInQuint,
              switchOutCurve: Curves.easeOutQuint,
              child: !widget.isLoading
                  ? TaskDialogPages(
                // key: const Key("normal"),
                task: task,
                fromPage: widget.fromPage,
                screenHeightSize: screenHeightSize,
                screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard - statusBarHeight,
              )
                  : ShimmeredTaskPages(
                key: const Key("loading"),
                task: task,
              ),
            )
          ),
        ]),
      );
    });
  }
}
