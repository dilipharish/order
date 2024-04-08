import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:order/constants.dart';
import 'package:order/provider.dart'; // Import your UserDataProvider

class HomePageBody extends StatefulWidget {
  final int uid;

  const HomePageBody({Key? key, required this.uid}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  late Future<UserData> _userData;
  late UserDataProvider _userDataProvider;

  @override
  void initState() {
    super.initState();
    _userDataProvider = UserDataProvider();
    _userData = _fetchUserData(widget.uid);
  }

  Future<UserData> _fetchUserData(int uid) async {
    final conn = await MySqlConnection.connect(settings);

    var result = await conn.query('SELECT * FROM user WHERE uid = ?', [uid]);

    await conn.close();

    // Assuming only one row is returned
    final userData = UserData(
      name: result.first['name'] ?? '',
      email: result.first['email'] ?? '',
      address: result.first['address'] ?? '',
      phoneNumber: result.first['phone_number'] ?? '',
    );

    // Update user data in the provider
    _userDataProvider.updateUserData(userData);

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            // Image at the top
            'assets/images/INDIA.jpg', // Replace with your image path
            width: 200, // Adjust width as needed
            height: 200, // Adjust height as needed
            fit: BoxFit.cover, // Adjust image fit as needed
          ),
          SizedBox(height: 20),
          FutureBuilder<UserData>(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final userData = snapshot.data!;
                return Column(
                  children: <Widget>[
                    Text(
                      'Welcome to the Home Page!',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Email: ${userData.email}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Name: ${userData.name}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Address: ${userData.address}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Phone Number: ${userData.phoneNumber}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
