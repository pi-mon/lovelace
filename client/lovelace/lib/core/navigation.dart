import 'package:flutter/material.dart';
import 'package:lovelace/app/account/account_page.dart';
import 'package:lovelace/app/account/test.dart';
import 'package:lovelace/app/home/home_page.dart';


class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedPage = 0;

  final screens = [ // * This is a list of the different pages to navigate to in the app
    const HomePage(),
    const TestPage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,        
        title: Image.asset('assets/images/logo-square.png', height: 50.0, width: 50.0)
      ),
      body: screens[selectedPage], // * This makes the naviagtion betwen pages work via the bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        elevation: 5.0,
        selectedFontSize: 16.0,
        unselectedFontSize: 12.0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        }
      ),
    );
    // TODO: Create top navigation menu for bigger screens
    // TODO: Hide bottom navigatino bar for bigger screens
  }
}