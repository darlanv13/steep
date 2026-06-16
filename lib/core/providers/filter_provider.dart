import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  String _shift = 'Manhã';
  String _fleet = 'Caminhões';
  String _period = 'Hoje';
  bool _isLoading = false;
  String? _errorMessage;

  String get shift => _shift;
  String get fleet => _fleet;
  String get period => _period;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _updateStateWithLoading(Function updateAction) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      updateAction();

      // Simulates fetching new data latency based on filter
      await Future.delayed(const Duration(milliseconds: 600));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setShift(String value) {
    if (_shift != value) {
      _updateStateWithLoading(() {
        _shift = value;
      });
    }
  }

  void setFleet(String value) {
    if (_fleet != value) {
      _updateStateWithLoading(() {
        _fleet = value;
      });
    }
  }

  void setPeriod(String value) {
    if (_period != value) {
      _updateStateWithLoading(() {
        _period = value;
      });
    }
  }
}
