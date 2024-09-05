import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgmnt_system/core/constants/app_colors.dart';
import 'package:task_mgmnt_system/presentation/controllers/auth_controller.dart';
import 'package:task_mgmnt_system/presentation/screens/notes/notes_page.dart';
import 'package:task_mgmnt_system/presentation/screens/task/task_page.dart';
import 'presentation/screens/login/login_page.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  AuthController authController = Get.find<AuthController>();

  MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whiz Pro',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        hintColor: AppColors.accent,
        colorScheme: const ColorScheme(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
          primaryContainer: Colors.blue
          ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: (isLoggedIn) ? '/tasks' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => const TaskPage()),
        GetPage(name: '/tasks', page: () => const TaskPage()),
        GetPage(name: '/notes', page: () => const NotesPage()),
      ],
    );
  }
}
