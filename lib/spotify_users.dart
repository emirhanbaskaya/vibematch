import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpotifyUsersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> _fetchSpotifyUserNames() async {
    QuerySnapshot snapshot = await _firestore
        .collection('spotifyTokens')
        .where('accessToken', isNotEqualTo: null)
        .get();

    List<String> names = [];
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String name = data['displayName'] ?? 'Unknown User';
      names.add(name);
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Spotify Users'),
        ),
        body: FutureBuilder<List<String>>(
          future: _fetchSpotifyUserNames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No Spotify users found.'),
              );
            }
            else {
              List<String> names = snapshot.data!;
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        names[index]),
                  );
                },
              );
            }
          },
        ));
  }
}
