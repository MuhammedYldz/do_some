class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String type; // Kısa, Orta, Uzun vadeli
  final String periodType; // Günlük, Haftalık, Aylık
  final String periodUnit; // Kere, Saat
  final int periodValue; // Sayısal değer

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.periodType,
    required this.periodUnit,
    required this.periodValue,
  });

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
    );
  }
}
