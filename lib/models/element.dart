import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../views/animation/sprite_animation.dart';

enum AssetsPaths {
  coin(['assets/in_game/coin_1.png', 'assets/in_game/coin_2.png']),
  cursor(['assets/in_game/cursor_action_on_map_1.png', 'assets/in_game/cursor_action_on_map_2.png']),
  ground(['assets/in_game/ground.png']),
  laserBeamVertical(['assets/in_game/laser_vertical_red1.png', 'assets/in_game/laser_vertical_red2.png']),
  laserStart(['assets/in_game/laser_start_red.png']),
  laserEnd(['assets/in_game/laser_end.png', 'assets/in_game/laser_end_red.png']),
  mirror(['assets/in_game/mirror_east_west.png', 'assets/in_game/mirror_south_east.png', 'assets/in_game/mirror_south_north.png', 'assets/in_game/mirror_south_west.png']),
  wall(['assets/in_game/wall.png']),
  player(['assets/in_game/player_east_1.png', 'assets/in_game/player_east_2.png','assets/in_game/player_east_static.png',
  'assets/in_game/player_north_1.png', 'assets/in_game/player_north_2.png','assets/in_game/player_north_static.png',
  'assets/in_game/player_south_1.png', 'assets/in_game/player_south_2.png','assets/in_game/player_south_static.png',
  'assets/in_game/player_west_1.png', 'assets/in_game/player_west_2.png','assets/in_game/player_west_static.png',],);

  const AssetsPaths(this.paths);
  final List paths;
}
enum Direction { up, down, left, right, none }
enum RotationDirection{ clockwise, counterclockwise }

class Position {
  int x, y;
  Position(this.x, this.y);

  @override
  bool operator ==(Object other) => other is Position && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  Position _translate(int dx, int dy) => Position(x + dx, y + dy);
  Position translate(Direction dir) => switch (dir) {
    Direction.up => _translate(0, -1),
    Direction.down => _translate(0, 1),
    Direction.left => _translate(-1, 0),
    Direction.right => _translate(1, 0),
    Direction.none => this
  };
}


abstract class ElementLevel {
  final AssetsPaths _assetsPaths;
  List<Image>? _images;
  Widget? _view;

  ElementLevel(this._assetsPaths);

  Future<Widget> get view async {
    _images ??= _assetsPaths.paths.map((e) => Image(image: AssetImage(e), fit: BoxFit.contain)).toList();
    _view ??= _images!.length > 1 ? SpriteAnimation(_images!, const Duration(milliseconds: 300)) : _images![0];
    return _view!;
  }
}

abstract class MovableElement extends ElementLevel with ChangeNotifier {
  Position position;

  MovableElement(super._assetsPaths, this.position);

  void move(Direction dir) {
    position = position.translate(dir);
    notifyListeners();
  }
}

class Mirror extends MovableElement  {
  late double angle;
  Mirror(Position position, this.angle) : super(AssetsPaths.mirror, position);
  Mirror.fromDirections(Position position, Direction dir1, Direction dir2) : super(AssetsPaths.mirror, position) {
    double dir2Angle(Direction dir) => switch (dir) {
      Direction.up => pi / 2,
      Direction.down => 3 * pi / 2,
      Direction.left => pi,
      _ => 0,
    };

    angle = dir2Angle(dir1) + dir2Angle(dir2) / 2;
  }

  void rotate(RotationDirection rot) {
    switch (rot) {
      case RotationDirection.clockwise:
        angle += pi / 4;
      case RotationDirection.counterclockwise:
        angle -= pi / 4;
    }
    notifyListeners();
  }
}

class Player extends MovableElement {
  Player._privateConstructor(Position p): super(AssetsPaths.player, p);

  static Player? _instance;

  factory Player(Position p) {
    _instance ??= Player._privateConstructor(p);
    return _instance!;
  }

  @override
  void move(Direction dir) {  // TODO set Player sprite when moving (or perhaps in PlayerView?)
    position = position.translate(dir);
    notifyListeners();
  }

  @override
  void dispose() {

  }
}

class Coin extends ElementLevel {
  Coin._privateConstructor(): super(AssetsPaths.coin);

  static Coin? _instance;

  factory Coin() {
    _instance ??= Coin._privateConstructor();
    return _instance!;
  }
}

class Ground extends ElementLevel {
  Ground._privateConstructor(): super(AssetsPaths.ground);

  static Ground? _instance;

  factory Ground() {
    _instance ??= Ground._privateConstructor();
    return _instance!;
  }
}

class Wall extends ElementLevel {
  Wall._privateConstructor(): super(AssetsPaths.wall);

  static Wall? _instance;

  factory Wall() {
    _instance ??= Wall._privateConstructor();
    return _instance!;
  }
}

class LaserStart extends ElementLevel {
  final Direction dir;

  LaserStart(this.dir) : super(AssetsPaths.laserStart);
}

class LaserBeamVertical extends ElementLevel {
  LaserBeamVertical._privateConstructor(): super(AssetsPaths.laserEnd);

  static LaserBeamVertical? _instance;

  factory LaserBeamVertical() {
    _instance ??= LaserBeamVertical._privateConstructor();
    return _instance!;
  }
}

class LaserBeamHorizontal extends ElementLevel {
  LaserBeamHorizontal._privateConstructor(): super(AssetsPaths.laserEnd);

  static LaserBeamHorizontal? _instance;

  factory LaserBeamHorizontal() {
    _instance ??= LaserBeamHorizontal._privateConstructor();
    return _instance!;
  }

  @override
  Future<Widget> get view async => Transform.rotate(angle: pi / 2, child: await LaserBeamVertical().view);
}

class LaserBeamCross extends ElementLevel {  // intersection of 2 beams (1 vertical + 1 horizontal)
  LaserBeamCross._privateConstructor(): super(AssetsPaths.laserEnd);

  static LaserBeamCross? _instance;

  factory LaserBeamCross() {
    _instance ??= LaserBeamCross._privateConstructor();
    return _instance!;
  }

  @override
  Future<Widget> get view async => Stack(fit: StackFit.expand, children: [await LaserBeamVertical().view, await LaserBeamHorizontal().view]);
}

class LaserEnd extends ElementLevel {
  LaserEnd._privateConstructor(): super(AssetsPaths.laserEnd);

  static LaserEnd? _instance;

  factory LaserEnd() {
    _instance ??= LaserEnd._privateConstructor();
    return _instance!;
  }
}