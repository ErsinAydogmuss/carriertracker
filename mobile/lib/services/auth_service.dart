import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import '../constants/constants.dart';
import '../utils/response_data.dart';

class AuthService {

  Future<ResponseData> login({
    required String email,
    required String password,
    required String role,
  }) async {
    return await http.post(Uri.parse(loginUrl), body: {
      'email': email,
      'password': password,
      'role': role,
    }).then((response) {
      if(response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(responseBody);

        GetStorage box = GetStorage();

        var user = Jwt.parseJwt(jsonResponse['result']['token']);
        box.write('user', user);
        box.write('token', jsonResponse['result']['token']);

        return ResponseData(
          success: true,
          data: user,
          message: 'Giriş başarılı.',
        );
      }else {
        var responseBody = utf8.decode(response.bodyBytes);
        var jsonResponse = jsonDecode(responseBody);

        return ResponseData(
          success: false,
          message: jsonResponse['message'],
        );
      }
    });
  }


  Future<ResponseData> register({
    required String email,
    required String phone,
    required String name,
    required String surname,
    required String password,
    required String birthday,
    required String username,
    required int universityId,
    required int departmentId,
  }) async {
    return await http.post(Uri.parse(registerUrl), body: {
      'name': name,
      'email': email,
      'password': password,
    }).then((response) {
      if(response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return ResponseData(
          success: true,
          message: 'Kayıt başarılı.',
          data: jsonData,
        );
      }else {
        var responseBody = utf8.decode(response.bodyBytes);
        return ResponseData(
          success: false,
          message: responseBody,
        );
      }
    });
  }
}