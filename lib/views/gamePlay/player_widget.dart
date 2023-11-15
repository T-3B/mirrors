import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/player.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player>(context);

    print("position changed");
    return Container(
      width: 50,
      height: 50,
      color: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
