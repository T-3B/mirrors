import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  @override
  final Key? key;

  const PlayerWidget({this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the appearance of your character using any Flutter widgets.
    return Container(
      width: 50, // Adjust the size as needed
      height: 50, // Adjust the size as needed
      color: Colors.blue, // Adjust the color as needed
    );
  }
}
