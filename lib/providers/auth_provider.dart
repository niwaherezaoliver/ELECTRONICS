import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _loadUserData(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, String name, String phone) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Demo mode - bypass Firebase for testing
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        _user = AppUser(
          id: 'demo-user-id',
          email: email,
          name: name,
          phone: phone,
          addresses: [],
          createdAt: DateTime.now(),
          orderHistory: [],
        );
        notifyListeners();
        return true;
      }
      
      return false;
      
      // Original Firebase code (commented out for demo)
      /*
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = result.user;
      if (firebaseUser != null) {
        AppUser newUser = AppUser(
          id: firebaseUser.uid,
          email: email,
          name: name,
          phone: phone,
          addresses: [],
          createdAt: DateTime.now(),
          orderHistory: [],
        );

        await _firestore.collection('users').doc(firebaseUser.uid).set(newUser.toMap());
        _user = newUser;
        notifyListeners();
        return true;
      }
      return false;
      */
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      // Demo mode - bypass Firebase for testing
      if (email.isNotEmpty && password.isNotEmpty) {
        _user = AppUser(
          id: 'demo-user-id',
          email: email,
          name: email.split('@')[0],
          phone: '',
          addresses: [],
          createdAt: DateTime.now(),
          orderHistory: [],
        );
        notifyListeners();
        return true;
      }
      
      return false;
      
      // Original Firebase code (commented out for demo)
      /*
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await _loadUserData(result.user!.uid);
        return true;
      }
      return false;
      */
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(String name, String phone) async {
    if (_user == null) return false;

    try {
      AppUser updatedUser = _user!.copyWith(
        name: name,
        phone: phone,
      );

      await _firestore.collection('users').doc(_user!.id).update(updatedUser.toMap());
      _user = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addAddress(String address) async {
    if (_user == null) return false;

    try {
      List<String> updatedAddresses = [..._user!.addresses, address];
      AppUser updatedUser = _user!.copyWith(addresses: updatedAddresses);

      await _firestore.collection('users').doc(_user!.id).update(updatedUser.toMap());
      _user = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
