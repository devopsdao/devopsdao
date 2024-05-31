import 'package:badges/badges.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dodao/widgets/paw_indicator_with_tasks_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';

import '../../config/theme.dart';

import 'package:webthree/webthree.dart';

import '../../wallet/model_view/wallet_model.dart';
import 'loading_model.dart';

class LoadIndicator extends StatefulWidget {
  const LoadIndicator({Key? key}) : super(key: key);

  @override
  _LoadIndicator createState() => _LoadIndicator();
}

class _LoadIndicator extends State<LoadIndicator> {
  bool loadingMonitor = false;
  bool loadingTasks = false;
  double progress = 0.0;
  double progress2 = 0.0;

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    var loadingModel = context.watch<LoadingModel>();

    // if (loadingMonitor) {
    //   progress2 = getLoadingProgress(tasksServices.monitorTasksLoaded, tasksServices.monitorTotalTaskLen);
    // } else {
    //   progress2 = 0.0;
    // }
    loadingTasks = tasksServices.totalTaskLen >= 1;
    // loadingMonitor = tasksServices.monitorTotalTaskLen >= 1;
    if (loadingTasks) {
      progress = loadingModel.getLoadingProgress(tasksServices.tasksLoaded, tasksServices.totalTaskLen);
    } else {
      progress = 0.0;
    }
    return LinearProgressIndicator(
      value: loadingTasks ? progress : progress2,
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(loadingTasks ? Colors.deepOrangeAccent : Colors.orangeAccent),
    );
  }
}

class LoadButtonIndicator extends StatefulWidget {
  const LoadButtonIndicator({
    Key? key,
    required this.refresh,
  }) : super(key: key);
  final String refresh;

  @override
  _LoadButtonIndicator createState() => _LoadButtonIndicator();
}

class _LoadButtonIndicator extends State<LoadButtonIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    return Row(
      children: [
        InkResponse(
          radius: DodaoTheme.of(context).inkRadius,
          containedInkWell: true,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:

                // tasksServices.isLoadingBackground ?
                // LoadingAnimationWidget.threeRotatingDots(
                //   color: DodaoTheme.of(context).primaryText,
                //   size: 24,
                // ) :

                Icon(
              Icons.refresh_outlined,
              color: DodaoTheme.of(context).primaryText,
              // size: 24,
            ),
          ),
          onTap: () {
            if (listenWalletAddress != null) {
              tasksServices.isLoadingBackground = true;
              tasksServices.refreshTasksForAccount(listenWalletAddress, widget.refresh);
            } else {
              tasksServices.fetchTasksByState("new");
            }
          },
        ),
      ],
    );
  }
}
