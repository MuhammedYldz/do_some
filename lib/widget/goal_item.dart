import 'package:flutter/material.dart';
import '../models/goals.dart';
import '../screens/goal_detail_screen.dart';

class GoalItem extends StatelessWidget {
  final Goal goal;

  GoalItem(this.goal);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(goal.name),
      subtitle: Text('Due: ${goal.completionDate.toIso8601String().split('T')[0]}'),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => GoalDetailScreen(goal),
          ),
        );
      },
    );
  }
}
