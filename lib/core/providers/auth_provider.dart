import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;

  User? _currentUser;
  String _userRole = 'operador'; // Default role
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  String get userRole => _userRole;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'steepdb');

      _auth.authStateChanges().listen((User? user) async {
        _currentUser = user;
        if (user != null) {
          await _fetchUserRole(user.uid);
        } else {
          _userRole = 'operador';
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      // If Firebase initialization failed, we fallback safely.
      _isLoading = false;
      debugPrint("Auth init error: $e");
    }
  }

  Future<void> _fetchUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _userRole = doc.data()?['role'] ?? 'operador';
      }
    } catch (e) {
      _userRole = 'operador'; // Fallback
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint("Login error fallback to mock: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Catch signout errors
    } finally {
      _currentUser = null;
      _userRole = 'operador';
      notifyListeners();
    }
  }
}
