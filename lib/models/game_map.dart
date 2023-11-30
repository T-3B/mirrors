import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/element.dart';

class GameMap extends ChangeNotifier {
  static GameMap? _map;

  bool isReady = false;

  Position initialPositionPlayer = Position(0, 0, 0, 0);
  int _levelID = 0;

  late List<List<ElementLevel>> levelGrid;

  factory GameMap(int id) {
    _map ??= GameMap._privateConstructor(id);
    return _map!;
  }

  GameMap._privateConstructor(int id) {
    if(id != _levelID) {
      _levelID = id;
      _parseLevelData(id);
    }
  }

  Future<void> _parseLevelData(int id) async {
    List<String> levelRows = (await rootBundle.loadString('assets/levels/$id.txt')).split('\n');
    
    int initialXPlayer = 0, initialYPlayer = 0;
    int currentRow = 0, currentColumn = 0;
    bool isPlayer = false;

    levelRows.map((row) {
      List<ElementLevel> tmp = [];
      currentColumn = 0;
      row.split('').map((char) {
        switch(char) {
          case 'P': 
            isPlayer = true;
            initialYPlayer = currentColumn;
            initialXPlayer = currentRow;
          case 'G':
            tmp.add(Ground());
            break;
          case 'C':
            tmp.add(Coin());
            break;
          case 'W':
            tmp.add(Wall());
            break;
          default:
            tmp.add(Wall());
        }
        currentColumn++;
      });
      levelGrid.add(tmp);
      currentRow++;
    });
    if(isPlayer) {
      initialPositionPlayer = Position(initialXPlayer, initialYPlayer, currentColumn, currentRow);
    }
    isReady = true;
    notifyListeners();
  }

  @override
  void dispose() {
    
  }
}