import 'package:flutter/material.dart';
import '../models/goals.dart';

class GoalDetailScreen extends StatelessWidget {
  final Goal goal;

  GoalDetailScreen(this.goal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goal.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${goal.type.toString().split('.').last}', style: TextStyle(fontSize: 18)),
            Text('Completion Date: ${goal.completionDate.toIso8601String()}', style: TextStyle(fontSize: 18)),
            Text('Period: ${goal.period}', style: TextStyle(fontSize: 18)),
            // Diğer goal detaylarını da burada gösterin
          ],
        ),
      ),
    );
  }
}
