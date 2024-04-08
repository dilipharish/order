import 'dart:io';
import 'package:flutter/material.dart';
import 'package:order/authenticate/login.dart';
import 'package:order/provider.dart';
import 'package:provider/provider.dart';

void logout(BuildContext context) {
  final userDataProvider =
      Provider.of<UserDataProvider>(context, listen: false);

  // Clear user data using the clearUserData method
  userDataProvider.clearUserData();

  // Navigate to the login screen and replace the current route
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => LoginPage(
              title: 'National Company Demo',
            )),
  );
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Are you sure you want to logout?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform logout actions here
                logout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
