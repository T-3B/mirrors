import 'package:flutter/material.dart';
//import 'package:mirrors/controllers/level.dart';
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
            for(int i = 0; i < 16; i++) {
              grid.add(
                snapshot.data![Wall()]!
              );
            }
            int width = 4;

            //Size size = MediaQuery.of(context).size;

            Player player = Player(Position(map.initialPositionPlayer.x, map.initialPositionPlayer.y, map.levelGrid[0].length, map.levelGrid.length));
              //map.initialPositionPlayer);

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
                        //height: double.infinity,
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
                    child: PlayerView(player: player, length: grid.length, width: width, ),/*Consumer(builder: (context, Player player, _) {
                      LevelController controller = LevelController(levelID, player);
                      return Stack(children: [
                        Positioned(
                          top: (MediaQuery.of(context).size.height / (grid.length / width)) * player.position.y,
                          left: (size.width - ((size.height / (grid.length / width)) * width) - ((size.width / 2) - (((size.height / (grid.length / width)) * width) / 2))) + (MediaQuery.of(context).size.height / (grid.length / width)) * player.position.x,
                          //bottom: 0,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.height / (grid.length / width),
                            height: MediaQuery.of(context).size.height / (grid.length / width),
                            child: Container(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.movePlayer(Direction.up);
                                },
                                child: Text('up'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.movePlayer(Direction.down);
                                },
                                child: Text('down'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.movePlayer(Direction.right);
                                },
                                child: Text('right'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controller.movePlayer(Direction.left);
                                },
                                child: Text('left'),
                              ),
                            ],
                          )
                        )
                      ],);
                    }),*/
                  ),
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
};

/*
class LevelView extends StatefulWidget {
  final LevelDataManager levelDataManager;
  final double elementSize;

  const LevelView({super.key, required this.levelDataManager, required this.elementSize});

  @override
  State createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  _LevelViewState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _fetch(), builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Loading();
      } else if (snapshot.hasError) {
        return const Text('Error'); // TODO throw an exception?
      } else { // data was fetched and is ready
        return SizedBox(
          width: widget.elementSize * widget.levelDataManager.width,  // instead of displaying Elements at fixed size, we fixed the size of the whole GridView
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.levelDataManager.width, childAspectRatio: 1),
            itemCount: widget.levelDataManager.width * widget.levelDataManager.height,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => snapshot.data?[widget.levelDataManager.getElementAt(Position(index % widget.levelDataManager.width, index ~/ widget.levelDataManager.width))]
          )
        );
      }
    });
  }

  Future<Map<ElementLevel, dynamic>> _fetch() async => {
    Coin(): await Coin().view,
    Ground(): await Ground().view,
    Wall(): await Wall().view,
  };
}*/