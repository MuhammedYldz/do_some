import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goals.dart';
import 'goal_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Goal>> _events = {};
  List<Goal> _selectedGoals = [];
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('goals').get();
    Map<DateTime, List<Goal>> events = {};

    for (var doc in snapshot.docs) {
      Goal goal = Goal.fromJson(doc.data() as Map<String, dynamic>);
      DateTime date = DateTime(goal.date.year, goal.date.month, goal.date.day);
      DateTime endDate = DateTime(goal.date.year, goal.date.month, goal.date.day);

      // Periyotları belirleme
      if (goal.periodType == 'Günlük') {
        for (DateTime d = date; d.isBefore(endDate) || d.isAtSameMomentAs(endDate); d = d.add(Duration(days: 1))) {
          if (events[d] == null) {
            events[d] = [goal];
          } else {
            events[d]!.add(goal);
          }
        }
      } else if (goal.periodType == 'Haftalık') {
        for (DateTime d = date; d.isBefore(endDate) || d.isAtSameMomentAs(endDate); d = d.add(Duration(days: 7))) {
          if (events[d] == null) {
            events[d] = [goal];
          } else {
            events[d]!.add(goal);
          }
        }
      } else if (goal.periodType == 'Aylık') {
        for (DateTime d = date; d.isBefore(endDate) || d.isAtSameMomentAs(endDate); d = DateTime(d.year, d.month + 1, d.day)) {
          if (events[d] == null) {
            events[d] = [goal];
          } else {
            events[d]!.add(goal);
          }
        }
      }
    }

    setState(() {
      _events = events;
    });
  }

  List<Goal> _getGoalsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _showGoalsForDay(DateTime day) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Goals for ${day.toLocal()}'.split(' ')[0]),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedGoals.length,
              itemBuilder: (context, index) {
                final goal = _selectedGoals[index];
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
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            eventLoader: _getGoalsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _selectedGoals = _getGoalsForDay(selectedDay);
              });
              _showGoalsForDay(selectedDay);
            },
          ),
          ..._selectedGoals.map((goal) => ListTile(
                title: Text(goal.title),
                subtitle: Text(goal.description),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GoalDetailScreen(goal.id),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }
}
