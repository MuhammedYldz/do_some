import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; // Burada takma ad kullanıyoruz
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> setUser(User user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      _user = User(
        id: currentUser.uid,
        name: userDoc['name'],
        email: userDoc['email'],
        password: '', // Parolayı saklamayın
      );
      notifyListeners();
    }
  }
}
