import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/goals.dart';

class GoalProvider with ChangeNotifier {
  List<Goal> _goals = [];

  List<Goal> get goals => _goals;

  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
    _saveToPreferences();
  }

  void removeGoal(String id) {
    _goals.removeWhere((goal) => goal.id == id);
    notifyListeners();
    _saveToPreferences();
  }

  void _saveToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('goals', jsonEncode(_goals.map((goal) => goal.toJson()).toList()));
  }

  void loadFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? goalsString = prefs.getString('goals');
    if (goalsString != null) {
      _goals = (jsonDecode(goalsString) as List).map((item) => Goal.fromJson(item)).toList();
      notifyListeners();
    }
  }
}
