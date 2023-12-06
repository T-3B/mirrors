import 'package:flutter/material.dart';
import 'package:mirrors/models/game_map.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/level/level.dart';
import 'package:mirrors/views/menu/loading.dart';
import 'package:provider/provider.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, HomeAssets homeAssets, _) {
        if (!homeAssets.ready) {
          return const Loading();
        } else {
          List<String> levelNames = ['random'];
          levelNames.addAll(homeAssets.levelNames!);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Levels'),
              backgroundColor: Colors.red,
            ),
            backgroundColor: Colors.grey,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
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
                      final levelID = (levelNames[index] == 'random')
                          ? -1
                          : int.parse(levelNames[index]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Builder(
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => GameMap(levelID),
                                  child: LevelView(levelID: levelID),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Center(
                              child: Text('Level ${levelNames[index]}'),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      3,
                                      (coinIndex) => Image(
                                            image: (coinIndex < 2)
                                                ? const AssetImage(
                                                    'assets/in_game/coin_1.png')
                                                : const AssetImage(
                                                    'assets/in_game/coin_grey.png'),
                                            width: 30,
                                            height: 30,
                                          )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
