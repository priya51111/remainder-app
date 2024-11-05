import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:get_storage/get_storage.dart';
import '../../login/repository/repository.dart'; // Import the UserRepository
import '../bloc/menu_state.dart';
import '../model.dart'; // Import Menus model

class MenuRepository {
  final String createMenuUrl =
      'https://app-project-9.onrender.com/api/menu/menu';
  final GetStorage box = GetStorage(); // Initialize GetStorage instance
  final UserRepository userRepository; // Add UserRepository as a dependency
  final Logger logger = Logger();
  final String fetchMenusUrl =
      'https://app-project-9.onrender.com/api/menu/getbyid';
  // Constructor with UserRepository as a parameter
  MenuRepository({required this.userRepository});

  // Method to create a menu
  Future<String> createMenu(String menuname, String date) async {
    // Fetch userId from UserRepository
    final userId = userRepository.getUserId();

    // Log the userId to check if it's being retrieved properly
    logger.i("UserId: $userId");

    // Handle the case where userId is missing
    if (userId == null) {
      throw Exception('User ID is missing');
    }

    // Fetch the token from UserRepository
    final token = await userRepository.getToken(); // Use the public method now
    if (token == null) {
      throw Exception('Token is missing');
    }

    try {
      // Make the API call to create a menu
      final response = await http.post(
        Uri.parse(createMenuUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'menuname': menuname,
          'userId': userId,
          'date': date,
        }),
      );

      // Log the API response for debugging
      logger.i("API Response: ${response.statusCode} - ${response.body}");

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final menuId = data['data']['menu']['_id'];
        final date = data['data']['menu']['date'];

        // Save the date in GetStorage
        box.write('date', date);
        logger.i('Date Saved: $date');

        // Save the menuId in local storage
        box.write('menuId', menuId);
        logger.i("Menu ID saved: $menuId");
        return menuId; // Return the menuId
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      logger.e("Error creating menu: $e");
      throw Exception('Failed to create menu');
    }
  }

  // Method to retrieve the saved menuId from GetStorage
  String getSavedMenuId() {
    return box.read('menuId') ?? ''; // Return empty string if null
  }

  // Method to retrieve the saved date from GetStorage
  String getdate() {
    return box.read('date') ?? ''; // Return empty string if null
  }
    final List<String> defaultMenus = ["Wishlist", "Shopping", "Default","Personal","Work"];
  // Method to fetch menus based on userId and date
  Future<List<Menus>> fetchMenus(
    {required String userId, required String providedDate}) async {
  try {
    // Retrieve the userId
    final userId = userRepository.getUserId();
    logger.i("UserId: $userId");

    if (userId == null) {
      throw Exception('User ID is missing');
    }

    // Prioritize the providedDate. Use the saved date only if providedDate is empty
    final date = providedDate.isNotEmpty ? providedDate : box.read('date');
    logger.i("Using Date: $date");

    if (date.isEmpty) {
      throw Exception('Date is missing');
    }

    // Fetch the token
    final token = await userRepository.getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

    // Make the GET request to fetch menus
    final response = await http.get(
      Uri.parse('$fetchMenusUrl/$userId/$date'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    logger.i("API Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success' && data['data']['menu'] != null) {
        List<Menus> menus = (data['data']['menu'] as List)
            .map((menu) => Menus.fromJson(menu))
            .toList();
        
        // Create default menus if needed
        await _createDefaultMenusIfNeeded(menus, userId, date);
        return menus;
      } else {
        throw Exception('Menu not found in response');
      }
    } else {
      throw Exception('Failed to fetch menus');
    }
  } catch (error) {
    logger.e("Error fetching menus: $error");
    throw Exception('Failed to fetch menus');
  }
}

   Future<void> _createDefaultMenusIfNeeded(List<Menus> existingMenus, String userId, String date) async {
    final existingMenuNames = existingMenus.map((menu) => menu.menuname).toList();
     logger.i('Existing menu names: $existingMenuNames');
    for (var defaultMenu in defaultMenus) {
      if (!existingMenuNames.contains(defaultMenu)) {
        // If the default menu is not present, create it
        await createMenu(defaultMenu, date);
        logger.i('Default menu "$defaultMenu" created');
      }
    }
  }
}
