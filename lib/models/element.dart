import 'package:flutter/cupertino.dart';

import '../views/animation/sprite_animation.dart';

enum AssetsPaths {
  coin(['assets/in_game/coin_1.png', 'assets/in_game/coin_2.png']),
  cursor(['assets/in_game/cursor_action_on_map_1.png', 'assets/in_game/cursor_action_on_map_2.png']),
  ground(['assets/in_game/ground.png']),
  laserBeam(['assets/in_game/laser_horizontal_red1.png', 'assets/in_game/laser_horizontal_red2.png']),
  laserStart(['assets/in_game/laser_start_red.png']),
  laserEnd(['assets/in_game/laser_end.png', 'assets/in_game/laser_end_red.png']),
  mirror(['assets/in_game/mirror_east_west.png', 'assets/in_game/mirror_south_east.png', 'assets/in_game/mirror_south_north.png', 'assets/in_game/mirror_south_west.png']),
  wall(['assets/in_game/wall.png']);

  const AssetsPaths(this.paths);
  final List paths;
}

abstract class ElementLevel {
  final AssetsPaths _assetsPaths;  // TODO make Player an Element
  List<Image>? _images;
  Widget? _view;

  ElementLevel(this._assetsPaths);

  Future<Widget> get view async {
    _images ??= _assetsPaths.paths.map((e) => Image(image: AssetImage(e), fit: BoxFit.contain)).toList();
    _view ??= _images!.length > 1 ? SpriteAnimation(_images!, const Duration(milliseconds: 300)) : _images![0];
    return _view!;
  }
}

abstract class StackableElement extends ElementLevel {
  StackableElement(super._assetsPaths);

  @override
  Future<Widget> get view async {
    if (_view == null) {
      super.view;
      _view = Stack(fit: StackFit.expand, children: [await Ground().view, _view!]);
    }
    return _view!;
  }
}

class Coin extends StackableElement {
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