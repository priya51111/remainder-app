import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing/loginpage.dart';
import 'package:testing/logout/bloc/Logout_bloc.dart';
import 'package:testing/logout/repository/Logout_repository.dart';
import 'package:testing/menu/bloc/menu_bloc.dart';
import 'package:testing/task/bloc/task_event.dart';
import 'package:testing/task/view/view.dart';
import 'login/bloc/login_bloc.dart';
import 'login/repository/repository.dart';
import 'menu/repo/menu_repository.dart';
import 'menu/view.dart';
import 'task/bloc/task_bloc.dart';
import 'task/repository/task_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');


  tz.initializeTimeZones();


  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    
  );
void _onNotificationAction(String? payload, BuildContext context) async {
  if (payload != null) {
    final Map<String, dynamic> data = jsonDecode(payload);
    final action = data['action'];
    final taskId = data['taskId'];

    if (action == 'finish') {
      if (taskId != null) {
        // Trigger the task completion API
        BlocProvider.of<TaskBloc>(context).add(MarkTaskAsCompleted(taskId: taskId));
      }
    } else if (action == 'edit') {
      // Navigate to the edit page with the task details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateTaskPage(
          
          isEditMode: true,
          ),
        ),
      );
    }
  }
}



void _initializeNotificationHandler(
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  BuildContext context,
) {
  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      _onNotificationAction(response.payload, context);
    },
  );
}




  runApp(MyApp(isUserLoggedIn: token != null));
}






class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  const MyApp({super.key, required this.isUserLoggedIn});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
    final LogoutRepository logoutRepository =
        LogoutRepository(userRepository: userRepository);
    final MenuRepository menuRepository =
        MenuRepository(userRepository: userRepository);
    final TaskRepository taskRepository = TaskRepository(
      userRepository: userRepository,
      menuRepository: menuRepository,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(
            taskRepository: taskRepository,
            localNotificationsPlugin: flutterLocalNotificationsPlugin,
            userRepository: userRepository,
            menuRepository: menuRepository,
          ),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) => MenuBloc(
            menuRepository: menuRepository,
            userRepository: userRepository,
          ),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(
            logoutRepository: logoutRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey, // Enable global navigation
        home: isUserLoggedIn ? SimplePage() : Loginpage(),
        routes: {
          '/login': (context) => Loginpage(),
        },
      ),
    );
  }
}

