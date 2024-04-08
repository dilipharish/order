import 'package:flutter/material.dart';
import 'package:order/constants.dart'; // Import your constants file
import 'package:mysql1/mysql1.dart';

class UserData {
  String name;
  String email;
  String address;
  String phoneNumber;

  UserData({
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });
}

class UserDataProvider with ChangeNotifier {
  UserData _userData =
      UserData(name: '', email: '', address: '', phoneNumber: '');

  UserData get userData => _userData;

  Map<String, dynamic> _changes = {};

  void updateUserData(UserData newData) {
    _userData = newData;
    notifyListeners();
  }

  void setChange(String key, dynamic value) {
    _changes[key] = value;
  }

  Map<String, dynamic> get changes => _changes;

  Future<void> saveChanges(int userId) async {
    try {
      final conn = await MySqlConnection.connect(settings);

      final queryResult = await conn.query(
        'UPDATE user SET name = ?, email = ?, phone_number = ?, address = ? WHERE uid = ?',
        [
          _userData.name,
          _userData.email,
          _userData.phoneNumber,
          _userData.address,
          userId,
        ],
      );

      if (queryResult.affectedRows! > 0) {
        // Optionally, you can clear changes here
        _changes.clear();
        notifyListeners();
      }

      await conn.close();
    } catch (e) {
      print("Exception in updating user data: $e");
    }
  }

  void clearUserData() {
    _userData = UserData(name: '', email: '', address: '', phoneNumber: '');
    notifyListeners();
  }
}
