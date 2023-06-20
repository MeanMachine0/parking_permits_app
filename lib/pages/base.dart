import 'package:flutter/material.dart';
import 'package:parking_permits_app/variables.dart';

import '../constants.dart';
import 'home.dart';
import 'settings.dart';

class Base extends StatefulWidget {
  const Base({Key? key}) : super(key: key);

  @override
  BaseState createState() => BaseState();
}

class BaseState extends State<Base> {
  int _selectedIndex = 0;
  static const List<Widget> pages = <Widget>[
    Home(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colours.deepDarkGray,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            if ((!Variables.isLoading && !Variables.isLoading1) |
                Variables.notSilentlySigningIn) {
              _selectedIndex = index;
            }
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
