import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import 'spotify_users.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
            ElevatedButton(
              onPressed: () async {
                User? user = await dbService.loginUser(
                    emailController.text, passwordController.text);
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Successfully logged in!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login failed")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text('Log In', style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
