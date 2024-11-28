import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:get_storage/get_storage.dart';
import '../../login/repository/repository.dart';
import '../bloc/menu_state.dart';
import '../model.dart';

class MenuRepository {
  final String createMenuUrl =
      'https://app-project-9.onrender.com/api/menu/menu';
  final GetStorage box = GetStorage();
  final UserRepository userRepository;
  final Logger logger = Logger();
  final String fetchMenusUrl =
      'https://app-project-9.onrender.com/api/menu/getbyid';
  MenuRepository({required this.userRepository});

  Future<String> createMenu(String menuname, String date) async {
    final userId = userRepository.getUserId();

    logger.i("UserId: $userId");

    if (userId == null) {
      throw Exception('User ID is missing');
    }

    final token = await userRepository.getToken(); 
    if (token == null) {
      throw Exception('Token is missing');
    }

    try {
     
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

      logger.i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final menuId = data['data']['menu']['_id'];
        final date = data['data']['menu']['date'];

        box.write('date', date);
        logger.i('Date Saved: $date');

        box.write('menuId', menuId);
        logger.i("Menu ID saved: $menuId");
        return menuId;
      } else {
        throw Exception("Error: ${response.body}");
      }
    } catch (e) {
      logger.e("Error creating menu: $e");
      throw Exception('Failed to create menu');
    }
  }

  String getSavedMenuId() {
    return box.read('menuId') ?? ''; 
  }

  String getdate() {
    return box.read('date') ?? ''; 
  }
    final List<String> defaultMenus = ["Wishlist", "Shopping", "Default","Personal","Work"];
  Future<List<Menus>> fetchMenus(
    {required String userId, required String providedDate}) async {
  try {
    final userId = userRepository.getUserId();
    logger.i("UserId: $userId");

    if (userId == null) {
      throw Exception('User ID is missing');
    }

    final date = providedDate.isNotEmpty ? providedDate : box.read('date');
    logger.i("Using Date: $date");

    if (date.isEmpty) {
      throw Exception('Date is missing');
    }

    final token = await userRepository.getToken();
    if (token == null) {
      throw Exception('Token is missing');
    }

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
        await createMenu(defaultMenu, date);
        logger.i('Default menu "$defaultMenu" created');
      }
    }
  }
}
