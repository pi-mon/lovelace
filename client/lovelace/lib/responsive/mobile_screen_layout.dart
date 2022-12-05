import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Image.asset('assets/images/logo-square.png',
              height: 45.0, width: 45.0),
          toolbarHeight: 64,
        ),
        body: screens[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: primaryColor,
            selectedItemColor: whiteColor,
            items: const [
              // * The number of BottomNavigationBarItems must be equal to the number of Widgets in the screens list
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Feed'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Account'),
            ],
            elevation: 5.0,
            selectedFontSize: 16.0,
            unselectedFontSize: 12.0,
            // selectedItemColor: selectedIconColor,
            // unselectedItemColor: unselectedIconColor,
            showUnselectedLabels: false,
            onTap: (index) {
              setState(() {
                _selectedPage = index;
              });
            }));
  }
}
