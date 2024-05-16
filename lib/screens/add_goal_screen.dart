import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/goals.dart';
import '../providers/goal_provider.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  GoalType _type = GoalType.short;
  DateTime _completionDate = DateTime.now().add(Duration(days: 7));
  String _period = 'daily';

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<GoalProvider>(context, listen: false).addGoal(
        Goal(
          name: _name,
          type: _type,
          completionDate: _completionDate,
          period: _period,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Goal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Goal Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              DropdownButtonFormField<GoalType>(
                value: _type,
                decoration: InputDecoration(labelText: 'Goal Type'),
                items: [
                  DropdownMenuItem(
                    child: Text('Short Term'),
                    value: GoalType.short,
                  ),
                  DropdownMenuItem(
                    child: Text('Medium Term'),
                    value: GoalType.medium,
                  ),
                  DropdownMenuItem(
                    child: Text('Long Term'),
                    value: GoalType.long,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                onSaved: (value) {
                  _type = value!;
                },
              ),
              
              TextFormField(
                decoration: InputDecoration(labelText: 'Completion Date'),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _completionDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _completionDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                  text: _completionDate.toLocal().toString().split(' ')[0],
                ),
              ),
              DropdownButtonFormField<String>(
                value: _period,
                decoration: InputDecoration(labelText: 'Period'),
                items: [
                  DropdownMenuItem(
                    child: Text('Daily'),
                    value: 'daily',
                  ),
                  DropdownMenuItem(
                    child: Text('Weekly'),
                    value: 'weekly',
                  ),
                  DropdownMenuItem(
                    child: Text('Monthly'),
                    value: 'monthly',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _period = value!;
                  });
                },
                onSaved: (value) {
                  _period = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Add Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
