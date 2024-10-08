import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/global_settings.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/menu/about.dart';
import 'package:mirrors/views/menu/home.dart';
import 'package:mirrors/views/menu/level_selection.dart';
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
    return ChangeNotifierProvider(
      create: (context) => GlobalSettings(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'home': (context) => ChangeNotifierProvider(
            create: (context) => HomeAssets(),
            child: const Scaffold(body: Home()),
          ),
          'about': (context) => const About(),
          'settings': (context) => const Settings(),
          'play': (context) => ChangeNotifierProvider(
                create: (context) => HomeAssets(),
                child: const LevelSelection(),
              ),
        },
        home: Scaffold(
          body: ChangeNotifierProvider(
            create: (context) => HomeAssets(),
            child: const Home(),
          ),
        ),
      ),
    );
  }
}
