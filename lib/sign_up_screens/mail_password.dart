import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../database.dart';

class MailPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (passwordController.text == confirmPasswordController.text) {
                  try {
                    await dbService.signUpAndSaveUserData(
                      emailController.text,
                      passwordController.text,
                      "SampleName",
                      "01",
                      "01",
                      "2000",
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registration successful!")),
                    );
                    Navigator.pushNamed(context, '/login');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match")),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
