import 'package:flutter/material.dart';
import 'package:order/CartController.dart';
import 'package:provider/provider.dart';

import 'package:order/screens/cart_controller.dart';
import 'package:order/authenticate/login.dart';
import 'package:order/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CCartController>(
            create: (_) => CCartController()),
        ChangeNotifierProvider<UserDataProvider>(
            create: (_) => UserDataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'National Company',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(
        title: 'National Company Demo',
      ),
    );
  }
}
