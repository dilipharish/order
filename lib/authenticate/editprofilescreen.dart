// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:order/constants.dart';
import 'package:order/provider.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final int userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final conn = await MySqlConnection.connect(settings);
      final queryResult = await conn.query(
        'SELECT name, email, phone_number, address FROM user WHERE uid = ?',
        [widget.userId],
      );

      if (queryResult.isNotEmpty) {
        final user = queryResult.first;
        setState(() {
          nameController.text = user['name'];
          emailController.text = user['email'];
          phoneNumberController.text = user['phone_number'];
          addressController.text = user['address'].toString();
        });
      }

      await conn.close();
    } catch (e) {
      print("Exception in fetching user data: $e");
    }
  }

  Future<void> _updateProfile() async {
    try {
      // Validate phone number length
      if (phoneNumberController.text.length != 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number should be exactly 10 digits.'),
          ),
        );
        return;
      }

      final conn = await MySqlConnection.connect(settings);

      final queryResult = await conn.query(
        'UPDATE user SET name = ?, email = ?, phone_number = ?, address = ? WHERE uid = ?',
        [
          nameController.text,
          emailController.text,
          phoneNumberController.text,
          addressController.text,
          widget.userId,
        ],
      );

      if (queryResult.affectedRows! > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile'),
          ),
        );
      }

      await conn.close();
    } catch (e) {
      print("Exception in updating user data: $e");
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   // DateTime? pickedDate = await showDatePicker(
  //   //   context: context,
  //   //   initialDate: selectedDate ?? DateTime.now(),
  //   //   firstDate: DateTime(1900),
  //   //   lastDate: DateTime.now(),
  //   // );

  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserDataProvider>(
          builder: (context, userDataProvider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  onChanged: (value) {
                    userDataProvider.setChange('name', value);
                  },
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  onChanged: (value) {
                    userDataProvider.setChange('email', value);
                  },
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneNumberController,
                  onChanged: (value) {
                    userDataProvider.setChange('phone_number', value);
                  },
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                // GestureDetector(
                //   onTap: () => _selectDate(context),
                //   child: AbsorbPointer(
                //     child: TextField(
                //       controller: TextEditingController(
                //           text: selectedDate?.toString() ?? ''),
                //       decoration:
                //           const InputDecoration(labelText: 'Date of Birth'),
                //     ),
                //   ),
                // ),
                TextField(
                  controller: addressController,
                  onChanged: (value) {
                    userDataProvider.setChange('address', value);
                  },
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateProfile();
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
