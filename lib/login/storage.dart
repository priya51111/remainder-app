import 'package:get_storage/get_storage.dart';

class StorageUtil {
  final GetStorage _box = GetStorage();

  void storeUserId(String userId) {
    _box.write('userId', userId);
  }

  String? getUserId() {
    return _box.read('userId');
  }

  void storeDate(String date) {
    _box.write('date', date);
  }

  String? getDate() {
    return _box.read('date');
  }

  void clearStorage() {
    _box.remove('userId');
    _box.remove('date');
  }
}
