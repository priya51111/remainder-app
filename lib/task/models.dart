class Tasks {
  final String taskId;
  final String task;
  final String date;
  final String time;
  final String menuId;
  final bool isFinished;
  final bool isExpired;
  final bool isNotified;

  Tasks({
    required this.taskId,
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,
    this.isFinished = false,
    this.isExpired = false,
    this.isNotified=false,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      taskId: json['_id'],
      task: json['task'],
      date: json['date'],
      time: json['time'],
      menuId: json['menuId'],
      isFinished: json['isFinished'] ?? false,
      isExpired: json['isExpired']??false,
      isNotified: json['isNotified']??false
    );
  }

  Tasks copyWith({
    String?   taskId,
    String? task,
    String? date,
    String? time,
    String? menuId,
    bool? isFinished,
    bool? isExpired,
    bool?isNotified,
  }) {
    return Tasks(
      taskId: taskId ?? this.taskId,
      task: task ?? this.task,
      date: date ?? this.date,
      time: time ?? this.time,
      menuId: menuId ?? this.menuId,
      isFinished: isFinished ?? this.isFinished,
      isExpired: isExpired??this.isExpired,
      isNotified: isNotified??this.isNotified
    );
  }
}
