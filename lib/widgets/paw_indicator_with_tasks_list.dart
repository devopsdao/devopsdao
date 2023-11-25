
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../blockchain/empty_classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../task_dialog/task_transition_effect.dart';
import '../task_item/task_item.dart';

class PawRefreshAndTasksList extends StatefulWidget {
  final String pageName;
  const PawRefreshAndTasksList({Key? key, required this.pageName}) : super(key: key);

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
    // Future.delayed(const Duration(milliseconds: 300)).then((_) {
    //   indicator.currentState!.refresh( );
    // });
    // _controller = SimpleAnimation('idle');
  }

  SMITrigger? _bump;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _bump = controller.findInput<bool>('Trigger 1') as SMITrigger;
  }

  Future<void> _hitBump() async {
    _bump?.fire();
    // print('_hitBump _controller: ${_controller.isActive}');
  }

  void runPaw() {
    // print('runPaw!!');
    // Future.delayed(const Duration(milliseconds: 300)).then((_) {
    //   indicator2.currentState!.refresh(
    //     // draggingCurve: Curves.easeOutBack,
    //   );
    //
    //   // Future.delayed(const Duration(milliseconds: 700)).then((_) {
    //   //   indicator.currentState!.refresh(
    //   //     // draggingCurve: Curves.easeOutBack,
    //   //   );
    //   // });
    // });
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();
    var emptyClasses = context.read<EmptyClasses>();
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
              if (tasksServices.publicAddress != null) {
                await tasksServices.fetchTasksCustomer(tasksServices.publicAddress!);
              }
            } else if (widget.pageName == 'performer') {
              if (tasksServices.publicAddress != null) {
                await tasksServices.fetchTasksPerformer(tasksServices.publicAddress!);
              }
            } else if (widget.pageName == 'tasks') {
              if (tasksServices.publicAddress != null) {
                await tasksServices.refreshTasksForAccount(tasksServices.publicAddress!);
              }
            }
            _hitBump();
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
                  } else if (objList.length >= 3) {
                    shimmeredTasks = emptyClasses.tasksForShimmer.values.toList();
                  }
                  // print(controller.isDragging);
                  return Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: offsetToArmed * controller.value,
                        child: SizedBox(
                          child: RiveAnimation.asset(
                            'assets/rive_animations/paw.riv',
                            fit: BoxFit.fitHeight,
                            stateMachines: const ['State Machine 1'],
                            // controllers: [_controller],
                            onInit: _onRiveInit,
                          ),
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
