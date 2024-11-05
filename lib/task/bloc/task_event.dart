import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskSubmitted extends TaskEvent {
  final String task;
  final String date;
  final String time;

  TaskSubmitted({required this.task, required this.date, required this.time});

  @override
  List<Object> get props => [task, date, time];
}

class FetchTaskEvent extends TaskEvent {
  final String userId;
  final String date;
  final String? menuId;
  FetchTaskEvent({required this.userId, required this.date,this.menuId});
  @override
  List<Object> get props => [userId, date];
}


class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
}
class UpdateTaskEvent extends TaskEvent{
   final String taskId;
  final String task;
  final String date;
  final String time;
  final String menuId;

   UpdateTaskEvent({
    required this.taskId,
    required this.task,
    required this.date,
    required this.time,
    required this.menuId,
  
  });
}
// Event to filter tasks by a specific menuId
class FilterTasksByMenuIdEvent extends TaskEvent {
  final String menuId;

  FilterTasksByMenuIdEvent( {required this.menuId});
}

class MarkTaskAsCompleted extends TaskEvent {
  final String taskId;

  MarkTaskAsCompleted(this.taskId);
}
class UpdateTaskStatusEvent extends TaskEvent {
  final String taskId;
  final bool finished;

  UpdateTaskStatusEvent({required this.taskId, required this.finished});
}
