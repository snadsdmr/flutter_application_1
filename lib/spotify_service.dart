import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String clientId;
  final String clientSecret;
  final String base64Encoded;

  SpotifyService({required this.clientId, required this.clientSecret})
      : base64Encoded = base64.encode(utf8.encode('$clientId:$clientSecret'));

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $base64Encoded',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<List<String>> recommendTracks(
      String genre, double energy, double danceability) async {
    final accessToken = await _getAccessToken();

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/recommendations?seed_genres=$genre&energy=$energy&danceability=$danceability'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final tracks = jsonResponse['tracks'] as List<dynamic>;
      return tracks.map((track) => track['name'] as String).toList();
    } else {
      throw Exception('Failed to recommend tracks');
    }
  }
}
