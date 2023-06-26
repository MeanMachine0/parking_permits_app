import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants.dart';
import 'functions.dart';
import 'instances.dart';
import 'pages/base.dart';
import 'variables.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await Instances.initialise();
  await Variables.initialise();
  await Functions.silentSignIn();
  runApp(const ParkingPermitsApp());
}

class ParkingPermitsApp extends StatelessWidget {
  const ParkingPermitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking Permits App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'GB'), Locale('en', 'US')],
      locale: const Locale('en', 'GB'),
      theme: ThemeData(
          colorSchemeSeed: Colours.deepDarkGray,
          brightness: Brightness.dark,
          useMaterial3: true,
          scaffoldBackgroundColor: Colours.deepGray,
          navigationBarTheme:
              const NavigationBarThemeData(indicatorColor: Colors.transparent),
          cardTheme: const CardTheme(
            color: Colours.darkGray,
            elevation: 2,
          ),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colours.deepGray, toolbarHeight: 60),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colours.deepDarkGray),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colours.lightBlue),
          listTileTheme: const ListTileThemeData(tileColor: Colours.darkGray)),
      home: const Base(),
    );
  }
}
