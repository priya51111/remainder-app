import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:testing/login/repository/repository.dart';

class LogoutRepository {
  final String apiUrl = 'https://app-project-9.onrender.com';
  final UserRepository userRepository;
  final Logger logger = Logger();

  LogoutRepository({required this.userRepository});

  Future<void> deleteUser(String userId) async {
    userId = userRepository.getUserId();
    logger.i("UserId: $userId"); 
    final url = Uri.parse('$apiUrl/api/deleteUser/$userId');
    final token = await userRepository.getToken();

    if (token == null) {
      throw Exception('Token is missing');
    }

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
       'Content-Type':"application/json"
      },
    );

   
    logger.i('API Response Status Code: ${response.statusCode}');
    logger.i('API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      print('User deleted successfully');
    } else {
      throw Exception('Failed to delete user');
    }
  }
}
