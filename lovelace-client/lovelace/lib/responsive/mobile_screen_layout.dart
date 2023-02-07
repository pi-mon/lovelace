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
        automaticallyImplyLeading: false, // hides the back arrow
        toolbarHeight: 64,
        title: Row(
          children: const <Widget>[
            Image(image: AssetImage("assets/images/logo-text.png"), height: 18)
          ],
        ),
      ),
      body: userScreens[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryColor,
        items: const [
          // * The number of BottomNavigationBarItems must be equal to the number of Widgets in the screens list
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        elevation: 5.0,
        selectedFontSize: 16.0,
        unselectedFontSize: 12.0,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
