import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  late BannerAd bannerAd;
  bool bannerAdHasLoaded = false;
  int _selectedIndex = 0;
  static const List<Widget> pages = <Widget>[
    Home(),
    Settings(),
  ];

  @override
  void initState() {
    super.initState();
    loadBannerAd();
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7932417226661520/6538405188',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          log('Banner ad loaded', time: DateTime.now());
          setState(() {
            bannerAdHasLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          log('Banner ad failed to load: $error', time: DateTime.now());
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
  }

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
