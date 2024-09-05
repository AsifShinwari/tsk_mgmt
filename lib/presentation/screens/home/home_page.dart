import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:task_mgmnt_system/data/models/user_model.dart';
import '../../../core/widgets/base_page.dart';
import '../../../data/data_providers/auth_local_data_provider.dart';
import '../../controllers/auth_controller.dart';

// ignore: must_be_immutable
// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);

//   final AuthController authController = Get.find<AuthController>();
//   final AuthLocalDataProvider authLocalDataProvider =
//       Get.find<AuthLocalDataProvider>();

//   @override
//   Widget build(BuildContext context) {
//     return BasePage(
//       title: "Home",
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<UserModel?>(
//           future: authLocalDataProvider.getUser(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data == null) {
//               return const Text('No user data found.');
//             } else {
//               final user = snapshot.data!;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Welcome, ${user.givenName} ${user.familyName}',
//                       style: Theme.of(context).textTheme.bodyMedium),
//                   const SizedBox(height: 20),
//                   Text('Email: ${user.emailAddress}',
//                       style: Theme.of(context).textTheme.bodySmall),
//                   const SizedBox(height: 20),
//                   Text('User ID: ${user.employeeID}',
//                       style: Theme.of(context).textTheme.bodyLarge),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final AuthLocalDataProvider authLocalDataProvider =
      Get.find<AuthLocalDataProvider>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      appBar: AppBar(title: const Text('Home'),),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildTile(context, Icons.home, 'Home', '/home',false,null),
            _buildTile(context, Icons.note, 'Notes', '/notes',true,null),
            _buildTile(context, Icons.task, 'Tasks', '/tasks',true,null),
            _buildTile(context, Icons.help, 'Help', '/help',true,null),
            _buildTile(context, Icons.logout, 'Logout', '/logout',true,(){
              authController.logout();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, IconData icon, String label, String route,bool enabled,void Function()? fun) {
    return GestureDetector(
      onTap: fun ?? () {
        if(enabled){
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: (enabled) ? Colors.white : Colors.white70),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
