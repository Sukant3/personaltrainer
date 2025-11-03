import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _userName;

  AuthViewModel() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (_user != null) {
        await _fetchUserName();
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null;
  User? get currentUser => _user;
  String get userName => _userName ?? 'User';

  // ✅ Register with Firestore user doc
  Future<void> register(String name, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
        _userName = name;
      }
    } catch (e) {
      throw Exception("Failed to register: $e");
    }
    notifyListeners();
  }

  // ✅ Login
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _fetchUserName();
    } catch (e) {
      throw Exception("Failed to sign in: $e");
    }
    notifyListeners();
  }

  // ✅ Fetch username from Firestore
  Future<void> _fetchUserName() async {
    if (_user == null) return;
    final doc = await _firestore.collection('users').doc(_user!.uid).get();
    _userName = doc.data()?['name'] ?? 'User';
  }

  // ✅ Logout
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _userName = null;
    notifyListeners();
  }
}
