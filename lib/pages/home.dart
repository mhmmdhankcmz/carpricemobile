import 'package:carpricemobile/pages/favorite_page.dart';
import 'package:carpricemobile/pages/products_page.dart';
import 'package:carpricemobile/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../widgets/my_appbar.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
   int selectedIndex = 0;
   final PageController _pageController = PageController();
    final pages = [
       ProductsPage(),
      const FavoritePage(),
      const ProfilPage(),
    ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:  MyAppBar(),
        body:  PageView(
          controller: _pageController,
          children: [
            pages[selectedIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            currentIndex: selectedIndex,
            showSelectedLabels: true,
            onTap: (index)=>setState(()=>selectedIndex=index),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home,color: selectedIndex==0 ? Colors.deepOrangeAccent :Colors.grey,),label: 'Anasayfa'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite,color: selectedIndex==1 ? Colors.deepOrangeAccent :Colors.grey,),label: 'Favoriler'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded,color: selectedIndex==2 ? Colors.deepOrangeAccent :Colors.grey,),label: 'Profil'),
            ]
        ),
      ),
    );
  }
}

