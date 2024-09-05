import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../../domain/use_cases/login_user.dart';
import '../../domain/use_cases/get_user_data.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final LoginUser loginUser;
  final GetUserData getUserData;
  // TextEditingController for managing the text input for email and password
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable for managing password visibility
  var isPasswordVisible = false.obs;

  AuthController({
    required this.loginUser,
    required this.getUserData,
  });

  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var errorMessage = ''.obs;
  var user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    checkUserData();
  }

  Future<void> checkUserData() async {
    if (user.value != null) {
      final result = await getUserData.execute(user.value!.employeeID);

      result.fold(
        (failure) {
          // Handle the failure, for example, show an error message
          if (kDebugMode) {
            print('Error fetching user data: ${failure.message}');
          }
          isAuthenticated.value = false;
        },
        (fetchedUser) {
          // If fetchedUser is null, the user.value should be set to null
          user.value = fetchedUser;
          isAuthenticated.value = true;
          Get.offNamed('/home');
        },
      );
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;

    final result = await loginUser.execute(email, password);

    result.fold(
      (failure) {
        errorMessage.value =
            failure.message; // Assuming Failure has a message field
        isAuthenticated.value = false;
      },
      (empId) async {
        final userDataReq = await getUserData.execute(empId);

        userDataReq.fold(
            (failure) => Failure(
                'Failed to retrieve user data'), // Handle the Failure case
            (usr) {
                    user.value = usr;
                    isAuthenticated.value = true;
                    Get.offNamed('/home');
                  } // Handle the UserModel case
            );
      },
    );
    isLoading.value = false;
  }

  void logout() {
    user.value = null;
    isAuthenticated.value = false;
    Get.offNamed('/login');
  }
}
