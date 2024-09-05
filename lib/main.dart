import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_mgmnt_system/data/models/note.dart';
import 'package:task_mgmnt_system/data/models/notification_model.dart';
import 'package:task_mgmnt_system/data/services/notes_service.dart';
import 'package:task_mgmnt_system/presentation/controllers/task_controller.dart';
import 'app.dart';
import 'core/constants/app_colors.dart';
import 'data/models/task.dart';
import 'data/models/user_model.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/data_providers/auth_local_data_provider.dart';
import 'data/data_providers/auth_remote_data_provider.dart';
import 'data/services/task_service.dart';
import 'domain/use_cases/login_user.dart';
import 'domain/use_cases/get_user_data.dart';
import 'presentation/controllers/auth_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   // Set the status bar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primary, // Set the desired status bar color
    statusBarIconBrightness: Brightness.light, // For Android, controls the color of the status bar icons (light for white, dark for black)
    statusBarBrightness: Brightness.dark, // For iOS, controls the brightness of the status bar icons
  ));
  
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NotificationModelAdapter());

  final authBox = await Hive.openBox<UserModel>('user');
  final taskBox = await Hive.openBox<Task>('tasks');
   await Hive.openBox<Note>('notes');

  final isLoggedIn = (authBox.isNotEmpty) ? true : false;

  final authLocalDataProvider = AuthLocalDataProvider(authBox);
  final authRemoteDataProvider = AuthRemoteDataProvider(http.Client());
  final dio = Dio();
  final authRepository = AuthRepositoryImpl(
    dio,
    remoteDataProvider: authRemoteDataProvider,
    localDataProvider: authLocalDataProvider,
  );

  Get.put<AuthController>(
    AuthController(
      loginUser: LoginUser(authRepository),
      getUserData: GetUserData(authRepository),
    ),
  );

  Get.put(TaskService(authBox));
  Get.put(NotesService());
  Get.put(AuthLocalDataProvider(authBox));
  Get.put(TaskController(taskBox));
  runApp(MyApp(isLoggedIn: isLoggedIn));
}
