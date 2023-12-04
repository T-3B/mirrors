import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
//import 'package:mirrors/controllers/level.dart';
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
    return Consumer(builder: (context, GameMap map, _) {
      if(!map.isReady) {
        return const Loading();
      } else {
        return FutureBuilder(future: _fetch(), builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return const Scaffold(
              body: Loading(),
            );
          } else if (snapshot.hasError) {
            // TODO: throw error
            return const Text('error');
          } else {
            
            List<Widget> grid = [];
            for(var row in map.levelGrid) {
              for(var cell in row) {
                grid.add(
                  snapshot.data![cell]!
                );
              }
            }
            
            int width = map.levelGrid[0].length;

            Player player = Player(Position(map.initialPositionPlayer.x, map.initialPositionPlayer.y, map.levelGrid.length - 1, map.levelGrid[0].length - 1));

            List<Mirror> mirrors = [];

            for(var m in map.initialMirrorsPosition) {
              mirrors.add(Mirror(Position(m.x, m.y, map.levelGrid.length - 1, map.levelGrid[0].length - 1), 0));
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
                        width: (MediaQuery.of(context).size.height / (grid.length / width)) * width,
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: width,
                            childAspectRatio: 1,
                          ),
                          itemCount: grid.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return grid[index];
                          },
                        ),
                      ),
                    )
                  ),
                  
                  ChangeNotifierProvider(
                    create: (context) => player,
                    child: PlayerView(controller: controller, length: grid.length, width: width,),
                    // child: PlayerView(player: player, length: grid.length, width: width, map: map,),
                  ),

                  MirrorView(controller: controller, length: grid.length, width: width),
                ],
              ),
            );
          }
        });
      }
    },);
  }
}

Future<Map<ElementLevel, Widget>> _fetch() async => {
  Coin(): await Coin().view,
  Ground(): await Ground().view,
  Wall(): await Wall().view,
  LaserStart(): await LaserStart().view,
  LaserEnd(): await LaserEnd().view,
};