// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

import '../utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
    int _pageIndex = 0;
    PageController _pageController = PageController();

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
      setState(() {
        _pageIndex = page;
      });
    }
    // User user = UserProvider().getUser as User;

    void onPageChanged(int page) {
      setState(() {
        _pageIndex = page;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Instagram"),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              color: _pageIndex == 0 ? Colors.white : Colors.grey,
              onPressed: () {
                navigationTapped(0);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              color: _pageIndex == 1 ? Colors.white : Colors.grey,
              onPressed: () {
                navigationTapped(1);
              },
            ),
            IconButton(
              icon: Icon(Icons.add_a_photo_rounded),
              color: _pageIndex == 2 ? Colors.white : Colors.grey,
              onPressed: () {
                navigationTapped(2);
              },
            ),
            IconButton(
              onPressed: () {
                navigationTapped(3);
              },
              icon: Icon(Icons.favorite),
              color: _pageIndex == 3 ? Colors.white : Colors.grey,
            ),
            IconButton(
              onPressed: () {
                navigationTapped(4);
              },
              icon: Icon(Icons.person),
              color: _pageIndex == 4 ? Colors.white : Colors.grey,
            )
          ],
        ),
        body: PageView(
          children: homeScreenItems,
          controller: _pageController,
          onPageChanged: onPageChanged,
        ));
  }
}
