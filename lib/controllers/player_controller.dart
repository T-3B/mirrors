import 'package:mirrors/models/player.dart';

class PlayerController {
  final Player player;

  PlayerController(this.player);

  void moveLeft() {
    player.moveLeft();
  }

  void moveRight() {
    player.moveRight();
  }

  void moveUp() {
    player.moveUp();
  }

  void moveDown() {
    player.moveDown();
  }
}
