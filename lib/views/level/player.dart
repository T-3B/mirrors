import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
// import 'package:mirrors/models/game_map.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  final int height;
  final int width;
  final LevelController controller;

  const PlayerView({super.key, required this.controller, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    return Stack(children: [
      /*Consumer(builder: (context, Player player, _) {
        int playerPosition = levelMap.entries.firstWhere((e) => e.value is Player).key
        return Positioned(
          top: (MediaQuery.of(context).size.height / height) * player.position.y,
          // top: (MediaQuery.of(context).size.height / (length / width)) * player.position.x,
          left: ((MediaQuery.of(context).size.width - ((MediaQuery.of(context).size.height / height) * width)) / 2) + ((MediaQuery.of(context).size.height / height) * player.position.x),
          // left: (size.width - ((size.height / (length / width)) * width) - ((size.width / 2) - (((size.height / (length / width)) * width) / 2))) + (MediaQuery.of(context).size.height / (length / width)) * player.position.y,
          child: SizedBox(
            width: MediaQuery.of(context).size.height / height,
            height: MediaQuery.of(context).size.height / height,
            // width: MediaQuery.of(context).size.height / (length / width),
            // height: MediaQuery.of(context).size.height / (length / width),
            child: Container(
              color: Colors.blue,
            ),
          ),
        );
      }),*/
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
  }

}