import 'package:uuid/uuid.dart';

enum GoalType { long, medium, short }

class Goal {
  String id;
  String name;
  GoalType type;
  DateTime completionDate;
  String period;
  List<String>? periodDates;
  List<String>? periodReminders;
  String? connection;

  Goal({
    required this.name,
    required this.type,
    required this.completionDate,
    required this.period,
    this.periodDates,
    this.periodReminders,
    this.connection,
  }) : id = Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last, // Enum to string
      'completionDate': completionDate.toIso8601String(),
      'period': period,
      'periodDates': periodDates,
      'periodReminders': periodReminders,
      'connection': connection,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      name: json['name'],
      type: GoalType.values.firstWhere((e) => e.toString() == 'GoalType.${json['type']}'),
      completionDate: DateTime.parse(json['completionDate']),
      period: json['period'],
      periodDates: json['periodDates'] != null ? List<String>.from(json['periodDates']) : null,
      periodReminders: json['periodReminders'] != null ? List<String>.from(json['periodReminders']) : null,
      connection: json['connection'],
    );
  }
}
