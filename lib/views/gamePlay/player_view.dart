import 'package:flutter/material.dart';
import 'package:mirrors/models/player.dart';
import 'package:mirrors/views/gamePlay/player_widget.dart';

class PlayerView extends StatelessWidget {
  final Player player;

  const PlayerView(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: player.x,
      top: player.y,
      child: const PlayerWidget(), // Create a widget to display your cPlayer
    );
  }
}

// Create separate widgets for virtual buttons in a similar fashion.
