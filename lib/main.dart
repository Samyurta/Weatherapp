import 'package:flutter/material.dart';
import 'package:myapp/helpscreen.dart';
import 'package:myapp/homepagescreen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HelpScreen(),
        '/homepage': (context) => HomepageScreen(),
      },
    );
  }
}