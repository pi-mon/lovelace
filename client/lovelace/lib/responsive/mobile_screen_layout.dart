import 'package:flutter/material.dart';
import 'package:lovelace/screens/account_screen.dart';
import 'package:lovelace/screens/home_screen.dart';
import 'package:lovelace/screens/test.dart';
import 'package:lovelace/utils/colors.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int selectedPage = 0;

  final screens = [ // * This is a list of the different pages to navigate to in the app
    const HomeScreen(),
    const TestScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,        
        title: Image.asset('assets/images/logo-square.png', height: 50.0, width: 50.0)
      ),
      body: screens[selectedPage], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple,
        items: const [ // * The number of BottomNavigationBarItems must be equal to the number of Widgets in the screens list
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        elevation: 5.0,
        selectedFontSize: 16.0,
        unselectedFontSize: 12.0,
        selectedItemColor: selectedIconColor,
        unselectedItemColor: unselectedIconColor,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        }
      )
    );
  }
}