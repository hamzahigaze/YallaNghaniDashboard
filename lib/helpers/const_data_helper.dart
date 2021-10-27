import '../providers/token.dart';

class ConstDataHelper {
  static const String baseUrl = 'https://yallanghani.ahmedarnaout.com';

  static const String tokenKey = 'yalla_nghani_token_key_dashboard';

  static Map<String, String> get apiCommonHeaders => {
        'Authorization': 'Bearer ${TokenProvider().getToken()}',
        // 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjYwOWMwZDRkOGI0ZWJhYWZkZDJmMDVjZiIsInJvbGUiOiJBZG1pbiIsIm5iZiI6MTYyMDg0MDI4MSwiZXhwIjoxNjM2NzM3ODgxLCJpYXQiOjE2MjA4NDAyODF9.wsbLoRrwpDcQDGWEq7uXbeuUcmz85EDl8mTRmbXuAd8',
        'Content-Type': 'application/json'
      };

  static const emptyFieldsError = 'الرجاء عدم ترك حقول فارغة';
}
