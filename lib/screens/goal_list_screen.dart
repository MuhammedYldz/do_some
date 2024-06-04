import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/goal_provider.dart';
import '../models/goals.dart';
import '../screens/goal_detail_screen.dart';
import '../screens/add_goal_screen.dart';

class GoalListScreen extends StatelessWidget {
  final String goalType;

  GoalListScreen(this.goalType);

  @override
  Widget build(BuildContext context) {
    final goalProvider = Provider.of<GoalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('$goalType Goals'),
      ),
      body: FutureBuilder(
        future: goalProvider.fetchGoals(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Consumer<GoalProvider>(
            builder: (ctx, goalProvider, _) {
              final goals = goalProvider.goals.where((goal) => goal.type == goalType).toList();
              return ListView.builder(
                itemCount: goals.length,
                itemBuilder: (ctx, index) {
                  final goal = goals[index];
                  return ListTile(
                    title: Text(goal.title),
                    subtitle: Text(goal.description),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GoalDetailScreen(goal.id),
                      ));
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "addGoalListButton"+context.toString(),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddGoalScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
