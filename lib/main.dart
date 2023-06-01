import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants.dart';
import 'pages/base.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
