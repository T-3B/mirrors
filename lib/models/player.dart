import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
/*
class Player extends ChangeNotifier {
  late Position position; // player position

  Player({required this.position});

  void move(Direction direction) {
    position.translate(direction);
    notifyListeners();
  }
*/

/*
  final LevelDataManager _levelDataManager;

  final double _step;  // this is the step between 2 Elements in the LevelView
  late Offset offset;  // Player is placed on the screen using Offset relative to top left
  late Position position;

  Player(this._levelDataManager, this._step) {
    position = _levelDataManager.initialPlayerPosition;
    offset = Offset(position.x * _step, position.y * _step);
  }

  bool tryMove(Direction dir) {  // we move only if possible, and if we moved then return true
    final newPosition = position.translate(dir);
    if (_levelDataManager.getElementAt(newPosition).runtimeType != Wall) {
      _move(dir);
      return true;
    }
    return false;
  }

  void _move(Direction dir) {
    offset = switch (dir) {
      Direction.up => offset.translate(0.0, -_step),
      Direction.down => offset.translate(0.0, _step),
      Direction.left => offset.translate(-_step, 0.0),
      Direction.right => offset.translate(_step, 0.0),
      Direction.none => offset
    };
    position = position.translate(dir);
    notifyListeners();
  }
*/
//}