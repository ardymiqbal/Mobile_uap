import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/modules/register/controllers/register_controller.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController registerController = Get.put(RegisterController());

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
                        registerController.email.value = value,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    onChanged: (value) =>
                        registerController.password.value = value,
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
                      onPressed: registerController.register,
                      child: Text('Register', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Already have an account? Login',
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
