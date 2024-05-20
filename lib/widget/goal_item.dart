import 'package:flutter/material.dart';
import 'package:do_some/screens/goal_detail_screen.dart';
import '../models/goals.dart'; // Goal modelini ithal edin

class GoalItem extends StatelessWidget {
  final Goal goal;

  GoalItem(this.goal);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(goal.title),
      subtitle: Text(goal.description),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalDetailScreen(goal.id), // goal.id'yi geçiyoruz
          ),
        );
      },
    );
  }
}
