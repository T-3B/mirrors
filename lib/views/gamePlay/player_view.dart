import 'package:flutter/material.dart';
import 'package:mirrors/controllers/player_controller.dart';
import 'package:mirrors/models/player.dart';
import 'package:mirrors/views/gamePlay/player_widget.dart';

class PlayerView extends StatefulWidget {
  final Player player;

  const PlayerView(this.player, {Key? key}) : super(key: key);

  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  late PlayerController playerController;
  @override
  void initState() {
    super.initState();
    playerController = PlayerController(widget.player);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.player.x, // Use widget.player.x directly
      top: widget.player.y, // Use widget.player.y directly
      child: const PlayerWidget(), // Display the character
    );
  }
}
