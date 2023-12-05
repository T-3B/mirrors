import 'package:flutter/material.dart';
import 'package:mirrors/models/game_map.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/level/level.dart';
import 'package:mirrors/views/menu/loading.dart';
import 'package:provider/provider.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, HomeAssets homeAssets, _) {
        if(!homeAssets.ready) {
          return const Loading();
        } else {
          List<String> levelNames = [
            'random'
          ];
          levelNames.addAll(homeAssets.levelNames!);
           
          return Scaffold(
            appBar: AppBar(
              title: const Text('Levels'),
              backgroundColor: Colors.red,
            ),
            backgroundColor: Colors.red,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0
                ),
                itemCount: levelNames.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {
                      final levelID = (levelNames[index] == 'random') ? -1 : int.parse(levelNames[index]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:(context) {
                            return Builder(
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => GameMap(levelID),
                                  child: LevelView(levelID: levelID),
                                );
                              }
                            );
                          }
                        )
                      );
                    },
                    child: Card(
                      child: Center(
                        child: Text('Level ${levelNames[index]}'),
                      )
                    )
                  );
                }
              )
            )
          );
        }
      }
    );
  }
}