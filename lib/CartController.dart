import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:order/constants.dart';

class CCartController extends ChangeNotifier {
  List<String> _items = [];
  late MySqlConnection _connection; // Define MySqlConnection property

  List<String> get items => _items;
  int get itemCount => _items.length;

  // Method to connect to the database
  Future<void> connectToDatabase() async {
    try {
      // Implement your database connection logic here
      // For example:

      _connection = await MySqlConnection.connect(settings);
      // Notify listeners after successful connection
      notifyListeners();
    } catch (e) {
      // Handle connection errors here
      print('Error connecting to database: $e');
      // You might want to throw an error or handle it in a different way
    }
  }

  // Getter for the connection status
  bool get isConnected => _connection != null;

  // Getter for the MySqlConnection
  MySqlConnection get conn => _connection;

  void addToCart(String item) {
    _items.add(item);
    notifyListeners();
  }

  void removeFromCart(String item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
