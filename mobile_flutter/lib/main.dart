import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'users/login.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthCheck(
        authenticatedScreen: HomeScreen(),
        unauthenticatedScreen: Login(),
      ),
    );
  }
}
