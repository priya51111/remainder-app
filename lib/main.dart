import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testing/loginpage.dart';
import 'package:testing/logout/bloc/Logout_bloc.dart';
import 'package:testing/logout/repository/Logout_repository.dart';
import 'package:testing/menu/bloc/menu_bloc.dart';
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
  await requestExactAlarmPermission();
  tz.initializeTimeZones();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification actions if needed
    },
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

  // Method to check if user is logged in by checking token in SharedPreferences
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Retrieve the token
    return token != null && token.isNotEmpty;
  }

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
          ),
        ),
        BlocProvider(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) => MenuBloc(
            menuRepository: MenuRepository(userRepository: UserRepository()),
          ),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(
            logoutRepository:
                LogoutRepository(userRepository: UserRepository()),
          ),
        ),
      ],
      child: FutureBuilder<bool>(
        future: isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while checking
          } else if (snapshot.hasData && snapshot.data == true) {
            return MaterialApp(
              title: 'Task Manager',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              navigatorKey: navigatorKey,
              home:  SimplePage(), // Replace with your home page
              routes: {
                '/home': (context) =>  SimplePage(),
              },
            );
          } else {
            return MaterialApp(
              title: 'Task Manager',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              navigatorKey: navigatorKey,
              home: const Loginpage(), // Show login page if not logged in
              routes: {
                '/login': (context) => const Loginpage(),
              },
            );
          }
        },
      ),
    );
  }
}
