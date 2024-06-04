import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/goals.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _periodValueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Kısa Vadeli';
  String _selectedPeriodType = 'Günlük';
  String _selectedPeriodUnit = 'Kere';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addGoal() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          int totalPeriods = Goal.calculateTotalPeriods(DateTime.now(), _selectedDate, _selectedPeriodType);

          Goal newGoal = Goal(
            
            id: '', // Firestore tarafından otomatik oluşturulacak
            title: _titleController.text,
            description: _descriptionController.text,
            date: _selectedDate,
            type: _selectedType,
            periodType: _selectedPeriodType,
            periodUnit: _selectedPeriodUnit,
            periodValue: int.parse(_periodValueController.text),
            totalPeriods: totalPeriods,
          );

          await FirebaseFirestore.instance.collection('goals').add(newGoal.toJson());

          Navigator.of(context).pop();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred while saving the goal: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Goal'),
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
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  hintText: 'Select Due Date',
                ),
                onTap: () => _selectDate(context),
                readOnly: true,
                controller: TextEditingController(text: _selectedDate.toLocal().toString().split(' ')[0]),
              ),
              ElevatedButton(
                
                onPressed: _addGoal,
                child: Text('Add Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
