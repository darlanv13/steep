import 'package:flutter/foundation.dart';
import 'auth_provider.dart';

class MockAuthProvider extends AuthProvider {
  bool _isAuthenticated = true;
  String _role = 'admin';

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String get userRole => _role;

  @override
  bool get isLoading => false;

  @override
  Future<void> login(String email, String password) async {
    _isAuthenticated = true;
    _role = email == 'admin@vale.com' ? 'admin' : 'operador';
    notifyListeners();
  }

  @override
  Future<void> logout() async {
    _isAuthenticated = false;
    _role = 'operador';
    notifyListeners();
  }

  void setAuthState(bool loggedIn, String role) {
    _isAuthenticated = loggedIn;
    _role = role;
    notifyListeners();
  }
}
