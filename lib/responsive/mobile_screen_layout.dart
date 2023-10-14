// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
  // User user = UserProvider().getUser as User;

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        backgroundColor: const Color.fromARGB(255, 63, 61, 61),
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              backgroundColor:
                  _pageIndex == 0 ? primaryColor : Colors.transparent),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              backgroundColor:
                  _pageIndex == 1 ? primaryColor : Colors.transparent),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '',
              backgroundColor:
                  _pageIndex == 2 ? primaryColor : Colors.transparent),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: '',
              backgroundColor:
                  _pageIndex == 3 ? primaryColor : Colors.transparent),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
              backgroundColor:
                  _pageIndex == 4 ? primaryColor : Colors.transparent),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
