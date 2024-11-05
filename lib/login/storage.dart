import 'package:get_storage/get_storage.dart';

class StorageUtil {
  final GetStorage _box = GetStorage();

  /// Store userId in local storage
  void storeUserId(String userId) {
    _box.write('userId', userId);
  }

  /// Retrieve userId from local storage
  String? getUserId() {
    return _box.read('userId');
  }

  /// Store date in local storage
  void storeDate(String date) {
    _box.write('date', date);
  }

  /// Retrieve date from local storage
  String? getDate() {
    return _box.read('date');
  }

  /// Clear stored userId and date
  void clearStorage() {
    _box.remove('userId');
    _box.remove('date');
  }
}
