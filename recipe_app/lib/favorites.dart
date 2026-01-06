import 'package:flutter/material.dart';
import 'package:recipe_app/favorites_data.dart';
import 'details.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body:
          favorites.isEmpty
              ? const Center(child: Text('No favorites are added here'))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final recipe = favorites[index];
                  final recipeUrl = recipe['image'];
                  final recipeName = recipe['name'];

                  return Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => Details(recipe: recipe),
                                  ),
                                );
                              },
                              child: Container(
                                height: 400,
                                width: 300,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(recipeUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    favorites.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          recipeName,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
