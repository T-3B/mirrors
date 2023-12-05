import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
import 'package:mirrors/models/game_map.dart';
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

                  List<MapEntry<Position, ElementLevel>> mirrors = [];

                  mirrors = map.levelMap.entries.where((element) => element.value is Mirror).toList();

                  List<Widget> mirrorsView = [];

                  for(var m in mirrors) {
                    mirrorsView.add(
                      Positioned(
                        top: (MediaQuery.of(context).size.height / height) * m.key.y,
                        left: ((MediaQuery.of(context).size.width - ((MediaQuery.of(context).size.height / height) * width)) / 2) + ((MediaQuery.of(context).size.height / height) * m.key.x),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.height / height,
                          height: MediaQuery.of(context).size.height / height,
                          child: Container(
                            color: Colors.green,
                          ),
                        ),
                      )
                    );
                  }
                  
                  Position playerPosition = map.levelMap.entries.firstWhere((e) => e.value is Player).key;

                  LevelController controller = LevelController(map);

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
                                  Type currentType = current.runtimeType;
                                  if(currentType == Player || currentType == Mirror || currentType == Coin) {
                                    currentType = Ground;
                                  }
                                  return snapshot.data![currentType];
                                },
                              ),
                            ),
                          )
                        ),
                        
                        Positioned(
                          top: (MediaQuery.of(context).size.height / height) * playerPosition.y,
                          left: ((MediaQuery.of(context).size.width - ((MediaQuery.of(context).size.height / height) * width)) / 2) + ((MediaQuery.of(context).size.height / height) * playerPosition.x),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height / height,
                            height: MediaQuery.of(context).size.height / height,
                            child: (snapshot.data![Player])[map.getPlayerFacingAsInt()],
                          ),
                        ),

                        PlayerView(controller: controller, height: height, width: width,),
                      ] + mirrorsView,
                    ),
                  );
                }
              });
        }
      },
    );
  }
}

Future<Map<Type, dynamic>> _fetch() async => {
  Coin: await Coin().view,
  Ground: await Ground().view,
  Wall: await Wall().view,
  Player: await Future.wait(
    List.generate(
      Direction.values.length, 
      (index) async => await Player.getViewFacing(Direction.values[index]),
    ),
  ),
  Mirror: await Ground().view,  // TODO
  LaserStart: await LaserStart(Direction.up).view,
  LaserBeamVertical: await LaserBeamVertical().view,
  LaserBeamHorizontal: await LaserBeamHorizontal().view,
  LaserBeamCross: await LaserBeamCross().view,
  LaserEnd: await LaserEnd().view,
};
