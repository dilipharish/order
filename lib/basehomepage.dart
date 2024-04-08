import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:order/authenticate/editprofilescreen.dart';
import 'package:order/authenticate/logout.dart';
import 'package:order/authenticate/resetpassword.dart';
import 'package:order/homepage.dart';
import 'package:order/screens/history.dart';
import 'package:order/screens/listofinstruction.dart';
import 'package:order/screens/orderitem.dart';

class BaseHomePage extends StatefulWidget {
  const BaseHomePage({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<BaseHomePage> createState() => _HomePageState();
}

class _HomePageState extends State<BaseHomePage> {
  int _currentIndex = 0;

  // List of widgets/screens for each index of the bottom navigation bar
  late List<Widget> _children;
  late List<AppBar> _appBars;

  @override
  void initState() {
    super.initState();
    _children = [
      // Replace these placeholders with your actual widgets
      HomePageBody(uid: widget.userId), // Widget for Home icon
      OrderItem(
        userId: widget.userId,
      ), // Widget for Search icon
      HistoryScreen(userId: widget.userId), // Widget for History icon
      ListOfInstructions(userId: widget.userId), // Widget for Doctor icon
    ];
    _appBars = [
      AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 222, 62, 62),
      ),
      AppBar(
        title: Text('Shopping'),
        backgroundColor: Color.fromARGB(
            255, 222, 62, 62), // Set the background color to green
      ),
      AppBar(
        title: Text('History'),
        backgroundColor: Color.fromARGB(
            255, 222, 62, 62), // Set the background color to green
      ),
      AppBar(
        title: Text('List of Instructions'),
        backgroundColor: Color.fromARGB(
            255, 222, 62, 62), // Set the background color to green
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex],
      backgroundColor: Color.fromARGB(255, 241, 239, 237),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            // ListTile(
            //   title: Text(
            //     'Edit Profile',
            //     style: TextStyle(
            //       fontSize: 16,
            //     ),
            //   ),
            //   onTap: () {
            //     // Implement navigation to edit profile screen
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             EditProfilePage(userId: widget.userId),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              title: Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Navigate to the reset password screen
                _navigateToResetPassword();
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              onTap: () {
                // Navigate to the logout screen
                _navigateToLogout();
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            //   colors: [
            //     Colors.blue, Colors.purple // Dark blue color at the bottom
            //   ],
            // ),
            ),
        child: _children[_currentIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.green, // Background color of the navigation bar
        buttonBackgroundColor:
            Color.fromARGB(255, 218, 45, 45), // Background color of the items
        height: 50,
        items: <Widget>[
          Icon(Icons.home,
              size: 24, color: Color.fromARGB(255, 244, 245, 244)), // Home icon
          Icon(Icons.shopping_cart_checkout,
              size: 24, color: Colors.white), // Search icon
          Icon(Icons.history, size: 24, color: Colors.white), // History icon
          Icon(Icons.list, size: 24, color: Colors.white), // Doctor icon
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Method to navigate to the reset password screen
  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordPage(userId: widget.userId),
      ),
    );
  }

  // Method to navigate to the logout screen
  void _navigateToLogout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogoutPage(),
      ),
    );
  }
}
