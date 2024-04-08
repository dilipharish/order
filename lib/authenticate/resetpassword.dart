import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:order/constants.dart';

class ResetPasswordPage extends StatefulWidget {
  final int userId;

  const ResetPasswordPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String currentPassword = '';
  String newPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              obscureText: true,
              onChanged: (value) {
                currentPassword = value;
              },
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextFormField(
              obscureText: true,
              onChanged: (value) {
                newPassword = value;
              },
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (currentPassword.isEmpty || newPassword.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Please enter both current and new passwords.'),
                    ),
                  );
                  return;
                }

                if (await _validateCurrentPassword(currentPassword)) {
                  await _updatePassword(newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated successfully.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Incorrect current password.'),
                    ),
                  );
                }
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _validateCurrentPassword(String currentPassword) async {
    try {
      final conn = await MySqlConnection.connect(settings);
      final queryResult = await conn.query(
        'SELECT * FROM user WHERE uid = ? AND password = ?',
        [widget.userId, currentPassword],
      );
      await conn.close();
      return queryResult.isNotEmpty;
    } catch (e) {
      print("Exception in validating current password: $e");
      return false;
    }
  }

  Future<void> _updatePassword(String newPassword) async {
    try {
      final conn = await MySqlConnection.connect(settings);
      final queryResult = await conn.query(
        'UPDATE user SET password = ? WHERE uid = ?',
        [newPassword, widget.userId],
      );
      await conn.close();

      // Navigate back to BaseHomePage after successful password reset
      // Navigator.popUntil(context, ModalRoute.withName('/'));
    } catch (e) {
      print("Exception in updating password: $e");
    }
  }
}
