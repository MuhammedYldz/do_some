import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'goal_detail_screen.dart';
import 'add_goal_screen.dart';

class GoalListScreen extends StatelessWidget {
  final String goalType;

  GoalListScreen(this.goalType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$goalType Goals'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('goals')
            .where('type', isEqualTo: goalType)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final goalDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: goalDocs.length,
            itemBuilder: (ctx, index) => ListTile(
              title: Text(goalDocs[index]['title']),
              subtitle: Text(goalDocs[index]['description']),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GoalDetailScreen(goalDocs[index].id),
                ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
