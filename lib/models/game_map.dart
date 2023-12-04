import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/element.dart';

class GameMap extends ChangeNotifier {
  static GameMap? _map;

  bool isReady = false;

  Position initialPositionPlayer = Position(0, 0, 0, 0);
  int _levelID = 0;

  late List<List<ElementLevel>> levelGrid = [];

  List<Position> initialMirrorsPosition = [];

  factory GameMap(int id) {
    _map = GameMap._privateConstructor(id);
    return _map!;
  }

  GameMap._privateConstructor(int id) {
    if(id != _levelID) {
      _levelID = id;
      _parseLevelData(id);
    }
  }

  Future<void> _parseLevelData(int id) async {
    isReady = false;

    List<String> levelRows = (await rootBundle.loadString('assets/levels/$id.txt')).split('\n');
    
    int initialXPlayer = 0, initialYPlayer = 0;
    int currentRow = 0, currentColumn = 0;
    bool isPlayer = false;

    for(var row in levelRows) {
      levelGrid.add([]);
      currentColumn = 0;
      for(var cell in row.split('')) {
        switch(cell) {
          case 'P':
            isPlayer = true;
            initialYPlayer = currentColumn;
            initialXPlayer = currentRow;
            levelGrid[levelGrid.length - 1].add(Ground());
            break;
          case 'G':
            levelGrid[levelGrid.length - 1].add(Ground());
            break;
          case 'C':
            levelGrid[levelGrid.length - 1].add(Coin());
            break;
          case 'W':
            levelGrid[levelGrid.length - 1].add(Wall());
            break;
          case 'S':
            levelGrid[levelGrid.length - 1].add(LaserStart());
            break;
          case 'E':
            levelGrid[levelGrid.length - 1].add(LaserEnd());
            break;
          case 'M':
            initialMirrorsPosition.add(Position(currentRow, currentColumn, currentRow, currentColumn));
            levelGrid[levelGrid.length - 1].add(Ground());
            break;
        }
        currentColumn++;
      }
      currentRow++;
    }

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