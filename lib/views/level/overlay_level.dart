import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
import 'package:provider/provider.dart';

import '../../models/global_settings.dart';

class OverlayLevel extends StatelessWidget {
  final LevelController controller;

  const OverlayLevel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    int coinCount = controller.map.pickedCoins;
    return Stack(children: [
      Positioned(
        top: 0,
        left: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Image(
                image: (coinCount > 0) ? const AssetImage('assets/in_game/coin_1.png') : const AssetImage('assets/in_game/coin_grey.png'),
              ),
            ),
            SizedBox(
              width: 70,
              height: 70,
              child: Image(
                image: (coinCount > 1) ? const AssetImage('assets/in_game/coin_1.png') : const AssetImage('assets/in_game/coin_grey.png'),
              ),
            ),
            SizedBox(
              width: 70,
              height: 70,
              child: Image(
                image: (coinCount > 2) ? const AssetImage('assets/in_game/coin_1.png') : const AssetImage('assets/in_game/coin_grey.png'),
              ),
            ),
          ],
        )
      ),
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
              child: GameButton(icon: const AssetImage('assets/in_game/button_action_rotate_left.png'), tapDownFunction: (_) {
                controller.rotateMirror(RotationDirection.counterclockwise);
              }, controller: controller),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20), 
              child: GameButton( icon: const AssetImage('assets/in_game/button_action.png'), tapDownFunction: (_) {
                controller.changeCursorPosition();
              }, controller: controller)
            ),
            GameButton(icon: const AssetImage('assets/in_game/button_action_rotate_right.png'), tapDownFunction: (_) {
              controller.rotateMirror(RotationDirection.clockwise);
            }, controller: controller),
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
              child: GameButton(icon: const AssetImage('assets/in_game/dpad_button_west.png'), tapDownFunction: (_) {
                controller.movePlayer(Direction.left);
              }, controller: controller),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: GameButton(icon: const AssetImage('assets/in_game/dpad_button_north.png'), tapDownFunction: (_) {
                    controller.movePlayer(Direction.up);
                  }, controller: controller),
                ),
                GameButton(icon: const AssetImage('assets/in_game/dpad_button_south.png'), tapDownFunction: (_) {
                  controller.movePlayer(Direction.down);
                }, controller: controller),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GameButton(icon: const AssetImage('assets/in_game/dpad_button_east.png'), tapDownFunction: (_) {
                controller.movePlayer(Direction.right);
              }, controller: controller),
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
    return Consumer(builder: (context, GlobalSettings gs, _) {
      return FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: Colors.black,
        onPressed: () {
          gs.volume = !gs.volume;
        },
        child: Icon(
          (gs.volume ? Icons.volume_up : Icons.volume_off),
          color: Colors.white,
        ),
      );
    });
  }

}

class HapticsButton extends StatelessWidget {
  const HapticsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GlobalSettings gs, _) {
      return FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: Colors.black,
        onPressed: () {
          gs.vibration = !gs.vibration;
        },
        child: Icon(
          (gs.vibration ? Icons.vibration : Icons.mobile_off),
          color: Colors.white,
        ),
      );
    });
  }

}

class PlayPauseButton extends StatelessWidget {
  final LevelController controller;

  const PlayPauseButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: UniqueKey(),
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

class GameButton extends StatefulWidget {
  final ImageProvider<Object> icon;
  final void Function(TapDownDetails) tapDownFunction;
  final LevelController controller;

  const GameButton({super.key, required this.icon, required this.tapDownFunction, required this.controller});

  @override
  State createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton> {
  late Timer _timer;
  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.controller.isGameFinished()) {
          _isButtonPressed = true;
          widget.tapDownFunction(_);
          _timer = Timer.periodic(const Duration(milliseconds: 325), (timer) {
            if (_isButtonPressed && !widget.controller.isGameFinished()) {
              widget.tapDownFunction(_);
            } else {
              timer.cancel();
            }
          });
        }
      },
      onTapCancel: () {
        if (!widget.controller.isGameFinished()) {
          _timer.cancel();
          _isButtonPressed = false;
        }
      },
      onTapUp: (_) {
        if (!widget.controller.isGameFinished()) {
          _timer.cancel();
          _isButtonPressed = false;
        }
      },
      child: Image(
        image: widget.icon,
        width: 50,
        height: 50,
      ),
    );
  }
}
