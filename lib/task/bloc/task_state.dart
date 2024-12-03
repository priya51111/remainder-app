import 'package:equatable/equatable.dart';

import '../models.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}



class TaskLoading extends TaskState {}

class TaskCreated extends TaskState {
  final Tasks task;
  const TaskCreated({required this.task});
  @override
  List<Object> get props => [task];
}

class TaskSuccess extends TaskState {
  final List<Tasks> taskList;
  final Map<String, String> menuMap;
  TaskSuccess({required this.taskList, required this.menuMap});
}

class TaskFailure extends TaskState {
  final String message;
  const TaskFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class TaskUpdatedSuccess extends TaskState {
  final List<Tasks> sucess;
  const TaskUpdatedSuccess({required this.sucess});
}

class TaskEditLoading extends TaskState {}

class TaskDeleteSuccess extends TaskState {}

class TaskDeleteFailure extends TaskState {
  final String message;
  TaskDeleteFailure(this.message);
}

class TaskMarkedAsCompleted extends TaskState {
  final String message;

  const TaskMarkedAsCompleted({required this.message});

  @override
  List<Object> get props => [message];
}
