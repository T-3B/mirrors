import 'package:flutter/material.dart';
import 'package:mirrors/controllers/player_controller.dart';
import 'package:mirrors/models/player.dart';
import 'package:mirrors/views/gamePlay/overlay_button.dart';
import 'package:mirrors/views/gamePlay/player_view.dart';
import 'package:provider/provider.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Player(),
          ),
        ],
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 251, 103, 103),
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
                PlayerView(context),
                Positioned(
                    bottom: 20, // Adjust the position as needed
                    left: 20, // Adjust the position as needed
                    child:
                        DirectionButtonScreen()), // Contains Positioned widget
                // Other widgets in the Stack
              ],
            )));
  }
}
