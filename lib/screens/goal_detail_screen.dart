import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goals.dart';

class GoalDetailScreen extends StatefulWidget {
  final String goalId;

  GoalDetailScreen(this.goalId);

  @override
  _GoalDetailScreenState createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _periodValueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Kısa Vadeli';
  String _selectedPeriodType = 'Günlük';
  String _selectedPeriodUnit = 'Kere';
  bool _isCompleted = false;

  Future<void> _fetchGoal() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('goals').doc(widget.goalId).get();
    _titleController.text = doc['title'];
    _descriptionController.text = doc['description'];
    _selectedDate = (doc['date'] as Timestamp).toDate();
    _selectedType = doc['type'];
    _selectedPeriodType = doc['periodType'];
    _selectedPeriodUnit = doc['periodUnit'];
    _periodValueController.text = doc['periodValue'].toString();
    _isCompleted = doc['isCompleted'] ?? false;
  }

  Future<void> _updateGoal() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('goals').doc(widget.goalId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date': _selectedDate,
        'type': _selectedType,
        'periodType': _selectedPeriodType,
        'periodUnit': _selectedPeriodUnit,
        'periodValue': int.parse(_periodValueController.text),
        'isCompleted': _isCompleted,
      });

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: _selectedType,
                items: ['Kısa Vadeli', 'Orta Vadeli', 'Uzun Vadeli']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value as String;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
              DropdownButtonFormField(
                value: _selectedPeriodType,
                items: ['Günlük', 'Haftalık', 'Aylık']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriodType = value as String;
                  });
                },
                decoration: InputDecoration(labelText: 'Period Type'),
              ),
              DropdownButtonFormField(
                value: _selectedPeriodUnit,
                items: ['Kere', 'Saat']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriodUnit = value as String;
                  });
                },
                decoration: InputDecoration(labelText: 'Period Unit'),
              ),
              TextFormField(
                controller: _periodValueController,
                decoration: InputDecoration(labelText: 'Period Value'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a period value';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: Text('Completed'),
                value: _isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompleted = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateGoal,
                child: Text('Update Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
