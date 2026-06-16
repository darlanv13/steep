import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _shift = 'Manhã';
  String _fleet = 'Caminhões';
  String _period = 'Hoje';
  bool _isLoading = false;

  String get shift => _shift;
  String get fleet => _fleet;
  String get period => _period;
  bool get isLoading => _isLoading;

  Future<void> _simulateLoading() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    _isLoading = false;
    notifyListeners();
  }

  void setShift(String value) {
    if (_shift != value) {
      _shift = value;
      _simulateLoading();
    }
  }

  void setFleet(String value) {
    if (_fleet != value) {
      _fleet = value;
      _simulateLoading();
    }
  }

  void setPeriod(String value) {
    if (_period != value) {
      _period = value;
      _simulateLoading();
    }
  }
}
