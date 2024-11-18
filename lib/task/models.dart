class Tasks {
  final String id;
  final String task;
  final String date;
  final String time;
  final String menuId;
  final bool isFinished;
  final bool isExpired;

  Tasks({
    required this.id,
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,
    this.isFinished = false,
    this.isExpired = false,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['_id'],
      task: json['task'],
      date: json['date'],
      time: json['time'],
      menuId: json['menuId'],
      isFinished: json['isFinished'] ?? false,
      isExpired: json['isExpired']??false,
    );
  }

  Tasks copyWith({
    String? id,
    String? task,
    String? date,
    String? time,
    String? menuId,
    bool? isFinished,
    bool? isExpired
  }) {
    return Tasks(
      id: id ?? this.id,
      task: task ?? this.task,
      date: date ?? this.date,
      time: time ?? this.time,
      menuId: menuId ?? this.menuId,
      isFinished: isFinished ?? this.isFinished,
      isExpired: isExpired??this.isExpired
    );
  }
}
