import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TokenManager.dart';

class CreateUserService {
  static const String baseUrl = 'https://st-backend-si3x.onrender.com';

  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      // إذا كانت العملية ناجحة، نقوم بتخزين التوكينز
      Map<String, dynamic> responseData = jsonDecode(response.body);
      
      String accessToken = responseData['accessToken'];
      String refreshToken = responseData['refreshToken'];

      // تخزين التوكينز باستخدام TokenManager
      await TokenManager.saveTokens(accessToken, refreshToken);

      // طباعة التوكينز في الترمنال بعد نجاح العملية
      print('تم تسجيل المستخدم بنجاح');
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');

      return responseData;
    } else {
      throw Exception('فشل في تسجيل المستخدم: ${response.body}');
    }
  }
}
