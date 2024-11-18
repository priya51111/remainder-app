import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing/loginpage.dart';
import 'package:testing/logout/bloc/Logout_bloc.dart';
import 'package:testing/logout/repository/Logout_repository.dart';
import 'package:testing/menu/bloc/menu_bloc.dart';

import 'login/bloc/login_bloc.dart';
import 'login/repository/repository.dart';
import 'menu/repo/menu_repository.dart';
import 'menu/view.dart';
import 'task/bloc/task_bloc.dart';
import 'task/repository/task_repository.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await requestExactAlarmPermission();
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(const MyApp());
}

Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
    final FlutterLocalNotificationsPlugin localNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc(
            taskRepository: taskRepository,
            localNotificationsPlugin: localNotificationsPlugin,
            userRepository: userRepository,
            menuRepository: MenuRepository(userRepository: userRepository),
          ), // Initialize TaskBloc
        ),
        BlocProvider(
          create: (context) =>
              UserBloc(userRepository: userRepository), // Initialize LoginBloc
        ),
        BlocProvider(
          create: (context) => MenuBloc(
            menuRepository: MenuRepository(userRepository: UserRepository()),
          ), // Initialize MenuBloc
        ),
        BlocProvider(
          create: (context) => LogoutBloc(
            logoutRepository:
                LogoutRepository(userRepository: UserRepository()),
          ), // Initialize MenuBloc
        ),
      ],
      child: MaterialApp(
          title: 'Task Manager',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Loginpage(),
          routes: {
    '/login': (context) => Loginpage(),
    // other routes
  },),
    );
  }
}
