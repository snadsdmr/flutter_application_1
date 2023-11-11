import 'package:flutter/material.dart';
import 'spotify_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _genreController = TextEditingController();
  final SpotifyService _spotifyService = SpotifyService(
    clientId: '',
    clientSecret: '',
  );

  List<String> _recommendationResults = [];
  double _energy = 0.5;
  double _danceability = 0.5;

  // Define a list of genres
  List<String> _genres = [
    'pop',
    'rock',
    'hip-hop',
    'jazz',
    // Add more genres as needed
  ];

  String _selectedGenre = 'pop'; // Default genre

  void _recommend() async {
    final genre = _selectedGenre; // Use the selected genre
    final results =
        await _spotifyService.recommendTracks(genre, _energy, _danceability);
    setState(() {
      _recommendationResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedGenre,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenre = newValue!;
                });
              },
              items: _genres.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _recommend,
              child: Text('Recommend'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _recommendationResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_recommendationResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
