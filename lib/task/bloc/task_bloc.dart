import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing/main.dart';
import 'package:testing/menu/repo/menu_repository.dart';
import 'package:testing/task/models.dart';

import '../../login/repository/repository.dart';

import '../repository/task_repository.dart';

import 'task_event.dart';
import 'task_state.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  String channelId = 'task_reminders';
  String channelName = 'Task Reminders';
  String channelDescription = 'Notifications for upcoming tasks and reminders.';
  final GetStorage box = GetStorage();
  List<Tasks> allTasks = [];
  final TaskRepository taskRepository;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  final Logger logger = Logger();
  final UserRepository userRepository;
  final MenuRepository menuRepository;
  List<Tasks> finishedTasks = [];

  TaskBloc({
    required this.taskRepository,
    required this.localNotificationsPlugin,
    required this.userRepository,
    required this.menuRepository,
  }) : super(TaskInitial()) {
    on<TaskSubmitted>(_ontaskSubmitted);
    on<FetchTaskEvent>(_onFetchTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskEvent>(_onTaskUpdated);
    on<MarkTaskAsCompleted>(_onMarkTaskAsCompleted);
  }
  Future<void> _ontaskSubmitted(
      TaskSubmitted event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    try {
      final createdTask =
          await taskRepository.createTask(event.task, event.date, event.time);
      await _scheduleNotification(
        localNotificationsPlugin,
        createdTask.task,
        event.date,
        event.time,
      );
      emit(TaskCreated(task: createdTask));
      logger.i('Task created successfully and notification scheduled');
      final userId = box.read('userId');
      final date = box.read('date');

      if (userId == null || date == null) {
        emit(TaskFailure(message: 'User ID or date is missing'));
        return;
      }
      add(FetchTaskEvent(userId: userId, date: date));
    } catch (error) {
      logger.e('Error creating task: $error');
      emit(TaskFailure(message: error.toString()));
    }
  }

  Future<void> _onFetchTask(
      FetchTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    try {
      final List<Tasks> tasks = await taskRepository.fetchTasks(
          userId: event.userId, date: event.date);
      allTasks = tasks;
      emit(TaskSuccess(taskList: tasks, menuMap: {}));
    } catch (e) {
      logger.e("Error fetching tasks: $e");
      emit(TaskFailure(message: 'Failed to fetch tasks.'));
    }
  }

  Future<void> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> _scheduleNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String taskName,
    String date,
    String time,
  ) async {
    try {
      final DateTime scheduledDateTime =
          DateFormat('dd-MM-yyyy hh:mm a').parse('$date $time');
      final tz.TZDateTime scheduledTZDateTime =
          tz.TZDateTime.from(scheduledDateTime, tz.local);
      if (scheduledDateTime.isBefore(DateTime.now())) {
        logger.e('Cannot schedule notification in the past.');
        return;
      }

      logger.i('Scheduled date: ${scheduledDateTime.toIso8601String()}');

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('task_reminders', 'Task Reminders',
              channelDescription:
                  'Notifications for upcoming tasks and reminders.',
              importance: Importance.max,
              priority: Priority.high,
              actions: [
            AndroidNotificationAction(
              'finish_action',
              'Finish',
            ),
            AndroidNotificationAction(
              'edit_action',
              'Edit',
            ),
          ]);

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        ' $taskName',
        ' $time',
        scheduledTZDateTime,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: jsonEncode({
          'action': 'edit',
          'taskName': taskName,
          'date': date,
          "time": time,
        }),
      );

      logger.i(
          'Notification scheduled for task: $taskName at $scheduledDateTime');
    } catch (error) {
      logger.e('Error scheduling notification: $error');
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.taskId);
      emit(TaskDeleteSuccess());
      add(FetchTaskEvent(
        userId: taskRepository.userRepository.getUserId()!,
        date: taskRepository.date(),
      ));
    } catch (e) {
      emit(TaskDeleteFailure(e.toString()));
    }
  }

  Future<void> _onTaskUpdated(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskEditLoading());
    try {
      final isUpdated = await taskRepository.updateTask(
          taskId: event.taskId,
          task: event.task,
          date: event.date,
          time: event.time,
          menuId: event.menuId,
          isFinished: event.isfinished);
      print('Task update status: $isUpdated, isFinished: ${event.isfinished}');
      if (isUpdated) {
        final updatedTasks = await taskRepository.fetchTasks(
          userId: userRepository.getUserId()!,
          date: box.read('date') ?? '',
        );
        add(FetchTaskEvent(
          userId: taskRepository.userRepository.getUserId()!,
          date: taskRepository.date(),
        ));
        await _scheduleNotification(
          localNotificationsPlugin,
          event.task,
          event.date,
          event.time,
        );
        emit(TaskUpdatedSuccess(sucess: updatedTasks));
      } else {
        emit(TaskFailure(message: 'Failed to update the task'));
      }
    } catch (e) {
      emit(TaskFailure(message: e.toString()));
    }
  }

  Future<void> _onMarkTaskAsCompleted(
      MarkTaskAsCompleted event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      // Calling the taskRepository method to update the task's completion status
      final response = await taskRepository.completedTask(event.taskId);

      // Assuming the response is in JSON format, make sure it is parsed
      final Map<String, dynamic> responseMap = response as Map<String, dynamic>;

      // Check if the response contains the success message and emit accordingly
      if (responseMap['status'] == 'success') {
        // Emit the success state with the success message from the API response
        emit(TaskMarkedAsCompleted(message: responseMap['message']));
      } else {
        emit(TaskFailure(message: 'Failed to mark task as completed'));
      }

      // Optionally, refresh the task list after marking the task as completed
      add(FetchTaskEvent(
        userId: taskRepository.userRepository.getUserId()!,
        date: taskRepository.date(),
      ));
    } catch (error) {
      emit(TaskFailure(message: error.toString()));
    }
  }

  Future<void> onNotificationActionSelected(
      String action, String payload) async {
    final data = jsonDecode(payload);
    if (action == 'finish_action') {
      final taskId = data['taskId'];
      await taskRepository.completedTask(taskId);
      add(FetchTaskEvent(
        userId: taskRepository.userRepository.getUserId()!,
        date: taskRepository.date(),
      ));
    }
  }
}
