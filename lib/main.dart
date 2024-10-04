import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';
import 'sign_up_screens/name_old.dart';
import 'sign_up_screens/spotify.dart';
import 'sign_up_screens/mail_password.dart';
import 'login.dart';
import 'spotify_users.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Date App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          buttonColor: Colors.yellow,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/signup': (context) => NameScreen(),
        '/spotify': (context) => SpotifyScreen(),
        '/login': (context) => LoginScreen(),
        '/mail_password': (context) => MailPasswordScreen(),
        '/spotify_users': (context) => SpotifyUsersScreen(),
      },
    );
  }
}
