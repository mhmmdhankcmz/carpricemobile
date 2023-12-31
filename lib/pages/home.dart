import 'package:carpricemobile/design_config/color.dart';
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
          elevation: 100,
          unselectedFontSize: 8,
          unselectedIconTheme:const IconThemeData(size: 15),

          type: BottomNavigationBarType.fixed,

            currentIndex: selectedIndex,
            showSelectedLabels: true,
            onTap: (index)=>setState(()=>selectedIndex=index),
            backgroundColor: MyColors().bottomNavColor,
            selectedItemColor: MyColors().selectedIconColor,
            unselectedItemColor: MyColors().unSelectedIconColor,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Anasayfa'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite,),label: 'Favoriler'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded,),label: 'Profil'),
            ]
        ),
      ),
    );
  }
}

