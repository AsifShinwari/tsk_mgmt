import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../core/widgets/base_page.dart';
import '../../../data/models/notification_model.dart';
import '../../controllers/task_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TaskController taskController = Get.find<TaskController>();
  late Future<List<NotificationModel>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize notifications future
    notificationsFuture = taskController.getCountOfTodaysTasksOnline(
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 1,
                  color: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Html(data: notification.dataMessage),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No notifications available.'));
          }
        },
      ),
    );
  }
}
