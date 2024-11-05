import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/models.dart';

class UserRepository {
  final String apiUrl = 'https://app-project-9.onrender.com';
  final box = GetStorage(); // Initialize GetStorage
  final Logger logger = Logger();

  /// Create a new user and store userId locally using GetStorage
 Future<User> createUser(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    throw Exception("Email and password are missing");
  }

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/api/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    // Log the response for debugging
    logger.i("API Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse the response body to create a User instance
      final responseBody = json.decode(response.body);
      final userMap = responseBody['data']['user']; // Ensure this is a map
      final user = User.fromJson(userMap); // Pass the entire map to fromJson

      // Store user ID in local storage using GetStorage
      box.write('userId', user.userId);
      logger.i("User ID saved: ${user.userId}");

      return user;
    } else if (response.statusCode == 409) {  // 409 Conflict for existing user
      throw Exception("User with this email already exists. Please sign in.");
    }else {
      throw Exception("Error: ${response.body}");
    }
  } catch (e) {
    logger.e("Error creating user: $e");
    throw Exception('Failed to create user');
  }
}


  /// Method to retrieve stored user ID from GetStorage
  String getUserId() {
    final userId = box.read('userId');
    logger.i("Retrieved User ID: $userId");
    return userId;
  }

  /// Sign in user and store token using SharedPreferences
  Future<AuthResponse> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and password cannot be empty");
    }

    final response = await http.post(
      Uri.parse('$apiUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    // Log the response for debugging
    logger.i("Response Status Code: ${response.statusCode}");
    logger.i("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];

      if (token.isEmpty) {
        throw Exception('Invalid credentials: token or userId is missing');
      }

      // Store the token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      logger.i("Token saved: $token");

      return AuthResponse(token: token);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  /// Retrieve stored token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Sign out and remove token from SharedPreferences
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('tokenExpiry');
  }

  // Storing and retrieving user data locally
  Future<void> saveUsersToLocal(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userList =
        users.map((user) => json.encode(user.toJson())).toList();
    await prefs.setStringList('users', userList);
  }

  Future<List<User>> getUsersFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? userList = prefs.getStringList('users');
    if (userList != null) {
      return userList
          .map((userStr) => User.fromJson(json.decode(userStr)))
          .toList();
    }
    return [];
  }

  /// Generate a unique userId based on the current timestamp
  String generateUserId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Check if the stored token has expired
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenExpiry = prefs.getString('tokenExpiry');
    if (tokenExpiry == null) return true;

    final expiryDate = DateTime.parse(tokenExpiry);
    return DateTime.now().isAfter(expiryDate);
  }
}
