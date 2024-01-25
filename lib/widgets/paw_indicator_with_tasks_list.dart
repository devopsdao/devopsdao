
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../blockchain/empty_classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../task_dialog/task_transition_effect.dart';
import '../task_item/task_item.dart';
import '../task_item/task_shimmer.dart';
import '../wallet/model_view/wallet_model.dart';

class PawRefreshAndTasksList extends StatefulWidget {
  final String pageName;
  final RiveFile? paw;
  const PawRefreshAndTasksList({Key? key, required this.pageName, required this.paw}) : super(key: key);

  @override
  PawRefreshAndTasksListState createState() => PawRefreshAndTasksListState();
}

class PawRefreshAndTasksListState extends State<PawRefreshAndTasksList> {
  late bool loadingIndicator = false;
  bool enableRatingButton = false;
  double ratingScore = 0;
  // late RiveAnimationController _controller;
  final GlobalKey<CustomRefreshIndicatorState> indicator = GlobalKey<CustomRefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    // preload();
    // Future.delayed(const Duration(milliseconds: 300)).then((_) {
    //   indicator.currentState!.refresh( );
    // });
    // _controller = SimpleAnimation('idle');
  }

  SMITrigger? _bump;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    controller!.isActive = false;
    artboard.addController(controller!);
    _bump = controller.findInput<bool>('Trigger 1') as SMITrigger;
    // _bump?.controller.isActive = false;

  }

  Future<void> _hitBump() async {
    _bump?.fire();
  }

  @override
  Widget build(BuildContext context) {
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    var tasksServices = context.watch<TasksServices>();
    final emptyClasses = EmptyClasses();
    List objList = tasksServices.filterResults.values.toList();
    late double offsetToArmed = 200;
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
        child: CustomRefreshIndicator(
          key: indicator,
          offsetToArmed: offsetToArmed,
          completeStateDuration: const Duration(milliseconds: 1500),
          onRefresh: () async {
            tasksServices.isLoadingBackground = true;
            if (widget.pageName == 'customer') {
              if (listenWalletAddress != null) {
                await tasksServices.fetchTasksCustomer(listenWalletAddress);
              }
            } else if (widget.pageName == 'performer') {
              if (listenWalletAddress != null) {
                await tasksServices.fetchTasksPerformer(listenWalletAddress);
              }
            } else if (widget.pageName == 'tasks') {
              if (listenWalletAddress != null) {
                await tasksServices.fetchTasksByState('new');
              }
            }
            _hitBump();
          },
          onStateChanged: (state) {
            // print(state);
            if (state == const IndicatorStateChange(IndicatorState.idle, IndicatorState.dragging)) {
              _bump?.controller.isActive = true;
            }
            if (state == const IndicatorStateChange(IndicatorState.dragging, IndicatorState.canceling)) {
              _bump?.controller.isActive = false;
            }
            if (state == const IndicatorStateChange(IndicatorState.finalizing, IndicatorState.idle)) {
              _bump?.controller.isActive = false;
            }
          },
          builder: (BuildContext context, Widget child, IndicatorController controller) {
            return AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  List shimmeredTasks = [];
                  if (objList.length <= 1) {
                    shimmeredTasks = [emptyClasses.tasksForShimmer.values.toList().first];
                  } else if (objList.length == 2) {
                    shimmeredTasks = [emptyClasses.tasksForShimmer.values.toList().first, emptyClasses.tasksForShimmer.values.toList().last];
                  } else if (objList.length == 3) {
                    shimmeredTasks = emptyClasses.tasksForShimmer.values.toList();
                  } else if (objList.length == 4) {
                    shimmeredTasks = [
                      emptyClasses.tasksForShimmer.values.toList().first,
                      emptyClasses.tasksForShimmer.values.toList().last,
                      emptyClasses.tasksForShimmer.values.toList()[1],
                      emptyClasses.tasksForShimmer.values.toList().last
                    ];
                  } else if (objList.length >= 5) {
                    shimmeredTasks = [
                      emptyClasses.tasksForShimmer.values.toList().first,
                      emptyClasses.tasksForShimmer.values.toList()[1],
                      emptyClasses.tasksForShimmer.values.toList()[2],
                      emptyClasses.tasksForShimmer.values.toList().last,
                      emptyClasses.tasksForShimmer.values.toList()[1],
                    ];
                  }
                  // print(controller.isDragging);
                  return Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: offsetToArmed * controller.value,
                        child: SizedBox(
                          child: (widget.paw == null)
                              ? const SizedBox.shrink()
                              : RiveAnimation.direct(widget.paw!,
                            fit: BoxFit.fitHeight,
                            // stateMachines: const ['State Machine 1'],
                            // controllers: [_controller],
                            onInit: _onRiveInit,),

                          // RiveAnimation.asset(
                          //   'assets/rive_animations/paw.riv',
                          //   fit: BoxFit.fitHeight,
                          //   stateMachines: const ['State Machine 1'],
                          //   // controllers: [_controller],
                          //   onInit: _onRiveInit,
                          // ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0.0, offsetToArmed * controller.value),
                        child: controller.isLoading || controller.isComplete
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                itemCount: shimmeredTasks.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                                      child: TaskItemShimmer(
                                        fromPage: widget.pageName,
                                        task: shimmeredTasks[index],
                                      ));
                                },
                              )
                            : child,
                      )
                    ],
                  );
                },
                child: child);
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: objList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                child: TaskTransition(
                  fromPage: widget.pageName,
                  task: objList[index],
                )
              );
            },
          ),
        ));
  }
}
