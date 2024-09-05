import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_mgmnt_system/core/constants/app_colors.dart';
import 'package:task_mgmnt_system/presentation/controllers/task_controller.dart';
import 'package:get/get.dart';
import '../../../core/widgets/base_page.dart';
import '../../../data/models/notification_model.dart';
import '../notification/notification_page.dart';
import 'task_details_page.dart';

class TaskPage extends StatefulWidget {

  const TaskPage({super.key});

  
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskController taskController = Get.find<TaskController>();
    DateTime? fromDate = DateTime.now().subtract(const Duration(days: 1));
    DateTime? toDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    fromDate = DateTime.now().subtract(const Duration(days: 1));
    toDate = DateTime.now().add(const Duration(days: 1));

    // Sync tasks when the page first initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await taskController.syncTasks(fromDate, toDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(
        title: Image.asset('assets/images/logo2.png'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async => await taskController.syncTasks(fromDate,toDate)
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              // Show date picker for filtering tasks
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: fromDate != null
                    ? fromDate!.add(const Duration(days: 1))
                    : DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                fromDate = pickedDate.subtract(const Duration(days: 1));
                toDate = pickedDate.add(const Duration(days: 1));
                await taskController.syncTasks(fromDate, toDate);
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.calendar_month_outlined),
                FutureBuilder<List<NotificationModel>>(
                  future: taskController.getCountOfTodaysTasksOnline(
                      fromDate!, toDate!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      int taskCount = snapshot.data!.length;
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            maxWidth: 15,
                            maxHeight: 15,
                          ),
                          child: Center(
                            child: Text(
                              taskCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            maxWidth: 15,
                            maxHeight: 15,
                          ),
                          child: const Center(
                            child: Text(
                              '...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            onPressed: () async {
              Get.to(() => const NotificationsPage());
              // // Fetch the notifications and show them in a popup
              // List<NotificationModel>? notifications = await taskController
              //     .getCountOfTodaysTasksOnline(fromDate!, toDate!);

              // if (notifications.isNotEmpty) {
              //   // ignore: use_build_context_synchronously
              //   showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         title: const Text('Notifications'),
              //         content: SizedBox(
              //           width: double.maxFinite,
              //           child: ListView.builder(
              //             shrinkWrap: true,
              //             itemCount: notifications.length,
              //             itemBuilder: (context, index) {
              //               final notification = notifications[index];
              //               return ListTile(
              //                 title: Html(data: notification.dataMessage),
              //                 // subtitle: Text(notification.logDate),
              //               );
              //             },
              //           ),
              //         ),
              //         actions: [
              //           TextButton(
              //             onPressed: () {
              //               Navigator.of(context).pop();
              //             },
              //             child: const Text('Close'),
              //           ),
              //         ],
              //       );
              //     },
              //   );
              // } else {
              //   // Show a message if no notifications are available
              //   // ignore: use_build_context_synchronously
              //   showDialog(
              //     context: context,
              //     builder: (context) {
              //       return AlertDialog(
              //         title: const Text('No Notifications'),
              //         content:
              //             const Text('No Notifications.'),
              //         actions: [
              //           TextButton(
              //             onPressed: () {
              //               Navigator.of(context).pop();
              //             },
              //             child: const Text('Close'),
              //           ),
              //         ],
              //       );
              //     },
              //   );
              // }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (taskController.tasks.isEmpty) {
          return Center(
            child: TextButton(
              onPressed: () {
                taskController.syncTasks(fromDate, toDate);
              },
              child: const Text('Empty! Click to Refresh'),
            ),
          );
        }
        return ListView.builder(
          itemCount: taskController.tasks.length,
          itemBuilder: (context, index) {
            final task = taskController.tasks[index];
            return Card(
              color: _getStatusIndicator(task.schedulStatus)["statusColor"],
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () async {
                    Get.to(() => TaskDetailsPage(
                          task: task,
                          tasksBox: taskController.taskBox,
                        ));
                  },
                  title: Text(
                    task.schedualTitle,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 5),
                          Text(
                            "Start: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(task.schedualStartDate))} ${task.schedualStarttime}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.calendar_month_outlined,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 5),
                          Text(
                            "End: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(task.schedualEndDate))} ${task.scheualEndTime}",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.person,
                              size: 16,
                              color: Theme.of(context).colorScheme.secondary),
                          const SizedBox(width: 5),
                          Text(
                            'Assigned by: ${task.assignedByEmployeeName}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      _buildStatusIndicator(task.schedulStatus),
                    ],
                  ),
                  trailing: IconButton(
                    padding: const EdgeInsets.only(top: 30),
                    icon: Icon(
                        _getStatusIndicator(task.schedulStatus)["statusIcon"],
                        color: AppColors.secondary),
                    onPressed: () async {
                      // Navigate to Task Details Page
                      Get.to(() => TaskDetailsPage(
                            task: task,
                            tasksBox: taskController.taskBox,
                          ));
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Map<String, dynamic> _getStatusIndicator(int status) {
    String statusText;
    Color statusColor;
    Color statusIconColor;
    IconData statusIcon;

    switch (status) {
      case 1:
        statusText = 'Pending';
        statusColor = const Color.fromRGBO(230, 229, 229, 1.000);
        statusIconColor = const Color.fromARGB(255, 230, 232, 149);
        statusIcon = Icons.not_started_outlined;
        break;
      case 2:
        statusText = 'Started';
        statusColor = const Color.fromRGBO(217, 236, 223, 1.0);
        statusIconColor = const Color.fromARGB(255, 150, 233, 147);
        statusIcon = Icons.start;
        break;
      case 3:
        statusText = 'Completed';
        statusColor = const Color.fromRGBO(151, 191, 165, 1.0);
        statusIconColor = const Color.fromARGB(255, 0, 240, 8);
        statusIcon = Icons.check;
        break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.grey;
        statusIconColor = Colors.grey;
        statusIcon = Icons.question_mark;
    }

    return {
      'statusText': statusText,
      'statusColor': statusColor,
      'statusIconColor': statusIconColor,
      'statusIcon': statusIcon,
    };
  }

  Widget _buildStatusIndicator(int status) {
    String statusText;
    Color statusIconColor;

    Map<String, dynamic> res = _getStatusIndicator(status);
    statusText = res["statusText"];
    statusIconColor = res["statusIconColor"];

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(0), // Padding for the border
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2), // White border
          ),
          child: Icon(Icons.circle, size: 8, color: statusIconColor),
        ),
        const SizedBox(width: 5),
        Text(
          statusText,
          style: const TextStyle(
              color: AppColors.secondary, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
