import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
import 'package:mirrors/models/game_map.dart';
import 'package:mirrors/views/level/mirror.dart';
import 'package:mirrors/views/level/player.dart';
import 'package:mirrors/views/menu/common.dart';
import 'package:provider/provider.dart';

import '../menu/loading.dart';

class LevelView extends StatelessWidget {
  final int levelID;

  const LevelView({super.key, required this.levelID});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, GameMap map, _) {
        if (!map.isReady) {
          return const Loading();
        } else {
          return FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Loading(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('error'); // TODO: throw error
                } else {
                  int width = map.width;
                  int height = map.height;
                  //int width = map.levelGrid[0].length;

                  Player player = Player(Position(
                      map.initialPlayerPosition.x,
                      map.initialPlayerPosition
                          .y)); //, map.levelGrid.length - 1, map.levelGrid[0].length - 1));

                  List<Mirror> mirrors = [];

                  for (var m in map.initialMirrorsPosition) {
                    mirrors.add(Mirror(Position(m.x, m.y),
                        0)); //, map.levelGrid.length - 1, map.levelGrid[0].length - 1), 0));
                  }

                  LevelController controller = LevelController(player, map, mirrors);

                  return Common(
                    Stack(
                      children: [
                        Positioned(
                            top: 0,
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Center(
                              child: SizedBox(
                                width: (MediaQuery.of(context).size.height / height) * width,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: width,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: height * width,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    ElementLevel current = map.levelMap[Position(index % width, index ~/ width)]!;
                                    return snapshot.data![current.runtimeType];
                                  },
                                ),
                              ),
                            )),

                            ChangeNotifierProvider(
                              create: (context) => player,
                              child: PlayerView(controller: controller, length: height, width: width,),
                            ),

                        //MirrorView(controller: controller, length: height, width: width),
                      ],
                    ),
                  );
                }
              });
        }
      },
    );
  }
}

Future<Map<Type, Widget>> _fetch() async => {
      Coin: await Ground().view,
      Ground: await Ground().view,
      Wall: await Wall().view,
      Player: await Ground().view,
      Mirror: await Ground().view,
      LaserStart: await Ground().view,
      LaserBeamVertical: await Ground().view,
      LaserBeamHorizontal: await Ground().view,
      LaserBeamCross: await Ground().view,
      LaserEnd: await LaserEnd().view,
    };
