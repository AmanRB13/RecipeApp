import 'package:flutter/material.dart';
import 'homepage.dart';
import 'buttomnav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,

      home: Bottomnavigation(),

      routes: {'/homepage': (context) => const Homepage()},
    );
  }
}
