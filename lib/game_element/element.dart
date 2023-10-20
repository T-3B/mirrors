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

abstract class Element {
  final AssetsPaths _asset;
  late final List<Image> _images;
  late Widget _view;

  Element(this._asset) {
    _images = _asset.paths.map((e) => Image(image: AssetImage(e), fit: BoxFit.contain)).toList();
    _view = _images.length > 1 ? SpriteAnimation(_images, const Duration(milliseconds: 300)) : _images[0];
  }

  get view => _view;
}

abstract class StackableElement extends Element {
  StackableElement(paths): super(paths) {
    _view = Stack(fit: StackFit.expand, children: [Ground().view, _view]);
  }
}

class Coin extends StackableElement {
  Coin(): super(AssetsPaths.coin);
}

class Ground extends Element {
  Ground(): super(AssetsPaths.ground);
}

class Wall extends Element {
  Wall(): super(AssetsPaths.wall);
}