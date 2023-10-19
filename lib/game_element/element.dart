import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

enum AssetsPaths {  // TODO add class childs (superposable, animated?, rotatable, movable)
  coin(['assets/in_game/coin_1.png', 'assets/in_game/coin_2.png']),
  cursor(['assets/in_game/cursor_action_on_map_1.png', 'assets/in_game/cursor_action_on_map_2.png']),
  ground(['assets/in_game/ground.png']),
  mirror(['assets/in_game/mirror_east_west.png', 'assets/in_game/mirror_south_east.png', 'assets/in_game/mirror_south_north.png', 'assets/in_game/mirror_south_west.png']),
  wall(['assets/in_game/wall.png']);

  const AssetsPaths(this.paths);
  final List paths;
}

abstract class Element {
  final AssetsPaths _asset;
  late final List<Image> _images;

  Element(this._asset) {
    _images = _asset.paths.map((e) => Image(image: AssetImage(e), fit: BoxFit.contain)).toList();
  }

  get view => _images[0];
}

class Wall extends Element {
  Wall(): super(AssetsPaths.wall);
}
class Ground extends Element {
  Ground(): super(AssetsPaths.ground);
}
class Coin extends Element {
  late final _animation;

  Coin(): super(AssetsPaths.coin) {
    _animation = SpriteAnimation(super._images);
  }

  @override
  get view => _animation;
}

class SpriteAnimation extends StatefulWidget {
  final List<Image> _images;

  const SpriteAnimation(this._images, {super.key});

  @override
  State<StatefulWidget> createState() => SpriteAnimationState();
}

class SpriteAnimationState extends State<SpriteAnimation> {
  late Image _sprite;
  int _i = 0;

  SpriteAnimationState();
  @override
  void initState() {
    super.initState();
    _sprite = widget._images[0];
  }
  @override
  Widget build(BuildContext context) {
    _startAnimation();
    return AnimatedSwitcher(
      duration: const Duration(seconds: 0),
      child: _sprite,
    );
  }

  void _startAnimation() {
    Timer(const Duration(milliseconds: 300), () {
      _updateSprite();
    });
  }

  void _updateSprite() {
    setState(() {
      _sprite = widget._images[++_i % widget._images.length];
    });
  }
}