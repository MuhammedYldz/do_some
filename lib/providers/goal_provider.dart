import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  Future<void> fetchGoals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('goals')
        .where('userId', isEqualTo: user.uid)
        .get();

    _goals = snapshot.docs
        .map((doc) => Goal.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('goals').add({
      ...goal.toJson(),
      'userId': user.uid,
    });
    _goals.add(goal);
    notifyListeners();
  }

  Future<void> updateGoal(Goal goal) async {
    await FirebaseFirestore.instance
        .collection('goals')
        .doc(goal.id)
        .update(goal.toJson());
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    await FirebaseFirestore.instance.collection('goals').doc(id).delete();
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
  }
}
