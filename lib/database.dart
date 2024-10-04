import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpUser(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<void> saveUserData(
      String uid,
      String firstName,
      String birthMonth,
      String birthDay,
      String birthYear) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'birthMonth': birthMonth,
        'birthDay': birthDay,
        'birthYear': birthYear,
      }, SetOptions(merge: true)); // Var olan veriyi koruyarak günceller
      print("User data saved successfully.");
    } catch (e) {
      print("Failed to save user data: $e");
    }
  }

  Future<void> saveSpotifyToken(
      String userId,
      String accessToken,
      String refreshToken,
      String displayName) async {
    try {
      await _firestore.collection('spotifyTokens').doc(userId).set({
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'displayName': displayName,
      });
      print("Spotify tokens and displayName saved successfully.");
    } catch (e) {
      print("Failed to save Spotify tokens: $e");
    }
  }

  Future<Map<String, String>?> getSpotifyTokens(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('spotifyTokens').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return {
          'accessToken': data['accessToken'],
          'refreshToken': data['refreshToken'],
        };
      }
    } catch (e) {
      print("Failed to fetch Spotify tokens: $e");
    }
    return null;
  }

  Future<String?> refreshSpotifyToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': 'd83f24e094524ea499a2bb8d28fc7e61',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access_token']; // Yeni access token alınır
      } else {
        print('Failed to refresh Spotify token: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error refreshing Spotify token: $e');
      return null;
    }
  }

  Future<void> signUpAndSaveUserData(
      String email,
      String password,
      String firstName,
      String birthMonth,
      String birthDay,
      String birthYear) async {
    User? user = await signUpUser(email, password);
    if (user != null) {
      await saveUserData(
          user.uid, firstName, birthMonth, birthDay, birthYear);
    }
  }
}
