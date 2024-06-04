import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/goals.dart'; // Adjust the import based on your folder structure

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  List<Goal> _goals = [];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _fetchGoals();
  }

  Future<void> _fetchGoals() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('goals')
        .where('userId', isEqualTo: _user.uid)
        .get();
    final List<Goal> fetchedGoals = result.docs.map((doc) {
      return Goal.fromDocument(doc);
    }).toList();

    setState(() {
      _goals = fetchedGoals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Calendar'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: GoalDataSource(_goals),
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onTap: (CalendarTapDetails details) {
          if (details.appointments != null) {
            _showGoalsDialog(context, details.appointments as List<Goal>);
          }
        },
      ),
    );
  }

  void _showGoalsDialog(BuildContext context, List<Goal> goals) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Goals for ${DateFormat('yyyy-MM-dd').format(goals[0].date)}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: goals.map((goal) => Text(goal.title)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class GoalDataSource extends CalendarDataSource {
  GoalDataSource(List<Goal> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
