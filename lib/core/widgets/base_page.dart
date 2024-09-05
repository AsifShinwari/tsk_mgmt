import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:task_mgmnt_system/core/constants/app_colors.dart';
import 'package:task_mgmnt_system/presentation/screens/notes/notes_page.dart';
import 'package:task_mgmnt_system/presentation/screens/task/task_page.dart';
import '../../data/data_providers/auth_local_data_provider.dart';
import '../../data/models/user_model.dart';
import '../../presentation/controllers/auth_controller.dart';

class BasePage extends StatelessWidget {
  final Widget body; // The body of the page
  final AppBar appBar; // The body of the page
  final FloatingActionButton? floatingActionButton;

  BasePage(
      {super.key,
      required this.body,
      required this.appBar,
      this.floatingActionButton});

  final AuthController authController = Get.find<AuthController>();
  final AuthLocalDataProvider authLocalDataProvider =
      Get.find<AuthLocalDataProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<UserModel?>(
              future: authLocalDataProvider.getUser(), // Fetch user data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Text(
                        'No User Found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  final user = snapshot.data!;
                  return DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: user.employeePhoto != ''
                                ? CachedNetworkImageProvider(
                                    "https://myabilities.lightway-soft.com/UserPhoto/${user.employeePhoto}",
                                  )
                                : const AssetImage('assets/images/logo.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: Text(
                              '${user.givenName} ${user.familyName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              user.emailAddress,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.task_alt_sharp,
                color: AppColors.primary,
              ),
              title: const Text('Schedules'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Settings Page
                Get.offAll(() => const TaskPage());
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.note_alt_sharp, color: AppColors.primary),
              title: const Text('Sticky Notes'),
              onTap: () {
                Get.offAll(() => const NotesPage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                authController.logout();
              },
            ),
          ],
        ),
      ),
      body: body,
      floatingActionButton:
          floatingActionButton, // This will be the specific page's content
    );
  }
}
