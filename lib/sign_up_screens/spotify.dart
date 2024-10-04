import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:date_app/database.dart';

class SpotifyScreen extends StatefulWidget {
  @override
  _SpotifyScreenState createState() => _SpotifyScreenState();
}

class _SpotifyScreenState extends State<SpotifyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String clientId = 'd83f24e094524ea499a2bb8d28fc7e61';
  final String redirectUri = 'com.vibematch://oauthredirect';
  final String scopes = 'user-read-email user-read-private';
  late String _codeVerifier;
  late String _codeChallenge;
  StreamSubscription? _sub;
  final DatabaseService dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _codeVerifier = _generateCodeVerifier();
    _codeChallenge = _generateCodeChallenge(_codeVerifier);
    _handleIncomingLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  String _generateCodeVerifier() {
    final Random random = Random.secure();
    final List<int> values =
    List<int>.generate(64, (i) => random.nextInt(256));
    return base64UrlEncode(values)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  String _generateState() {
    final Random random = Random.secure();
    final List<int> values =
    List<int>.generate(16, (i) => random.nextInt(256));
    return base64UrlEncode(values)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.scheme == 'com.vibematch') {
        _exchangeCodeForToken(uri);
      }
    }, onError: (Object err) {
      print('Deep link error: $err');
    });
  }

  Future<void> _exchangeCodeForToken(Uri uri) async {
    final String? code = uri.queryParameters['code'];

    if (code != null) {
      print('Authorization Code: $code');

      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'code_verifier': _codeVerifier,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> tokenData = json.decode(response.body);
        final String accessToken = tokenData['access_token'];
        final String refreshToken = tokenData['refresh_token'];

        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');

        final User? currentUser = _auth.currentUser;
        if (currentUser == null) {
          throw Exception('User is not logged in');
        }

        // Spotify kullanıcı profilini al
        final userProfile = await _fetchSpotifyUserProfile(accessToken);
        final spotifyUserId = userProfile['id'];
        final displayName = userProfile['display_name'];

        // Spotify tokenlarını ve displayName'i kaydet
        await dbService.saveSpotifyToken(
          spotifyUserId,
          accessToken,
          refreshToken,
          displayName,
        );
      } else {
        print('Token error: ${response.body}');
      }
    } else {
      print('Authorization Code not found.');
    }
  }

  Future<Map<String, dynamic>> _fetchSpotifyUserProfile(
      String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> authenticateWithSpotify() async {
    String state = _generateState();

    final authorizationUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': clientId,
      'response_type': 'code',
      'redirect_uri': redirectUri,
      'scope': scopes,
      'state': state,
      'code_challenge_method': 'S256',
      'code_challenge': _codeChallenge,
    });

    if (await canLaunch(authorizationUrl.toString())) {
      await launch(authorizationUrl.toString());
    } else {
      throw 'Could not launch ${authorizationUrl.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await authenticateWithSpotify();
              },
              child: Text('Connect with Spotify'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/spotify_users');
              },
              child: Text('View Spotify Users'),
            ),
          ],
        ),
      ),
    );
  }
}
