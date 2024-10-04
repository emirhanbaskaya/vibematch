import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SpotifyUsersScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore'dan yetkilendirilmiş Spotify kullanıcılarını alıyoruz.
  Future<List<String>> _fetchSpotifyUserNames() async {
    // 'accessToken' null olmayan, yetkilendirilmiş kullanıcıları sorgula.
    QuerySnapshot snapshot = await _firestore
        .collection('spotifyTokens')
        .where('accessToken', isNotEqualTo: null)
        .get();

    List<String> names = [];
    // Her kullanıcı dokümanı üzerinde dönerek, isimleri listeye ekle.
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
            // Veriler yüklenene kadar yüklenme animasyonu göster
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // Hata oluştuysa hata mesajı göster
            else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            // Eğer Spotify kullanıcısı bulunamadıysa bilgi mesajı göster
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No Spotify users found.'),
              );
            }
            // Kullanıcılar bulunduysa, isimleri listele
            else {
              List<String> names = snapshot.data!;
              return ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        names[index]), // Kullanıcı isimlerini listele
                  );
                },
              );
            }
          },
        ));
  }
}
