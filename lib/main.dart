import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'res/strings.dart';
import 'route_generator.dart';
import 'screens/preferences_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interpretari App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PreferenceScreen(),
      initialRoute: ROUTE_SPLASH,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
