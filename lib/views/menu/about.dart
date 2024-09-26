import 'package:flutter/material.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/menu/common_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    HomeAssets homeAssets = arguments['provider'];
    return CommonPage(
      'About',
      Expanded(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
          children: <Widget>[
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: homeAssets.face,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reflector Quest',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Version 0.1\n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Creators :\n - Louis Paquet Boussard,\n - Clément Smagghe,\n - Emon Dhar',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('''Reflector Quest is a puzzle mobile game that presents players with a series of challenging levels. The game involves navigating a small map filled with lasers, coins, mirrors, and a player-controlled character. The objective is to strategically move mirrors to guide laser beams from a light source to their endpoints. Players must also collect three coins as a side quest. Achievements are earned and displayed on the level selection page upon successfully completing a level.

During gameplay, players face the challenge of avoiding contact with laser beams, which can end the game if the player is hit. Additionally, hitting coins with laser beams results in instant destruction. The goal is to navigate the map, collect coins, and complete the level without being harmed by the laser beams.

Reflector Quest provides the option to play on pre-designed levels or generate random levels using a dynamic level generator. Opting for a randomly generated level ensures a constantly evolving and solvable experience for players, offering new challenges as they progress through the game.'''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
