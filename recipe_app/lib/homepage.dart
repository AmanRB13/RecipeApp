import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/details.dart';
import 'package:recipe_app/favorites_data.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<dynamic>> data;
  String? selectedCuisine;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    data = fetchRecipes();
  }

  Future<List<dynamic>> fetchRecipes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
    final decodedData = jsonDecode(response.body);
    return decodedData['recipes'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<dynamic>>(
          future: data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final recipes = snapshot.data!;

            final cuisines =
                recipes.map((r) => r['cuisine'].toString()).toSet().toList()
                  ..sort();

            final filteredByCuisine =
                selectedCuisine == null
                    ? recipes
                    : recipes
                        .where((r) => r['cuisine'] == selectedCuisine)
                        .toList();

            
            final filteredRecipes =
                filteredByCuisine
                    .where(
                      (r) => r['name'].toString().toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();

            return Column(
              children: [
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search recipes...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),

                
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 60,
                  width: 300,
                  child: DropdownButton<String?>(
                    value: selectedCuisine,
                    hint: const Text('Select Cuisine'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Cuisines'),
                      ),
                      ...cuisines.map((cuisine) {
                        return DropdownMenuItem<String?>(
                          value: cuisine,
                          child: Text(cuisine),
                        );
                      }).toList(),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCuisine = newValue; 
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      final recipeUrl = recipe['image'];
                      final recipeRating = recipe['rating'].toString();
                      final recipeName = recipe['name'].toString();

                      return Column(
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
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (favorites.contains(recipe)) {
                                        favorites.remove(recipe);
                                      } else {
                                        favorites.add(recipe);
                                      }
                                    });
                                  },
                                  child: Icon(
                                    favorites.contains(recipe)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Text(
                                  recipeRating,
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            recipeName,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
