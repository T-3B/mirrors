import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
import 'package:mirrors/models/game_map.dart';
import 'package:mirrors/views/animation/sprite_animation.dart';
import 'package:mirrors/views/level/overlay_level.dart';
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

                double sizeOneCell = min(MediaQuery.of(context).size.height / height, MediaQuery.of(context).size.width / width);

                for (var m in mirrors) {
                  mirrorsView.add(Positioned(
                    top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * m.key.y),
                    left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * m.key.x),
                    child: SizedBox(
                        width: sizeOneCell,
                        height: sizeOneCell,
                        child: Transform.rotate(
                          angle: (m.value as Mirror).angle,
                          child: snapshot.data![Mirror][(m.value as Mirror).isLaserTouching ? 0 : 1]
                        )),
                  ));
                }

                List<Widget> coinView = [];

                for (var c in map.levelMap.entries.where((element) => element.value is Coin)) {
                  coinView.add(Positioned(
                    top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) /2) + (sizeOneCell * c.key.y),
                    left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * c.key.x),
                    child: SizedBox(
                      width: sizeOneCell,
                      height: sizeOneCell,
                      child: snapshot.data![Coin],
                    ),
                  ));
                }

                List<Widget> laserBeamCrossView = [];

                for (var c in map.levelMap.entries.where((element) => element.value is LaserBeamCross)) {
                  coinView.add(Positioned(
                    top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * c.key.y),
                    left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * c.key.x),
                    child: SizedBox(
                      width: sizeOneCell,
                      height: sizeOneCell,
                      child: snapshot.data![LaserBeamCross],
                    ),
                  ));
                }

                List<Widget> laserBeamVerticalView = [];

                for (var c in map.levelMap.entries.where((element) => element.value is LaserBeamVertical)) {
                  coinView.add(Positioned(
                    top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * c.key.y),
                    left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * c.key.x),
                    child: SizedBox(
                      width: sizeOneCell,
                      height: sizeOneCell,
                      child: snapshot.data![LaserBeamVertical],
                    ),
                  ));
                }

                List<Widget> laserBeamHorizontalView = [];

                for (var c in map.levelMap.entries.where((element) => element.value is LaserBeamHorizontal)) {
                  coinView.add(Positioned(
                    top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * c.key.y),
                    left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * c.key.x),
                    child: SizedBox(
                      width: sizeOneCell,
                      height: sizeOneCell,
                      child: snapshot.data![LaserBeamHorizontal],
                    ),
                  ));
                }

                List<Widget> laserEndView = [];

                for (var c in map.levelMap.entries.where((element) => element.value is LaserEnd)) {
                  coinView.add(Positioned(
                    top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * c.key.y),
                    left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * c.key.x),
                    child: SizedBox(
                      width: sizeOneCell,
                      height: sizeOneCell,
                      child: snapshot.data![LaserEnd],
                    ),
                  ));
                }

                // Position endPosition = map.levelMap.entries.firstWhere((e) => e.value is LaserEnd).key;

                Position playerPosition = map.levelMap.entries.firstWhere((e) => e.value is Player).key;

                Position cursorPosition = switch (map.playerFacing) {
                  Direction.up => Position(playerPosition.x, playerPosition.y - 1),
                  Direction.down => Position(playerPosition.x, playerPosition.y + 1),
                  Direction.left => Position(playerPosition.x - 1, playerPosition.y),
                  Direction.right => Position(playerPosition.x + 1, playerPosition.y),
                  Direction.none => Position(playerPosition.x, playerPosition.y),
                };

                LevelController controller = LevelController(map);

                return Common(
                  Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: sizeOneCell * width,
                            height: sizeOneCell * height,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: width, childAspectRatio: 1),
                              itemCount: height * width,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                ElementLevel current = map.levelMap[Position(index % width, index ~/ width)]!;
                                Type currentType = current.runtimeType;
                                List<Type> mustBeGround = [Player, Mirror, Coin, LaserEnd, LaserBeamCross, LaserBeamHorizontal, LaserBeamVertical];
                                if (mustBeGround.contains(currentType)) {
                                  currentType = Ground;
                                }
                                return snapshot.data![currentType];
                              },
                            ),
                          ),
                        )),
                      Positioned(
                        top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * playerPosition.y),
                        left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * playerPosition.x),
                        child: SizedBox(
                          width: sizeOneCell,
                          height: sizeOneCell,
                          child: (snapshot.data![Player])[map.getPlayerFacingAsInt()],
                        ),
                      ),
                      Positioned(
                          top: ((MediaQuery.of(context).size.height - (sizeOneCell * height)) / 2) + (sizeOneCell * cursorPosition.y),
                          left: ((MediaQuery.of(context).size.width - (sizeOneCell * width)) / 2) + (sizeOneCell * cursorPosition.x),
                          child: SizedBox(
                            width: sizeOneCell,
                            height: sizeOneCell,
                            child: const SpriteAnimation([  // TODO async load by extending Element
                              Image(image: AssetImage('assets/in_game/cursor_action_on_map_2.png')),
                              Image(image: AssetImage('assets/in_game/cursor_action_on_map_1.png')),
                            ], Duration(milliseconds: 300)),
                          )),
                      // Positioned(
                      //   top: ((MediaQuery.of(context).size.height -
                      //               (sizeOneCell * height)) /
                      //           2) +
                      //       (sizeOneCell * endPosition.y),
                      //   left: ((MediaQuery.of(context).size.width -
                      //               (sizeOneCell * width)) /
                      //           2) +
                      //       (sizeOneCell * endPosition.x),
                      //   child: SizedBox(
                      //     width: sizeOneCell,
                      //     height: sizeOneCell,
                      //     child: snapshot.data![LaserEnd],
                      //   ),
                      // ),
                    ] + mirrorsView + coinView + laserBeamHorizontalView + laserBeamVerticalView +
                        laserBeamCrossView + laserEndView + <Widget>[OverlayLevel(controller: controller)]
                  ),
                );
              }
            }
          );
        }
      },
    );
  }
}

Future<Map<Type, dynamic>> _fetch() async => {
      Coin: await Coin().view,
      Ground: await Ground().view,
      Wall: await Wall().view,
      Player: await Direction.values
          .map((e) async => await Player.getViewFacing(e))
          .wait,
      Mirror: [
        await Mirror.getViewFacing(true),
        await Mirror.getViewFacing(false)
      ],
      LaserStart: await LaserStart(Direction.up).view,
      LaserBeamVertical: await LaserBeamVertical().view,
      LaserBeamHorizontal: await LaserBeamHorizontal().view,
      LaserBeamCross: await LaserBeamCross().view,
      LaserEnd: await LaserEnd().view,
    };
