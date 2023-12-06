import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';

class OverlayLevel extends StatelessWidget {
  final LevelController controller;

  const OverlayLevel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
            // right top buttons
      Positioned(
        top: 10,
        right: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PlayPauseButton(controller: controller,),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SoundButton(),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: HapticsButton(),
            ),
          ],
        )
      ),
      // right bottom buttons
      Positioned(
        bottom: 50,
        right: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20), 
              child: GameButton(
                icon: const AssetImage('assets/in_game/button_action_rotate_left.png'), 
                callbackAction: () {
                  controller.rotateMirror(RotationDirection.clockwise);
                }
              ),
            ),
            GameButton(icon: const AssetImage('assets/in_game/button_action_rotate_right.png'), callbackAction: () {
              controller.rotateMirror(RotationDirection.counterclockwise);
            }),
          ],
        ),
      ),
      // left bottom button
      Positioned(
        bottom: 0,
        left: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GameButton(icon: const AssetImage('assets/in_game/dpad_button_west.png'), callbackAction: () {
                controller.movePlayer(Direction.left);
              },),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: GameButton(icon: const AssetImage('assets/in_game/dpad_button_north.png'), callbackAction: () {
                    controller.movePlayer(Direction.up);
                  },),
                ),
                GameButton(icon: const AssetImage('assets/in_game/dpad_button_south.png'), callbackAction: () {
                    controller.movePlayer(Direction.down);
                  },),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GameButton(icon: const AssetImage('assets/in_game/dpad_button_east.png'), callbackAction: () {
                controller.movePlayer(Direction.right);
              },),
            ),
          ],
        ),
      ),
    ],);
  }
}

class SoundButton extends StatelessWidget {
  const SoundButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () {

      },
      child: const Icon(
        Icons.volume_up,
        color: Colors.white,
      ),
    );
  }

}

class HapticsButton extends StatelessWidget {
  const HapticsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () {

      },
      child: const Icon(
        Icons.vibration,
        color: Colors.white,
      ),
    );
  }

}

class PlayPauseButton extends StatelessWidget {
  final LevelController controller;

  const PlayPauseButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () {
        if(controller.isGameRunning) { // test if game is running
          controller.isGameRunning = false;
          _showPausePopup(context);
        } else {
          controller.isGameRunning = true;
        }
      },
      child: Icon(
        controller.isGameRunning ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      ),
    );
  }

  void _showPausePopup(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Paused'),
          content: const Text('Do you want to resume the game?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.isGameRunning = true;
              },
              child: const Text('Resume'),
            ),
            TextButton(
              onPressed: () {
                // quit to main menu
                Navigator.pushReplacementNamed(context, 'home'); // not working correctly
              },
              child: const Text('Quit'),
            ),
          ],
        );
      }
    );
  }

}

class GameButton extends StatelessWidget {
  final AssetImage icon;
  final void Function() callbackAction;

  const GameButton({super.key, required this.icon, required this.callbackAction});
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      onPressed: callbackAction,
      child: Image(
        image: icon,
        width: 50,
        height: 50,
      ),
    );
  }


}