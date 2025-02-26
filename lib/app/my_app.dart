import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../views/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dispatch & Incident Reporting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
