import 'package:flutter/material.dart';
import 'package:order/constants.dart';
import 'package:mysql1/mysql1.dart';
import 'package:order/basehomepage.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  DateTime? selectedDate; // Variable to store selected date
  String result = '';

  Future<void> _registerUser() async {
    try {
      final conn = await MySqlConnection.connect(settings);

      // Check if the phone number is valid (10 digits)
      if (phoneNumber.text.length != 10) {
        setState(() {
          result = 'Please enter a valid 10-digit phone number';
        });
        return; // Exit function if phone number is invalid
      }

      final checkResult = await conn.query(
        'SELECT * FROM user WHERE email = ?',
        [email.text],
      );

      if (checkResult.isNotEmpty) {
        setState(() {
          result = 'User with the same email already exists';
        });
      } else {
        final queryResult = await conn.query(
          'INSERT INTO user ( email, name, address, phone_number, password) VALUES ( ?, ?, ?, ?, ?)',
          [
            email.text,
            name.text,
            address.text,
            phoneNumber.text,
            password.text,
          ],
        );

        if (queryResult.affectedRows! > 0) {
          final insertedIdResult =
              await conn.query('SELECT LAST_INSERT_ID() as id');
          final userId = insertedIdResult.first['id'];

          // Provider.of<UserDataProvider>(context, listen: false).updateUserData(
          //   UserData(
          //       name: name.text,
          //       email: email.text,
          //       dob: dob.text,
          //       address: address.text,
          //       phoneNumber: phoneNumber.text),
          // );

          setState(() {
            result = 'Registration successful';
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BaseHomePage(userId: userId),
            ),
          );
        } else {
          setState(() {
            result = 'Registration failed';
          });
        }
      }

      await conn.close();
    } catch (e) {
      print("Exception in registration: $e");
      setState(() {
        result = 'An error occurred during registration';
      });
    }
  }

  // Validate phone number length
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length != 10) {
      return 'Please enter a 10-digit phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title + ' Register and Save Lives'),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView to handle overflow
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Register a New User:',
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: address,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your address',
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: phoneNumber,
                  keyboardType: TextInputType.phone,
                  maxLength: 10, // Limit input to 10 digits
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: _validatePhoneNumber, // Validate phone number
                ),
                SizedBox(height: 20.0),
                Text(
                  '$result',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _registerUser,
        label: Text('Register'), // Change floating action button text
        icon: Icon(Icons.person_add),
      ),
    );
  }
}
