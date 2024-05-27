import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../../../blockchain/classes.dart';
import '../services/statistics_service.dart';

// model - service:
// get -> read
// set -> write
// on -> init
// ... -> check (logic with bool return(not bool stored data))

class PartialSwipeAnimation {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  PartialSwipeAnimation(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Animation<Offset> get animation => _animation;

  void handleDragUpdate(double delta, double maxWidth) {
    _controller.value -= (-delta) / maxWidth;
    _controller.value = _controller.value.clamp(-1.0, 1.0);

  }

  void handleDragEnd() {
    if (_controller.value >= 0.5) {
      _controller.animateTo(1.0);
    } else {
      _controller.animateTo(0.0);
    }
  }


  void dispose() {
    _controller.dispose();
  }
}


class StatisticsModelState {
  List<TokenItem> tags = [];
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  double valueOnWallet = 0.0; // for value_input max

  StatisticsModelState({
    required this.tags,
    required this.initialEmptyBalance,
    required this.valueOnWallet,
  });
}

class StatisticsModel extends ChangeNotifier {
  final _statisticsService = StatisticsService();
  late PartialSwipeAnimation _animation;

  StatisticsModel(TickerProvider vsync) {
    _animation = PartialSwipeAnimation(vsync);
  }

  Animation<Offset> get animation => _animation.animation;

  void handleDragUpdate(DragUpdateDetails details, RenderBox renderBox) {
    double delta = details.primaryDelta ?? 0;
    // print(renderBox.constraints.maxWidth);
    _animation.handleDragUpdate(delta, renderBox.constraints.maxWidth);
    notifyListeners();
  }

  void handleDragEnd() {
    _animation.handleDragEnd();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}
