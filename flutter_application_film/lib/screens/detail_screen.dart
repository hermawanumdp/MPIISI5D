import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_film/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

  Future<void> _checkIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.containsKey('movie_${widget.movie.id}');
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
    });

    if (_isFavorite) {
      final String movieJson = jsonEncode(widget.movie.toJson());
      print("Movie JSON " + movieJson);
      prefs.setString('movie_${widget.movie.id}', movieJson);
      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];
      favoriteMovieIds.add(widget.movie.id.toString());
      prefs.setStringList('favoriteMovies', favoriteMovieIds);
    } else {
      prefs.remove('movie_${widget.movie.id}');
      List<String> favoriteMovieIds =
          prefs.getStringList('favoriteMovies') ?? [];
      favoriteMovieIds.remove(widget.movie.id.toString());
      prefs.setStringList('favoriteMovies', favoriteMovieIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.backdropPath}',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: _toggleFavorite,
                    //onPressed: () {},
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.movie.overview),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Release Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.movie.releaseDate)
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Rating',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(widget.movie.voteAverage.toString())
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
