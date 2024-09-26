import 'package:mirrors/models/game_map.dart';
import '../models/element.dart';

class LevelController {
  final GameMap map;

  late bool _isGameRunning;

  set isGameRunning(bool value) {
    _isGameRunning = value;
    map.notifyAllListeners();
  }

  bool get isGameRunning {
    return _isGameRunning;
  }

  LevelController(this.map) {
    _isGameRunning = true;
  }

  int _computeMove(Direction direction) => switch(direction) {
    Direction.left => -1,
    Direction.right => 1,
    Direction.up => -2,
    Direction.down => 2,
    Direction.none => 0,
  };
  
  void movePlayer(Direction dir) {
    int tmp = _computeMove(dir);
    int x = (tmp < 0) ? - (tmp % 2) : tmp % 2 ;
    int y = tmp ~/ 2;
    Direction nextDirection = Direction.none;
    if(x == -1) {
      nextDirection = Direction.left;
    } else if(x == 1) {
      nextDirection = Direction.right;
    } else if(y == -1) {
      nextDirection = Direction.up;
    } else if(y == 1) {
      nextDirection = Direction.down;
    }

    if(map.playerFacing != nextDirection) {
      map.playerFacing = nextDirection;
      map.notifyAllListeners();
    } else {
      map.playerFacing = nextDirection;

      Position playerPosition = map.levelMap.entries.firstWhere((e) => e.value is Player).key;

      switch(map.levelMap[Position(playerPosition.x + x, playerPosition.y + y)].runtimeType) {
        case Mirror:
          List<Type> possibleTypes = [Ground, LaserBeamCross, LaserBeamHorizontal, LaserBeamVertical];
          if(possibleTypes.contains(map.levelMap[Position(playerPosition.x + x + x, playerPosition.y + y + y)].runtimeType)) {
            map.levelMap[Position(playerPosition.x + x + x, playerPosition.y + y + y)] = map.levelMap[Position(playerPosition.x + x, playerPosition.y + y)]!;
            map.levelMap[Position(playerPosition.x + x, playerPosition.y + y)] = Player();
            map.levelMap[Position(playerPosition.x, playerPosition.y)] = Ground();
            map.refreshLasers(map.levelMap);
          }
          map.cursorNextPosition;
          map.notifyAllListeners();
          break;
        case Coin:
          map.levelMap[Position(playerPosition.x, playerPosition.y)] = Ground();
          map.levelMap[Position(playerPosition.x + x, playerPosition.y + y)] = Player();
          map.notifyAllListeners();
          map.cursorNextPosition; 
          return;
        case LaserBeamCross:
        case LaserBeamHorizontal:
        case LaserBeamVertical:
          map.levelMap[Position(playerPosition.x, playerPosition.y)] = Ground();
          map.levelMap[Position(playerPosition.x + x, playerPosition.y + y)] = Player();
          map.isLose = true;
          map.cursorNextPosition;
          map.notifyAllListeners();
          return;
        case Ground:
          map.levelMap[Position(playerPosition.x, playerPosition.y)] = Ground();
          map.levelMap[Position(playerPosition.x + x, playerPosition.y + y)] = Player();
          map.refreshLasers(map.levelMap);
          map.cursorNextPosition;
          map.notifyAllListeners();
          return;
        default:
          return;
      }
    }
  }

  void rotateMirror(RotationDirection rotationDirection) {
    Position cursorPosition = map.cursorCurrentPosition;

    if(map.levelMap[cursorPosition] is Mirror) {
      (map.levelMap[cursorPosition] as Mirror).rotate(rotationDirection);
      map.refreshLasers(map.levelMap);
      map.notifyAllListeners();
    }
  }

  void changeCursorPosition() {
    map.cursorNextPosition;
    map.notifyAllListeners();
  }

  bool isGameFinished() => map.isLose || map.isWon;
}
