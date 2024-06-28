import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../blockchain/classes.dart';

enum TaskDialogScreenStatus {
  none
}

class TaskModelViewState {
  double rating;

  TaskModelViewState({
    required this.rating,
  });
}

class TaskModelView extends ChangeNotifier {

  /// State update:
  var _state = TaskModelViewState(
    rating: 0.0,
  );

  TaskModelViewState get state => _state;

  void _updateState() {
    final rating = _state.rating;

    _state = TaskModelViewState(
      rating: rating,
    );
    notifyListeners();
  }

  onShowRateStars(Task task) {
    bool result = false;

    if (task.tokenBalances.isEmpty) {
      result = true;
    } else {
      for (var tokenBalances in task.tokenBalances) {
        if (tokenBalances > 0) {
          result = true;
        }
      }
    }

    notifyListeners();
    return result;
  }

  Future onUpdateRatingValue(number) async {
    _state.rating = number;
    _updateState();
  }
}
