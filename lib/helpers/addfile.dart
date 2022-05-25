import 'package:flutter/material.dart';

class AddFileControllerErrorHandler extends ChangeNotifier {
  List<String> errors = [];

  void addError(err) {
    if (!errors.contains(err)) {
      errors.add(err);
    }
  }

  void removeError(err) {
    errors.remove(err);
  }

  void checkCondition() {
    // =>
    notifyListeners();
  }

  errorHandler({required bool condition, required String error}) {
    if (!condition) {
      addError(error);
    } else {
      removeError(error);
    }
  }

  //
  //
  bool isOneOf(value, items) {
    return (value != null && items.contains(value));
  }

  bool isGreaterThan(value, number) {
    return (value != null && value > number);
  }

  bool isRealString(value) {
    return (value != null && value.isNotEmpty);
  }
}
