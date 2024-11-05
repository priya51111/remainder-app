class Tasks {
  final String id;
  final String task;
  final String date;
  final String time;
  final String menuId;
  final bool finished; // To store the array of menuId objects

  Tasks({
    required this.id,
    required this.task,
    required this.date,
    required this.time,
    required this.menuId, // Add this
    this.finished=false
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json['_id'],
      task: json['task'],
      date: json['date'],
      time: json['time'],
      menuId: json['menuId'],
      finished: json['finished']??false,
    );
  }
   Tasks copyWith({bool? finished}) {
    return Tasks(
      id: id,
      task: task,
      date: date,
      time: time,
      menuId: menuId,
      finished: finished ?? this.finished,
    );
  }
}
