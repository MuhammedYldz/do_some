import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // Kısa, Orta, Uzun vadeli
  final String periodType; // Günlük, Haftalık, Aylık
  final String periodUnit; // Kere, Saat
  final int periodValue; // Sayısal değer
  final int totalPeriods; // Toplam periyot sayısı
  final int completedPeriods; // Tamamlanan periyot sayısı
  final bool isCompleted; // Tamamlanma durumu

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.periodType,
    required this.periodUnit,
    required this.periodValue,
    required this.totalPeriods,
    this.completedPeriods = 0,
    this.isCompleted = false,
  });

  static int calculateTotalPeriods(DateTime startDate, DateTime endDate, String periodType) {
    Duration duration = endDate.difference(startDate);
    int totalPeriods;
    if (periodType == 'Günlük') {
      totalPeriods = duration.inDays;
    } else if (periodType == 'Haftalık') {
      totalPeriods = (duration.inDays / 7).ceil();
    } else if (periodType == 'Aylık') {
      totalPeriods = (duration.inDays / 30).ceil();
    } else {
      totalPeriods = 0;
    }
    return totalPeriods;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'type': type,
      'periodType': periodType,
      'periodUnit': periodUnit,
      'periodValue': periodValue,
      'totalPeriods': totalPeriods,
      'completedPeriods': completedPeriods,
      'isCompleted': isCompleted,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      periodType: json['periodType'],
      periodUnit: json['periodUnit'],
      periodValue: json['periodValue'],
      totalPeriods: json['totalPeriods'] ?? 0,
      completedPeriods: json['completedPeriods'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
  factory Goal.fromDocument(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Goal(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      date: (data['date'] as Timestamp).toDate(),
      type: data['type'],
      periodType: data['periodType'],
      periodUnit: data['periodUnit'],
      periodValue: data['periodValue'],
      totalPeriods: data['totalPeriods'],
    );
  }
}
