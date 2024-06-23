import 'package:collection/collection.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_infinite_pagination/easy_infinite_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../blockchain/classes.dart';
import '../blockchain/empty_classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';
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
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // _fetchData();
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

  List<Task> _newList = [];
  int _controlListNumber = 0;
  List<Task> _filterResults = [];

  bool _hasReachedMax = false;
  bool _isLoading = false;
  int _currentIndex = 0;
  final int batchSize = 20;

  void _fetchData() async {
    if (_isLoading) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
    });
    await Future.delayed(const Duration(milliseconds: 600));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final emptyClasses = EmptyClasses();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);
    late double offsetToArmed = 200;

    final tasksServices = context.watch<TasksServices>();
    _filterResults = tasksServices.filterResults.values.toList();

    Function deepEq = const DeepCollectionEquality().equals;

    if (_newList.isEmpty || _filterResults.isNotEmpty && !deepEq(_filterResults, _newList) || _controlListNumber != _filterResults.length) {
      _newList.clear();
      _currentIndex = 0;
      _hasReachedMax = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    }

    _controlListNumber = _filterResults.length;

    if (!_hasReachedMax && _currentIndex < _filterResults.length) {
      final end = (_currentIndex + batchSize < _filterResults.length) ? _currentIndex + batchSize : _filterResults.length;
      _newList.addAll(_filterResults.sublist(_currentIndex, end));
      _currentIndex = end;
      if (_currentIndex >= _filterResults.length) {
        _hasReachedMax = true;
      }
    }

    // print('_filterResults: ${_filterResults.length}');
    // print('_newList: ${_newList.length}');
    // print('_currentIndex: ${_currentIndex}');
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
            } else if (widget.pageName == 'auditor') {
              if (listenWalletAddress != null) {
                await tasksServices.fetchTasksByState('audit');
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
                  if (_filterResults.length <= 1) {
                    shimmeredTasks = [emptyClasses.tasksForShimmer.values.toList().first];
                  } else if (_filterResults.length == 2) {
                    shimmeredTasks = [emptyClasses.tasksForShimmer.values.toList().first, emptyClasses.tasksForShimmer.values.toList().last];
                  } else if (_filterResults.length >= 3) {
                    shimmeredTasks = emptyClasses.tasksForShimmer.values.toList();
                  }
                  // else if (_filterResults.length == 4) {
                  //   shimmeredTasks = [
                  //     emptyClasses.tasksForShimmer.values.toList().first,
                  //     emptyClasses.tasksForShimmer.values.toList().last,
                  //     emptyClasses.tasksForShimmer.values.toList()[1],
                  //     emptyClasses.tasksForShimmer.values.toList().last
                  //   ];
                  // } else if (_filterResults.length >= 5) {
                  //   shimmeredTasks = [
                  //     emptyClasses.tasksForShimmer.values.toList().first,
                  //     emptyClasses.tasksForShimmer.values.toList()[1],
                  //     emptyClasses.tasksForShimmer.values.toList()[2],
                  //     emptyClasses.tasksForShimmer.values.toList().last,
                  //     emptyClasses.tasksForShimmer.values.toList()[1],
                  //   ];
                  // }
                  // print(controller.isDragging);
                  return Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: offsetToArmed * controller.value,
                        child: SizedBox(
                          child: (widget.paw == null)
                              ? const SizedBox.shrink()
                              : RiveAnimation.direct(
                                  widget.paw!,
                                  fit: BoxFit.fitHeight,
                                  // stateMachines: const ['State Machine 1'],
                                  // controllers: [_controller],
                                  onInit: _onRiveInit,
                                ),

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
          child: InfiniteListView(
            controller: _scrollController,
            delegate: PaginationDelegate(
              itemCount: _newList.length,
              itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
                  child: TaskTransition(
                    fromPage: widget.pageName,
                    task: _newList[index],
                  )),
              firstPageLoadingBuilder: (_) => Container(
                  // child: Text('firstPageLoadingBuilder'),
                  ),
              firstPageNoItemsBuilder: (_) => Container(
                  // child: Text('firstPageNoItemsBuilder'),
                  ),
              loadMoreLoadingBuilder: (_) => Center(
                child: SizedBox(
                  height: 40,
                  child: LoadingAnimationWidget.prograssiveDots(
                    size: 25,
                    color: DodaoTheme.of(context).secondaryText,
                  ),
                ),
              ),
              // loadMoreNoMoreItemsBuilder: (_) => Center(
              //   child: Column(
              //     children: [
              //       Text('No more Items'),
              //       LoadingAnimationWidget.prograssiveDots(
              //         size: 25,
              //         color: DodaoTheme.of(context).secondaryText,
              //       ),
              //     ],
              //   ),
              // ),
              isLoading: _isLoading,
              onFetchData: _fetchData,
              hasReachedMax: _hasReachedMax,
            ),
          ),

          // child:  ListView.builder(
          //   padding: EdgeInsets.zero,
          //   scrollDirection: Axis.vertical,
          //   itemCount: _filterResults.length,
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
          //       child: TaskTransition(
          //         fromPage: widget.pageName,
          //         task: _filterResults[index],
          //       )
          //     );
          //   },
          // ),
        ));
  }
}
