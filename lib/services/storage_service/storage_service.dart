import 'package:shared_preferences/shared_preferences.dart';

class StorageServiceException implements Exception {
  String message;
  Exception error;
  StorageServiceException({this.message, this.error});
}

class StorageService {
  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    SharedPreferences instance =
        await SharedPreferences.getInstance().catchError(
      (e) {
        throw StorageServiceException(
          message: 'can\'t get SharedPreferences instance',
          error: e,
        );
      },
    );
    return instance;
  }

  Future<dynamic> read(String key) async {
    SharedPreferences prefs = await _getSharedPreferencesInstance();
    try {
      dynamic value = prefs.get(key);
      return value;
    } catch (e) {
      throw StorageServiceException(error: e, message: 'not able to read');
    }
  }

  Future<bool> write(String key, dynamic value) async {
    SharedPreferences prefs = await _getSharedPreferencesInstance();
    try {
      switch (value.runtimeType) {
        case double:
          return prefs.setDouble(key, value);
          break;
        case int:
          return prefs.setInt(key, value);
          break;
        case bool:
          return prefs.setBool(key, value);
          break;
        case String:
          return prefs.setString(key, value);
          break;
        default:
          throw StorageServiceException(
            message: 'the value type can\'t be stored',
          );
      }
    } catch (e) {
      if (e is StorageServiceException) {
        rethrow;
      }
      throw StorageServiceException(message: 'unable to write', error: e);
    }
  }

  Future<bool> remove(String key) async {
    SharedPreferences prefs = await _getSharedPreferencesInstance();
    try {
      if (prefs.containsKey(key)) {
        return prefs.remove(key);
      }
      return false;
    } catch (e) {
      throw StorageServiceException(message: 'unable to remove', error: e);
    }
  }

  Future<void> clear() async {
    SharedPreferences prefs = await _getSharedPreferencesInstance();
    try {
      await prefs.clear();
    } catch (e) {
      throw StorageServiceException(message: 'unable to clear', error: e);
    }
  }
}
