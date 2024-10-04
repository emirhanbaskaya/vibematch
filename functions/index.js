const functions = require("firebase-functions");
const express = require('express');
const cors = require('cors');
const admin = require("firebase-admin");
const fetch = require('node-fetch'); // node-fetch modülü ekleyin

// Firebase Admin SDK'yı başlatıyoruz
admin.initializeApp();
const db = admin.firestore();

// Express.js uygulamamızı oluşturuyoruz
const app = express();

// CORS ayarlarını tanımlıyoruz
const corsOptions = {
  origin: true,
  credentials: true,
};

app.use(cors(corsOptions)); // CORS orta katmanını ekliyoruz
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Spotify kullanıcı bilgilerini alma fonksiyonu
async function fetchSpotifyProfile(accessToken) {
  const response = await fetch('https://api.spotify.com/v1/me', {
    method: 'GET',
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  if (response.ok) {
    return await response.json();
  } else {
    throw new Error('Spotify profile could not be fetched');
  }
}

// saveSpotifyTokens endpoint'i
app.post('/saveSpotifyTokens', async (req, res) => {
  const { userId, accessToken, refreshToken } = req.body;

  if (!userId || !accessToken || !refreshToken) {
    return res.status(400).send("userId, accessToken ve refreshToken gereklidir.");
  }

  try {
    // Spotify API'den kullanıcı bilgilerini alıyoruz
    const spotifyProfile = await fetchSpotifyProfile(accessToken);

    // Tokenları ve Spotify kullanıcı adını Firestore'a kaydet
    await db.collection('spotifyTokens').doc(userId).set({
      accessToken: accessToken,
      refreshToken: refreshToken,
      displayName: spotifyProfile.display_name || null, // Spotify kullanıcı adı
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log('Tokenlar ve kullanıcı adı Firestore\'a kaydedildi.');
    return res.status(200).send("Tokenlar ve kullanıcı adı başarıyla kaydedildi.");
  } catch (error) {
    console.error("Tokenlar kaydedilirken hata oluştu:", error);
    return res.status(500).send("Tokenlar kaydedilirken hata oluştu.");
  }
});

// Express uygulamasını tek bir Cloud Function olarak dışa aktarıyoruz
exports.api = functions.https.onRequest(app);
