import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  final Player player;
  final int length;
  final int width;

  const PlayerView({super.key, required this.player, required this.length, required this.width});

  @override
  Widget build(BuildContext context) {
    LevelController controller = LevelController(player);
    Size size = MediaQuery.of(context).size;
    return Stack(children: [
      Consumer(builder: (context, Player player, _) {
        print('t2');
        return Positioned(
          top: (MediaQuery.of(context).size.height / (length / width)) * player.position.y,
          left: (size.width - ((size.height / (length / width)) * width) - ((size.width / 2) - (((size.height / (length / width)) * width) / 2))) + (MediaQuery.of(context).size.height / (length / width)) * player.position.x,
          //bottom: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.height / (length / width),
            height: MediaQuery.of(context).size.height / (length / width),
            child: Container(
              color: Colors.blue,
            ),
          ),
        );
      }),
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