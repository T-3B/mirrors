import 'package:flutter/material.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/home/about_view.dart';
import 'package:mirrors/views/home/home_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (context) => const HomeView(),
        'about': (context) => const AboutView(),
        'settings': (context) => const AboutView(),
        'play': (context) => const AboutView()
      },
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (BuildContext context) => HomeAssets(),
          child: const HomeView(),
        ),
      ),
    );
  }
}