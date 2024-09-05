// ignore: depend_on_referenced_packages
import 'package:hive_flutter/adapters.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import '../models/user_model.dart';

class AuthLocalDataProvider {
  final Box<UserModel> userBox;

  AuthLocalDataProvider(this.userBox);

  Future<void> saveUser(UserModel userModel) async {
    await userBox.put('user', userModel);
  }

  Future<UserModel?> getUser() async {
    return userBox.get('user');
  }

  Future<void> deleteUser() async {
    await userBox.delete('user');
  }
}
