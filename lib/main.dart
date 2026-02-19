
import 'package:flutter/material.dart';
import 'package:terangapay/src/ui/routes/route.dart';
import 'package:terangapay/src/ui/routes/route_path.dart';


// Gradient global

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routers.generateRoute,
      initialRoute: splash,

    );
  }
}