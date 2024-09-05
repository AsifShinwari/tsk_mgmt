import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_mgmnt_system/data/models/notification_model.dart';
import '../../data/models/task.dart';
import '../../data/services/task_service.dart';

class TaskController extends GetxController {
  final Box<Task> taskBox;
  final TaskService taskApiProvider = Get.find<TaskService>();
  var tasks = <Task>[].obs;
  var isLoading = false.obs;
  Connectivity connectivity = Connectivity();

  TaskController(this.taskBox);

  @override
  void onInit() {
    super.onInit();
    _loadTasksFromLocal();
    syncTasks(null, null);
  }

  void _loadTasksFromLocal() {
    tasks.assignAll(taskBox.values.toList());
  }

  Future<void> syncTasks(DateTime? startDate, DateTime? endDate) async {
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      try {
        isLoading(true);
        List<Task> fetchedTasks =
            await taskApiProvider.fetchTasks(startDate, endDate);
        await taskBox.clear();
        for (var task in fetchedTasks) {
          await taskBox.put(task.clientSchedulDetialID, task);
        }
        tasks.assignAll(taskBox.values.toList());
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> addTask(Task task) async {
    await taskBox.put(task.clientSchedulDetialID, task);
    tasks.assignAll(taskBox.values.toList());
  }

  Future<void> updateTask(
      String clientSchedulDetialID, Task updatedTask) async {
    if (taskBox.containsKey(clientSchedulDetialID)) {
      await taskBox.put(clientSchedulDetialID, updatedTask);
      tasks.assignAll(taskBox.values.toList());
    } else {
      if (kDebugMode) {
        print(
            'Task with clientSchedulDetialID $clientSchedulDetialID does not exist');
      }
    }
  }

  Task? getTaskById(int clientSchedulDetialID) {
    return taskBox.get(clientSchedulDetialID);
  }

  Future<void> deleteTask(String clientSchedulDetialID) async {
    await taskBox.delete(clientSchedulDetialID);
    tasks.assignAll(taskBox.values.toList());
  }

  Future<void> filterTasks(DateTime fromDate, DateTime toDate) async {
    var filteredTasks = taskBox.values.where((task) {
      DateTime startDate = DateTime.parse(task.schedualStartDate);
      return startDate.isAfter(fromDate) && startDate.isBefore(toDate);
    }).toList();
    tasks.assignAll(filteredTasks);
  }

  int getCountOfTodaysTasks(DateTime fromDate, DateTime toDate) {
    return taskBox.values
        .where((task) {
          DateTime startDate = DateTime.parse(task.schedualStartDate);
          return (startDate.isAfter(fromDate) &&
              startDate.isBefore(toDate) &&
              task.schedulStatus == 1);
        })
        .toList()
        .length;
  }

  Future<List<NotificationModel>> getCountOfTodaysTasksOnline(
      DateTime fromDate, DateTime toDate) {
      return taskApiProvider.fetchTasksCount();
  }

  void refreshTasks() {
    tasks.assignAll(tasks.toList());
  }
}
