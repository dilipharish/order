import 'package:flutter/material.dart';
import 'package:order/constants.dart';
import 'package:mysql1/mysql1.dart';
import 'package:provider/provider.dart';
import 'package:order/authenticate/registration.dart';
import 'package:order/basehomepage.dart'; // Import the HomePage

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String result = '';

  Future<void> _loginUser(BuildContext context) async {
    try {
      final conn = await MySqlConnection.connect(settings);

      final queryResult = await conn.query(
        'SELECT * FROM user WHERE email = ? AND password = ?',
        [email.text, password.text],
      );

      if (queryResult.isNotEmpty) {
        setState(() {
          result = 'Login successful';
        });

        // Fetch the user details
        final row = queryResult.first;
        final uid = row['uid'];

        // Navigate to home screen and pass user uid
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BaseHomePage(userId: uid),
          ),
        );
      } else {
        setState(() {
          result = 'Invalid email or password';
        });
      }

      await conn.close();
    } catch (e) {
      print("Exception in login: $e");
      setState(() {
        result = 'An error occurred during login';
      });
    }
  }

  void _navigateToRegistrationPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(
          title: 'Registration',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title + ' Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login:',
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
                Text(
                  '$result',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () =>
                      _loginUser(context), // Pass context to _loginUser
                  child: Text('Login'),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () => _navigateToRegistrationPage(context),
                  child: Text('Are you a new user? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
