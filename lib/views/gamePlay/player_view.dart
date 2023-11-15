import 'package:flutter/material.dart';
import 'package:mirrors/models/player.dart';
import 'package:mirrors/views/gamePlay/player_widget.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: context.watch<Player>().x,
      top: context.watch<Player>().y,
      child: const PlayerWidget(),
    );
  }
}
