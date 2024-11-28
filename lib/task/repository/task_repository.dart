import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:testing/menu/repo/menu_repository.dart';
import '../../login/repository/repository.dart';
import '../models.dart';

class TaskRepository {
  final GetStorage box = GetStorage(); // Initialize GetStorage instance
  final UserRepository userRepository;
  final MenuRepository menuRepository;
  final Logger logger = Logger();

  TaskRepository({required this.userRepository, required this.menuRepository});

  final String deleteUrl =
      'https://app-project-9.onrender.com/api/task/delete/:id';
  final String apiUrl =
      'https://app-project-9.onrender.com/api/task/createtask';
  final String updateUrl =
      'https://app-project-9.onrender.com/api/task/updatetask/:id';

  Future<Tasks> createTask(String task, String date, String time) async {
    final userId = userRepository.getUserId();
    final menuId = menuRepository.getSavedMenuId();
    final token = await userRepository.getToken();

    logger.i('User ID: $userId, Menu ID: $menuId, Token: $token');

    // Log the values to ensure they're not null
    logger.i('Task: $task, Date: $date, Time: $time');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'task': task,
          'date': date,
          'time': time,
          'userId': userId,
          'menuId': menuId
        }),
      );

      logger.i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Check if data and task are present in the response
        if (responseData['data'] != null &&
            responseData['data']['task'] != null) {
          // Access the task data
          final taskData = responseData['data']['task'];
          final taskId = taskData['_id']; // Extract taskId from response

          // Save taskId and other information in GetStorage
          box.write('taskId', taskId);
          logger.i('Saved taskId: $taskId');
          box.write('date', date);
          logger.i('Saved: $date');

          // Create a Tasks object from the response data
          final createdTask = Tasks.fromJson(
              taskData); // Ensure you have a fromJson method in your Tasks model

          return createdTask; // Return the created task
        } else {
          throw Exception('Invalid API response: Task data is missing');
        }
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (error) {
      logger.e('Error creating task: $error');
      // Always throw an exception on error
      throw Exception('Error creating task: $error');
    }
  }

  String date() {
    return box.read('date') ?? ''; // Return empty string if null
  }

  Future<List<Tasks>> fetchTasks(
      {required String userId, required String date}) async {
    try {
    
      final userId = userRepository.getUserId();
      final dates = box.read('date') ?? ''; 

    
      logger.i('Fetched User ID: $userId, Fetched Date: $dates');

      if (userId == null || dates.isEmpty) {
        logger.e('User ID or Date is missing');
        throw Exception('User ID or Date is missing');
      }
      final date = dates.replaceAll('/', '-'); 

      final token = await userRepository.getToken();
      logger.i('User ID: $userId, Date: $dates, Token: $token');

      try {
        final response = await http.get(
          Uri.parse(
              'https://app-project-9.onrender.com/api/task/gettask/$userId/$date'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );


        logger.i('API Response Status Code: ${response.statusCode}');
        logger.i('API Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);

        
          if (jsonData['data'] != null && jsonData['data']['task'] != null) {
           
            final tasks = (jsonData['data']['task'] as List)
                .map((task) => Tasks.fromJson(task))
                .toList();
            logger.i('Parsed ${tasks.length} tasks from the response.');

            return tasks;
          } else {
            logger.e('Invalid response: Task data is missing.');
            throw Exception('Invalid response: Task data is missing');
          }
        } else {
          logger.e(
              'Failed to load tasks: ${response.statusCode} - ${response.body}');
          throw Exception('Failed to load tasks: ${response.statusCode}');
        }
      } catch (error) {
        logger.e('Error during API call: $error');
        throw Exception('Error during API call: $error');
      }
    } catch (error) {
      logger.e('Error fetching tasks: $error');
      throw Exception('Error fetching tasks: $error');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final token = await userRepository.getToken();

  
    logger.i('token:$token,');
    logger.i(
        'Attempting to delete task with ID: $taskId'); 
    final url =
        Uri.parse('https://app-project-9.onrender.com/api/task/delete/$taskId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    logger.i('API Response Status Code: ${response.statusCode}');
    logger.i('API Response Body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<bool> updateTask({
    required String taskId,
    required String task,
    required String date,
    required String time,
    required String menuId,
    required bool isFinished,
  }) async {
    final token = await userRepository.getToken();

    final taskId = box.read('taskId');
    logger.i('token:$token,taskId:$taskId');
    logger.i(
        'Attempting to updating  with ID: $taskId');
    final url = Uri.parse(
        'https://app-project-9.onrender.com/api/task/updatetask/$taskId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'task': task,
          'date': date,
          'time': time,
          'menuId': menuId,
          'finished':isFinished,
        }),
      );
     
      logger.i('API Response Status Code: ${response.statusCode}');
      logger.i('API Response Body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }
  Future<void> completedTask(String taskId)async{
    try{
    final token = await userRepository.getToken();

    final taskId = box.read('taskId');
    logger.i('token:$token,taskId:$taskId');
    logger.i(
        'Attempting to updating  with ID: $taskId'); 
         final urls = Uri.parse(
        'https://app-project-9.onrender.com/api/task/completeTask/$taskId');
         final response = await http.patch(
        urls,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
       
      ); logger.i('API Response Status Code: ${response.statusCode}');
      logger.i('API Response Body: ${response.body}');
      
    }catch  (e) {
      print('Error updating task: $e');
      
    }
  }
}
