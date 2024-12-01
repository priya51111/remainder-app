import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskSubmitted extends TaskEvent {
  final String task;
  final String date;
  final String time;
  

  TaskSubmitted(
      {required this.task,
      required this.date,
      required this.time,
    });

  @override
  List<Object> get props => [task, date, time];
}

class FetchTaskEvent extends TaskEvent {
  final String userId;
  final String date;

  final bool? finished;

  FetchTaskEvent({
    required this.userId,
    required this.date,
    this.finished,
  });

  @override
  List<Object> get props => [userId, date];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
}

class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  final String task;
  final String date;
  final String time;
  final String menuId;
  final bool isfinished;
  UpdateTaskEvent(
      {required this.taskId,
      required this.task,
      required this.date,
      required this.time,
      required this.menuId,
      required this.isfinished});
}

class MarkTaskAsCompleted extends TaskEvent {
  final String taskId;

  MarkTaskAsCompleted({required this.taskId});
}
