import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mirrors/models/assets_model.dart';
import 'package:mirrors/models/constant_model.dart';

class HomeAssets extends ChangeNotifier {
  static HomeAssets? _homeAssets;

  var movablePlayerState = <Image>[];
  var ground;
  var face;

  bool _loading = true;
  bool _ready = false;

  bool get ready => _ready && !_loading;

  HomeAssets._privateConstructor() {
    _loadAssets();
  }

  factory HomeAssets() {
    _homeAssets ??= HomeAssets._privateConstructor();
    return _homeAssets!;
  }

  void _updateScreen() {
    if(ready) {
      notifyListeners();
    }
  }

  Future<void> _loadAssets() async {
    var fmodel = AssetsModel.get();
    var model = await fmodel;
    // load player assets
    List<Image> playerMap = <Image>[];
    playerMap.insert(0, model.getPlayerImage(Player.east1));
    playerMap.insert(1, model.getPlayerImage(Player.eastStatic));
    playerMap.insert(2, model.getPlayerImage(Player.east2));
    playerMap.insert(3, model.getPlayerImage(Player.eastStatic));
    movablePlayerState = playerMap;
    face = model.getPlayerImage(Player.face);
    // load ground assets
    ground = model.getGroundImage(Ground.concrete);
    _ready = true;
    _loading = false;
    _updateScreen();
  }
}