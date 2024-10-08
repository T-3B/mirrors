import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mirrors/models/constant_model.dart';

class AssetsModel {
  static AssetsModel? _model;

  static bool _first = true;
  static final List<Completer<void>> _locks = <Completer<void>>[];

  static Map<Player, Image>? _playerImage;
  static Map<Ground, Image>? _groundImage;
  static List<AudioPlayer>? _music;

  AssetsModel._privateConstructor(
      Map<Player, Image> p, Map<Ground, Image> g, List<AudioPlayer> m) {
    _playerImage = p;
    _groundImage = g;
    _music = m;
  }

  static Future<AssetsModel> get() async {
    if (_model == null && _first) {
      _first = false;
      var p = await _loadCharacterAssets();
      var g = await _loadGroundAssets();
      var m = [await _loadSound()];
      _model = AssetsModel._privateConstructor(p, g, m);
      for (var lock in _locks) {
        lock.complete();
      }
    } else {
      var lock = Completer<void>();
      _locks.add(lock);
      await lock.future;
    }
    return _model!;
  }

  static Future<Image> _loadAssetImage(String path) async {
    return Image(image: AssetImage(path));
  }

  static Future<Map<Player, Image>> _loadCharacterAssets() async {
    var playerImageMap = <Player, Image>{};
    for (var key in playerAssets.keys) {
      var img = _loadAssetImage(playerAssets[key]!);
      playerImageMap[key] = await img;
    }
    return playerImageMap;
  }

  static Future<Map<Ground, Image>> _loadGroundAssets() async {
    var groundImageMap = <Ground, Image>{};
    for (var key in groundAssets.keys) {
      var img = _loadAssetImage(groundAssets[key]!);
      groundImageMap[key] = await img;
    }
    return groundImageMap;
  }

  static Future<AudioPlayer> _loadSound() async {
    var player = AudioPlayer();
    await player.setSource(AssetSource('music/mainTheme.mp3'));
    return player;
  }

  Image getPlayerImage(Player p) {
    return _playerImage![p]!;
  }

  Image getGroundImage(Ground g) {
    return _groundImage![g]!;
  }

  AudioPlayer getMainTheme() {
    return _music![0];
  }
}
