import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _shift = 'Manhã';
  String _fleet = 'Caminhões';
  String _period = 'Hoje';

  String get shift => _shift;
  String get fleet => _fleet;
  String get period => _period;

  void setShift(String value) {
    if (_shift != value) {
      _shift = value;
      notifyListeners();
    }
  }

  void setFleet(String value) {
    if (_fleet != value) {
      _fleet = value;
      notifyListeners();
    }
  }

  void setPeriod(String value) {
    if (_period != value) {
      _period = value;
      notifyListeners();
    }
  }
}
