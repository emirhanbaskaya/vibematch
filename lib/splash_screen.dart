import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Date App',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                child: Text('Get Started', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
