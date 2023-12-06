import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/assets_model.dart';
import 'package:mirrors/models/constant_model.dart';

class HomeAssets extends ChangeNotifier {
  static HomeAssets? _homeAssets;

  List<String>? levelNames;

  var movablePlayerState = <Image>[];
  var ground;
  var face;
  AudioPlayer? mainTheme;

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
    if (ready) {
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
    mainTheme = model.getMainTheme();
    // load ground assets
    ground = model.getGroundImage(Ground.concrete);

    levelNames = await getLevelNames();

    _ready = true;
    _loading = false;
    _updateScreen();
  }

  Future<List<String>> getLevelNames() async {
    List<String> fileNames = [];

    try {
      List<String> assetFiles = await rootBundle
          .loadString('AssetManifest.json')
          .then((String manifestContent) {
        Map<String, dynamic> manifestMap = json.decode(manifestContent);
        return manifestMap.keys
            .where((String key) => key.startsWith('assets/levels/'))
            .toList();
      });

      for (String assetFile in assetFiles) {
        String fileName = assetFile.split('/').last;
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex != -1) {
          fileName = fileName.substring(0, lastDotIndex);
        }
        fileNames.add(fileName);
      }
    } catch (e) {
      print('Error while getting asset file names: $e');
    }

    return fileNames;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
