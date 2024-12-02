
import 'dart:convert';
import 'package:http/http.dart' as http;
class MyDatabase{
Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse('https://yourapi.com/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Login Successful: ${response.body}');
        return true;
      } else {
        print('Login Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> registerUser(String name, String email, String phone, String password) async {
    final url = Uri.parse('https://yourapi.com/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('Registration Successful: ${response.body}');
        return true;
      } else {
        print('Registration Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

}