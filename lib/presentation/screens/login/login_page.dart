import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();
  Connectivity connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 120), // Add some space at the top
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 80, // Set the desired width
              height: 60, // Set the desired height
            ),
            const SizedBox(height: 50),

            TextField(
              controller: authController.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),

            Obx(() {
              return TextField(
                controller: authController.passwordController,
                obscureText: !authController.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      authController.isPasswordVisible.toggle();
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            StreamBuilder(
              stream: connectivity.onConnectivityChanged,
              builder: (context, snapshot) {
                return Obx(() {
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.lock),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryContainer)),
                    onPressed: (authController.isLoading.value &&
                            snapshot.connectionState != ConnectionState.active)
                        ? null
                        : () {
                            authController.login(
                              authController.emailController.text,
                              authController.passwordController.text,
                            );
                          },
                    label: authController.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : (snapshot.connectionState == ConnectionState.active)
                            ? const Text('Login')
                            : const Icon(
                                Icons.wifi_off_sharp,
                                color: Colors.white,
                              ),
                  );
                });
              },
            ),

            Obx(() {
              return authController.errorMessage.isNotEmpty
                  ? Text(
                      authController.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                  : Container();
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
