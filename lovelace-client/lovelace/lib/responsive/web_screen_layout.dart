import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _selectedPage = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() => {_selectedPage = page});
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page); // Animating  Page
    setState(() => {_selectedPage = page});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // hides the back arrow
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo-square.png',
              height: 45.0, width: 45.0),
        ),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(Icons.home,
                color: _selectedPage == 0
                    ? selectedColor
                    : unselectedColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(Icons.chat,
                color: _selectedPage == 1
                    ? selectedColor
                    : unselectedColor),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: Icon(Icons.person,
                color: _selectedPage == 2
                    ? selectedColor
                    : unselectedColor
                    ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: userScreens,
      ),
    );
  }
}
