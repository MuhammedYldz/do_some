import 'package:do_some/widget/goal_item.dart';
import 'package:flutter/material.dart';
import 'package:do_some/models/goals.dart';


class GoalListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy veriler
    final goals = [
      Goal(
        name: 'Learn Flutter',
        type: GoalType.long,
        completionDate: DateTime.now().add(Duration(days: 365)),
        period: 'daily',
      ),
      Goal(
        name: 'Read a book',
        type: GoalType.medium,
        completionDate: DateTime.now().add(Duration(days: 30)),
        period: 'weekly',
      ),
      Goal(
        name: 'Exercise',
        type: GoalType.short,
        completionDate: DateTime.now().add(Duration(days: 7)),
        period: 'daily',
      ),
    ];

    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (ctx, index) {
        final goal = goals[index];
        return GoalItem(goal);
      },
    );
  }
}
