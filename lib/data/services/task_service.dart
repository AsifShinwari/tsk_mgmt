import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_mgmnt_system/data/models/notification_model.dart';
import '../models/task.dart';
import '../models/user_model.dart';

class TaskService {
  final Box<UserModel> _userBox;

  TaskService(this._userBox);

  final Dio _dio = Dio();

  Future<List<Task>> fetchTasks(startDate, endDate) async {
    if (startDate == null) {
      //set default dates range
      startDate = DateTime.now().subtract(const Duration(days: 1));
      endDate = DateTime.now().add(const Duration(days: 1));
    }

    int empId = 0;
    final userDt = getUserData();
    if (userDt != null) {
      empId = getUserData()!.employeeID;
    }

    String formattedStartDate =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
    String formattedEndDate =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";

    final response = await _dio.get(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/fnGetaUserSchedules',
        queryParameters: {
          'dateFrom': formattedStartDate,
          'dateTo': formattedEndDate,
          'empId': empId,
        });
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<List<NotificationModel>> fetchTasksCount() async {
    int empId = 0;
    final userDt = getUserData();
    if (userDt != null) {
      empId = getUserData()!.employeeID;
    }

    final response = await _dio.get(
        'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/getScheduleNotification',
        queryParameters: {
          'emplyId': empId,
        });

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data
          .map((json) =>
              NotificationModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load notification tasks');
    }
  }

  UserModel? getUserData() {
    return _userBox.get('user');
  }
}
