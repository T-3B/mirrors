import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/player.dart';

// class DirectionButtonScreen extends StatelessWidget {
//   const OverlayButton(BuildContext context, {super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         context.read<Player>().moveLeft();
//       },
//       child: const Text('<'),
//     );
//   }
// }

class DirectionButtonApp extends StatelessWidget {
  const DirectionButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Direction Button'),
        ),
        body: DirectionButtonScreen(),
      ),
    );
  }
}

class DirectionButtonScreen extends StatefulWidget {
  @override
  _DirectionButtonScreenState createState() => _DirectionButtonScreenState();
}

class _DirectionButtonScreenState extends State<DirectionButtonScreen> {
  bool _isUpPressed = false;
  bool _isDownPressed = false;
  bool _isLeftPressed = false;
  bool _isRightPressed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionButton(
                icon: Icon(Icons.arrow_upward),
                onPressed: () {
                  context.read<Player>().moveUp();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  context.read<Player>().moveLeft();
                },
              ),
              SizedBox(width: 50),
              DirectionButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  context.read<Player>().moveRight();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  context.read<Player>().moveDown();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getCurrentDirection() {
    if (_isUpPressed) {
      return 'UP';
    } else if (_isDownPressed) {
      return 'DOWN';
    } else if (_isLeftPressed) {
      return 'LEFT';
    } else if (_isRightPressed) {
      return 'RIGHT';
    } else {
      return 'NONE';
    }
  }
}

class DirectionButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;

  DirectionButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: icon,
      ),
    );
  }
}
