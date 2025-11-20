import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  // Login method
  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiService.post('/login', {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // The backend returns 'access_token', not 'token'
        String token = data["access_token"];

        // Save token using ApiService helper
        await ApiService.saveToken(token);

        // Optionally save user data
        if (data.containsKey("user")) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', jsonEncode(data["user"]));
        }

        return true;
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Register method
  static Future<bool> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await ApiService.post('/register', {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
      });

      print('Register: ${response.statusCode} - ${response.body}');

      // Registration returns 201 on success
      if (response.statusCode == 201) {
        return true;
      } else {
        print('Register failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Logout method
  static Future<bool> logout() async {
    try {
      final response = await ApiService.post('/logout', {});

      // Remove token regardless of response
      await ApiService.removeToken();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');

      return response.statusCode == 200;
    } catch (e) {
      print('Logout error: $e');
      // Still remove local token even if API call fails
      await ApiService.removeToken();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      return false;
    }
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user');

      if (userJson != null) {
        return jsonDecode(userJson);
      }
      return null;
    } catch (e) {
      print('Get current user error: $e');
      return null;
    }
  }
}

// AuthCheck Widget - checks if user is authenticated
class AuthCheck extends StatefulWidget {
  final Widget authenticatedScreen;
  final Widget unauthenticatedScreen;

  const AuthCheck({
    super.key,
    required this.authenticatedScreen,
    required this.unauthenticatedScreen,
  });

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuthenticated = await ApiService.isAuthenticated();

    if (!mounted) return;

    if (isAuthenticated) {
      // Navigate to authenticated screen (HomeScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.authenticatedScreen,
        ),
      );
    } else {
      // Navigate to unauthenticated screen (Login)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => widget.unauthenticatedScreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
