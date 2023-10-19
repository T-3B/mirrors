import 'package:flutter/material.dart';
import 'package:mirrors/controllers/player_controller.dart';

class OverlayButton extends StatelessWidget {
  final PlayerController playerController;
  OverlayButton(this.playerController);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        playerController.moveLeft();
      },
      child: const Text('<'),
    );
  }
}
