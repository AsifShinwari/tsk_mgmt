import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_mgmnt_system/data/models/task.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:task_mgmnt_system/presentation/controllers/task_controller.dart';
import 'package:task_mgmnt_system/presentation/screens/task/task_details_page.dart';

// ignore: must_be_immutable
class CheckOutPage extends StatefulWidget {
  Task task;
  final Box tasksBox;
  final String latitude;
  final String longitude;

  TaskController taskController = Get.find<TaskController>();

  CheckOutPage({
    super.key,
    required this.task,
    required this.tasksBox,
    required this.latitude,
    required this.longitude,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  String remarks = '';
  bool supportDuringTravel = false;
  String travelDetails = '';
  double travelKm = 0.0;
  bool isAdminstratMedicine = false;
  String medicationName = '';
  String medicationTime = '';
  bool isIncidentHappened = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Out'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text('You have successfully finished your shift.'),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(12),
                child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Please Write Your Notes.',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(5),
                    ),
                    minLines: 10,
                    maxLines: 20,
                    onChanged: (value) {
                      setState(() {
                        remarks = value;
                      });
                    },
                    validator: (value) {
                      if ((value == null || value.isEmpty)) {
                        return 'Remarks are required';
                      }
                      return null;
                    }),
              ),
              CheckboxListTile(
                title: const Text('Have You Traveled During Support?'),
                value: supportDuringTravel,
                onChanged: (bool? value) {
                  setState(() {
                    supportDuringTravel = value ?? false;
                  });
                },
              ),
              if (supportDuringTravel) ...[
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'If yes details of travel'),
                  onChanged: (value) {
                    setState(() {
                      travelDetails = value;
                    });
                  },
                  validator: (value) {
                    if (supportDuringTravel &&
                        (value == null || value.isEmpty)) {
                      return 'Travel Details are required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Number of KM'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      travelKm = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              ],
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('Have you administrate midication?'),
                value: isAdminstratMedicine,
                onChanged: (bool? value) {
                  setState(() {
                    isAdminstratMedicine = value ?? false;
                  });
                },
              ),
              if (isAdminstratMedicine) ...[
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'if yes, write name of Midication'),
                  onChanged: (value) {
                    setState(() {
                      medicationName = value;
                    });
                  },
                  validator: (value) {
                    if (isAdminstratMedicine &&
                        (value == null || value.isEmpty)) {
                      return 'Medication Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time'),
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        medicationTime = time.format(context);
                      });
                    }
                  },
                  readOnly: true,
                  controller: TextEditingController(text: medicationTime),
                  validator: (value) {
                    if (isAdminstratMedicine && (medicationTime.isEmpty)) {
                      return 'Medication Time is required';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Any incedent happened during shift'),
                    Text(
                      'If yes, please write separate incedent report',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                value: isIncidentHappened,
                onChanged: (bool? value) {
                  setState(() {
                    isIncidentHappened = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _handleCheckOut(context);

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously

                    Get.to(() => TaskDetailsPage(
                          task: widget.task,
                          tasksBox: widget.tasksBox,
                        ));
                  }
                },
                child: const Text('Check Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCheckOut(BuildContext context) async {
    // Update the Task object with new check-out information
    final updatedTask = widget.task.copyWith(
      supportDuringTravel: supportDuringTravel,
      travelDetails: travelDetails,
      travelKm: travelKm,
      isAdminstratMedicine: isAdminstratMedicine,
      medicationName: medicationName,
      medicationTime: medicationTime,
      isIncidentHappened: isIncidentHappened,
      latitude: widget.latitude,
      longitude: widget.longitude,
      remarks: remarks,
      schedulStatus: 3, // Mark the task as completed
    );
    // Save the updated task locally
    await widget.tasksBox.put(widget.task.clientSchedulDetialID, updatedTask);

    // Fetch the task immediately after saving to check if it was saved correctly
    final savedTask = widget.tasksBox.get(widget.task.clientSchedulDetialID);

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // If connected to the internet, push the data to the server

      // ignore: use_build_context_synchronously
      _showSnakBar(context, 'Internet Connectivity Available!',
          const Color.fromARGB(255, 59, 205, 88));

      // ignore: use_build_context_synchronously
      await _syncTaskWithServer(savedTask, context);
    } else {
      // ignore: use_build_context_synchronously
      _showSnakBar(context, 'Check In saved locally. No internet connection.',
          const Color.fromARGB(255, 132, 211, 135));
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Checked out successfully!')),
    );

    setState(() {
      widget.task = savedTask as Task;
    });
    widget.taskController.syncTasks(null, null);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    Get.to(() => TaskDetailsPage(task: widget.task, tasksBox: widget.tasksBox));
  }

  Future<void> _syncTaskWithServer(Task tsk, BuildContext context) async {
    try {
      // ignore: use_build_context_synchronously
      _showSnakBar(context, 'Syncing online started!',
          const Color.fromARGB(255, 209, 191, 31));

      String apiUrl =
          'https://myabilities.lightway-soft.com/api/WebServicesForMobileApp/endTask?'
          'subschleEndId=${tsk.clientSchedulDetialID}&tskEndTime=${tsk.checkInTime}&EndLatitute=${tsk.latitude}&endLogitute=${tsk.longitude}&SupportDuringTravel=${tsk.supportDuringTravel}&travalDetails=${tsk.travelDetails}&trvaelKm=${tsk.travelKm}&IsAdminstratMedicine=${tsk.isAdminstratMedicine}&medicationName=${tsk.medicationName}&medicationTime=${tsk.medicationTime}&IsIncidentHappened=${tsk.isIncidentHappened}&shiftNote=${tsk.remarks}';

      http.Response response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        _showSnakBar(context, 'Requested Successfully!', Colors.green);
        // Update the local record to mark it as synced
        final updatedTask = tsk.copyWith(
          synced: true, // Assuming 'synced' is a field in your Task model
        );
        await widget.tasksBox.put(tsk.clientSchedulDetialID, updatedTask);
        // ignore: use_build_context_synchronously
        _showSnakBar(
            context, 'Checked In successful and synced online!', Colors.green);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showSnakBar(
          context, 'Unable to sync online. ${e.toString()}', Colors.red);
    }
  }

  _showSnakBar(BuildContext ctx, String text, Color color) {
    if (ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
        ),
      );
    }
  }
}
