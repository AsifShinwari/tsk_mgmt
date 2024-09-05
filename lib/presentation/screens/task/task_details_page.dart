import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:task_mgmnt_system/data/models/task.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_mgmnt_system/presentation/screens/task/check_out_page.dart';
import 'package:task_mgmnt_system/presentation/controllers/task_controller.dart';

// ignore: must_be_immutable
class TaskDetailsPage extends StatefulWidget {
  Task task;
  final Box tasksBox;

  TaskDetailsPage({
    super.key,
    required this.task,
    required this.tasksBox,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TaskController taskController = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Staff Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                _buildDetailRow(
                  'Staff Name:',
                  widget.task.assignedByEmployeeName,
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Status:',
                  widget.task.schedulStatus == 1
                      ? 'Pending'
                      : widget.task.schedulStatus == 2
                          ? 'Started'
                          : 'Completed',
                  icon: Icons.info_outline,
                  valueStyle: TextStyle(
                    color: widget.task.schedulStatus == 1
                        ? Colors.orange
                        : widget.task.schedulStatus == 2
                            ? Colors.blue
                            : Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Check In Date:',
                  '${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.task.schedualStartDate))} ${widget.task.schedualStarttime}',
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Check Out Date:',
                  '${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.task.schedualEndDate))} ${widget.task.scheualEndTime}',
                  icon: Icons.access_time_filled,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Client Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                _buildDetailRow(
                  'Schedule Title:',
                  widget.task.schedualTitle,
                  icon: Icons.title,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Comments:',
                  widget.task.schedualComments,
                  icon: Icons.comment,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Client Name:',
                  '${widget.task.sureName} ${widget.task.givenName}',
                  icon: Icons.account_box,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Client Address:',
                  widget.task.clientAddress,
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: widget.task.schedulStatus == 1 ||
                            widget.task.schedulStatus == 2
                        ? () => _handleCheckIn(context)
                        : null,
                    icon: const Icon(Icons.check_circle),
                    label: Text(widget.task.schedulStatus == 1
                        ? 'Check In'
                        : 'Check Out'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {TextStyle? valueStyle, IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  Future<void> _handleCheckIn(BuildContext context) async {
    try {
      _showSnakBar(context, 'Checking GPS Location!',
          const Color.fromARGB(255, 205, 205, 59));

      await _checkLocationPermission();

      String currentTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String latitude = position.latitude.toString();
      String longitude = position.longitude.toString();

      if (widget.task.schedulStatus == 2) {
        Get.to(() => CheckOutPage(
              task: widget.task,
              tasksBox: widget.tasksBox,
              latitude: latitude,
              longitude: longitude,
            ));
        return;
      }

      // Update the Task object with new check-in information
      final updatedTask = widget.task.copyWith(
          checkInTime: currentTime,
          latitude: latitude,
          longitude: longitude,
          schedulStatus: 2);

      // Save the updated task locally
      await widget.tasksBox.put(widget.task.clientSchedulDetialID, updatedTask);
      var tsk = taskController.getTaskById(widget.task.clientSchedulDetialID);

      setState(() {
        widget.task = tsk as Task;
      });

      // ignore: use_build_context_synchronously
      _showSnakBar(context, 'Checking Internet Connectivity!',
          const Color.fromARGB(255, 205, 205, 59));

      // Check internet connectivity
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // If connected to the internet, push the data to the server

        // ignore: use_build_context_synchronously
        _showSnakBar(context, 'Internet Connectivity Available!',
            const Color.fromARGB(255, 59, 205, 88));

        // ignore: use_build_context_synchronously
        await _syncTaskWithServer(updatedTask, context);
      } else {
        // ignore: use_build_context_synchronously
        _showSnakBar(context, 'Check In saved locally. No internet connection.',
            const Color.fromARGB(255, 132, 211, 135));
      }

      taskController.syncTasks(null, null);
    } catch (e) {
      _showSnakBar(context, 'An error occurred: $e', Colors.red);
    }
  }

  Future<void> _syncTaskWithServer(Task tsk, BuildContext context) async {
    var taskData = widget.tasksBox.get(tsk.clientSchedulDetialID);

    _showSnakBar(context, 'Syncing online started!',
        const Color.fromARGB(255, 209, 191, 31));

    if (taskData != null) {
      String apiUrl =
          'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/startTask?'
          'subSchlId=${tsk.clientSchedulDetialID}&sTime=${tsk.checkInTime}&lttd=${tsk.latitude}&lngtd=${tsk.longitude}';

      http.Response response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showSnakBar(context, 'Requested Successfully!', Colors.green);
        // Update the local record to mark it as synced
        final updatedTask = tsk.copyWith(
          synced: true, // Assuming 'synced' is a field in your Task model
        );
        await widget.tasksBox.put(tsk.clientSchedulDetialID, updatedTask);
      } else {
        // ignore: use_build_context_synchronously
        _showSnakBar(context, 'Server Error!', Colors.red);
      }
    }
  }

  void _showSnakBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
