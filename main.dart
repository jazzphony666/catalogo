import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'movie.dart'; //

void main() {
  runApp(const CatalogoPeliculasApp());
}

class CatalogoPeliculasApp extends StatelessWidget {
  const CatalogoPeliculasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Películas',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const ListaPeliculas(),
    );
  }
}

class ListaPeliculas extends StatefulWidget {
  const ListaPeliculas({super.key});

  @override
  State<ListaPeliculas> createState() => _ListaPeliculasState();
}

class _ListaPeliculasState extends State<ListaPeliculas> {
  late Future<List<Movie>> _peliculas;

  Future<List<Movie>> cargarPeliculas() async {
    final String response = await rootBundle.loadString('assets/movies.json');
    final List<dynamic> data = json.decode(response);

    return data.map((json) => Movie.fromJson(json)).toList();
  }

  @override
  void initState() {
    super.initState();
    _peliculas = cargarPeliculas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Catálogo de Películas'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _peliculas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay películas disponibles.'));
          } else {
            final peliculas = snapshot.data!;
            return ListView.builder(
              itemCount: peliculas.length,
              itemBuilder: (context, index) {
                final pelicula = peliculas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      pelicula.poster,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(pelicula.title),
                    subtitle: Text(
                        '${pelicula.director} • ${pelicula.year.toString()}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
