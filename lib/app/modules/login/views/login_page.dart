import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Image.asset('assets/img/logo.png', height: 100),
                  SizedBox(height: 30),
                  TextField(
                    onChanged: (value) =>
                        loginController.username.value = value,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    onChanged: (value) =>
                        loginController.password.value = value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: loginController.login,
                      child: Text('Login', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {}, // Link to forgot password if needed
                    child: Text('Forgot Password?',
                        style: TextStyle(color: Colors.white70)),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: loginController
                        .goToRegister, // Link to the Register page
                    child: Text('Create a new account',
                        style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
