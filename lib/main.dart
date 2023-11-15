import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/gamePlay/game_view.dart';
import 'package:mirrors/views/level/level.dart';
import 'package:mirrors/views/menu/about.dart';
import 'package:mirrors/views/menu/home.dart';
import 'package:mirrors/views/menu/settings.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'home': (context) => const Home(),
        'about': (context) => const About(),
        'settings': (context) => const Settings(),
        'play': (context) => const GameView()
      },
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (BuildContext context) => HomeAssets(),
          child: const Home(),
        ),
      ),
    );
  }
}
