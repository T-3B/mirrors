import 'package:flutter/material.dart';
import 'package:mirrors/models/player.dart';
import 'package:mirrors/views/gamePlay/player_view.dart';

class GameView extends StatelessWidget {
  GameView({super.key});
  final Player player = Player();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: ElevatedButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Game Play'),
          backgroundColor: Color.fromARGB(0, 255, 53, 53),
        ),
        body: Stack(
          children: [
            PlayerView(player), // Contains Positioned widget
            // Other widgets in the Stack
          ],
        ));
  }
}
