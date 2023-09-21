import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Base extends StatefulWidget {
  const Base({super.key, required Widget page}) : _page = page;

  final Widget _page;

  @override
  BaseState createState() => BaseState();
}

class BaseState extends State<Base> {
  late BannerAd bannerAd;
  bool bannerAdHasLoaded = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) loadBannerAd();
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-7932417226661520/6538405188'
          : 'ca-app-pub-7932417226661520/2424233495',
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
      body: widget._page,
      bottomNavigationBar: bannerAdHasLoaded
          ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
          : null,
    );
  }
}
