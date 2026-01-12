import 'package:flutter/material.dart';
import 'favorites.dart';
import 'homepage.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  int selectedindex = 0;
  PageController pageController = PageController();

  void ontappeditem(int index) {
    setState(() {
      selectedindex = index;
    });
    pageController.jumpToPage(selectedindex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.blueGrey,
      appBar: AppBar(title: Text('Recipe app')),
      body: PageView(
        controller: pageController,
        children: [Homepage(), Favorites()],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        currentIndex: selectedindex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.red,
        onTap: ontappeditem,
      ),
    );
  }
}
