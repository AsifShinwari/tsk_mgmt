import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRemoteDataProvider {
  final http.Client client;

  AuthRemoteDataProvider(this.client);

  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('https://myabilities.lightway-soft.com/api/WebServicesForMobileApp'),
      body: {'usrName': email, 'passwrd': password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
