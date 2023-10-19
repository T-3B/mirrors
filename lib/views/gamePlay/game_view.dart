import 'package:flutter/material.dart';
import 'package:mirrors/controllers/player_controller.dart';
import 'package:mirrors/models/player.dart';
import 'package:mirrors/views/gamePlay/overlay_button.dart';
import 'package:mirrors/views/gamePlay/player_view.dart';

class GameView extends StatelessWidget {
  final Player player;
  final PlayerController playerController;

  GameView({Key? key})
      : player = Player(),
        playerController = PlayerController(Player()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 13, 13, 13),
        appBar: AppBar(
          leading: ElevatedButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Game Play'),
          backgroundColor: Color.fromARGB(0, 255, 53, 53),
        ),
        body: Stack(
          children: <Widget>[
            PlayerView(player),
            Positioned(
                bottom: 20, // Adjust the position as needed
                left: 20, // Adjust the position as needed
                child: OverlayButton(
                    playerController)), // Contains Positioned widget
            // Other widgets in the Stack
          ],
        ));
  }
}
