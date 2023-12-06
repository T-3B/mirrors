import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/element.dart';

class GameMap extends ChangeNotifier {
  static GameMap? _map;

  late Map<Position, ElementLevel> _levelMap;
  Direction playerFacing = Direction.down;
  int width = 0, height = 0;

  Position initialPlayerPosition = Position(1, 1);
  int _levelID = 0;
  bool isReady = false;

  List<Position> initialMirrorsPosition = [];

  Map<Position, ElementLevel> get levelMap => _levelMap;

  set levelMap(Map<Position, ElementLevel> value) {
    _levelMap = value;
    notifyListeners();
  }

  void notifyAllListeners() {
    notifyListeners();
  }

  int getPlayerFacingAsInt() {
    return switch(playerFacing) {
      Direction.up => 0,
      Direction.down => 1,
      Direction.left => 2,
      Direction.right => 3,
      Direction.none => 4,
    };
  }

  factory GameMap(int id) {
    _map = GameMap._privateConstructor(id);
    return _map!;
  }

  GameMap._privateConstructor(int id) {
    _loadLevelData(id);
  }

  // will remove each Position from groundsNonVisited that can be reached from Position `pos`
  void _visitGroundsFrom(List<Position> groundsNonVisited, Position pos) {
    if (groundsNonVisited.remove(pos)) {  // if pos was a non-visited Ground
      for (Direction dir in Direction.values) {
        _visitGroundsFrom(groundsNonVisited, pos.translate(dir));
      }
    }
  }
  // synchronous generator
  Iterable<Position> _getPositionsUntilWall(Map<Position, ElementLevel> grid, Position start, Direction dir) sync* {
    while (grid[start] is! Wall) {
      yield start;
      start = start.translate(dir);
    }
  }
  // return the beam max length (before reaching a Wall) from Position `pos` with repeated translation of Direction `dir`
  List<Position> _getBeamEndPositions(Map<Position, ElementLevel> grid, Position start, Direction dir) {
    var positions = _getPositionsUntilWall(grid, start, dir).toList();
    while (positions.isNotEmpty && grid[positions.last] is! Ground) {
      positions.removeLast();
    }
    if (positions.firstOrNull == start) {
      positions.removeAt(0);  // to have at least a LaserBeam between LaserStart/Mirrors/LaserEnd
    }
    return positions;
  }
  // return true if a path was found, and grid is filled with LaserBeam(), Mirror(), LaserEnd()
  bool _findBeamPath(Map<Position, ElementLevel> grid, Position start, Direction dir, int numMaxBeamLines) {
    var beamEndPositions = _getBeamEndPositions(grid, start, dir).reversed.toList();
    for (final beamEndPos in beamEndPositions) {
      final gridBackup = {};
      for (Position pos = start; pos != beamEndPos; pos = pos.translate(dir)) {
        gridBackup[pos] = grid[pos];
        grid[pos] = dir == Direction.up || dir == Direction.down ? LaserBeamVertical() : LaserBeamHorizontal();
      }

      var groundsPositions = grid.keys.where((e) => grid[e] is Ground).toList();
      _visitGroundsFrom(groundsPositions, groundsPositions.first);
      if (groundsPositions.isEmpty) {  // then we have 0 unreachable zone
        if (numMaxBeamLines <= 1) {  // so this was the last beam line, we had to simply choose a random end and fill with LaserBeam()
          grid[beamEndPos] = LaserEnd();
          groundsPositions = grid.keys.where((e) => grid[e] is Ground).toList();
          _visitGroundsFrom(groundsPositions, groundsPositions.first);
          if (groundsPositions.isEmpty) {
            return true;
          } else {
            grid[beamEndPos] = Ground();
          }
        }
        for (var clockwiseTimes in [1, 3]..shuffle()) {  // try '/' or '\' Mirrors
          grid[beamEndPos] = Mirror(clockwiseTimes);
          final nextDir = (grid[beamEndPos] as Mirror).reflectedDir(dir);
          final isFeasible = _findBeamPath(grid, beamEndPos.translate(nextDir), nextDir, numMaxBeamLines - 1);
          if (isFeasible) {
            return true;
          }
          grid[beamEndPos] = Ground();
        }
      }
      // we didn't find a feasible beam, or we had unreachable zone(s), so restore original grid and try with another beamEndPos
      gridBackup.forEach((key, val) { grid[key] = val; });
    }
    return false;
  }

  void _placeLasersFrom(Map<Position, ElementLevel> grid, Position pos, Direction dir) {
    while (grid[pos] is Ground || grid[pos] is LaserBeamHorizontal || grid[pos] is LaserBeamVertical) {
      grid[pos] = grid[pos] is LaserBeamVertical || grid[pos] is LaserBeamHorizontal ? LaserBeamCross() : (dir == Direction.up || dir == Direction.down ? LaserBeamVertical() : LaserBeamHorizontal());
      pos = pos.translate(dir);
    }
    if (grid[pos] is Mirror) {
      final nextDir = (grid[pos] as Mirror).reflectedDir(dir);
       if (nextDir != Direction.none) {
         _placeLasersFrom(grid, pos.translate(nextDir), nextDir);
       }
    }
  }

  Map<Position, ElementLevel> _generateRandomLevel() {
    final rand = Random();
    height = rand.nextInt(7) + 8;
    width = rand.nextInt(14) + 11;
    final int numFreeBlocks = (width - 2) * (height - 2);  // number of available blocks in the grid (borders are wall)
    final int numAggregatedWalls = numFreeBlocks ~/ 8;  // = nbr of areas (*max*) to fill with X walls
    final int numAggregatedWallsSize = min(width, height) ~/ 3;  // = X walls (*max*) in each area

    // ground everywhere and wall on borders
    final Map<Position, ElementLevel> grid = Map.fromIterable(Iterable.generate(height * width, (i) => Position(i % width, i ~/ width)), value: (e) => e.y == 0 || e.y == height - 1 || e.x == 0 || e.x == width - 1 ? Wall() : Ground());

    // ---------------- place Walls ----------------------------------------------------------------------
    final groundsPositions = grid.keys.where((e) => grid[e] is Ground).toList()..shuffle(rand);
    for (int i = 0; i < numAggregatedWalls; i++) {
      var pos = groundsPositions[0];
      for (int k = 0; k < numAggregatedWallsSize && grid[pos] is! Wall; k++) {
        // add the Wall, then check if level has unreachable areas (if yes remove that last Wall)
        groundsPositions.remove(pos);
        grid[pos] = Wall();
        final groundsNonVisited = List.of(groundsPositions);  // clone
        _visitGroundsFrom(groundsNonVisited, groundsNonVisited.first);
        if (groundsNonVisited.isEmpty) {  // if all areas are reachable
          pos = pos.translate(Direction.values[rand.nextInt(Direction.values.length)]);
        } else {
          grid[pos] = Ground();
          groundsPositions.add(pos);
        }
      }
    }

    // ----------------- LaserStart, Beam, End + Mirrors ------------------------------------------------------
    // while more than half of the map is ground, continue to add laser starts
    exitLaserCreation:
    while (grid.values.whereType<Ground>().length * 4 > grid.length) {
      final laserDirs = [Direction.up, Direction.down, Direction.left, Direction.right];
      laserDirs.shuffle(rand);
      outerLoop:
      for (final dir in laserDirs) { // laser start has a direction (other than none); iterate through all dirs in case one does not have any solution
        final laserStartPosList = grid.keys.where((pos) => grid[pos] is Ground && grid[pos.translate(dir)] is Ground).toList();  // place laser start where there is a ground next to it
        for (final laserStartPos in laserStartPosList..shuffle(rand)) {
          grid[laserStartPos] = LaserStart(dir);  // place the laser start, we are sure it was a Ground before
          final isFeasible = _findBeamPath(grid, laserStartPos.translate(dir), dir, rand.nextInt(3) + 3);  // each laser beam path has between 3 and 3 corners between start and end
          if (isFeasible) {
            break exitLaserCreation;
          } else {
            grid[laserStartPos] = Ground();
          }
        }
      }
      break;
    }

    // remove the lasers from the grid (put a Ground()), so we will rotate randomly mirrors and then re-add the lasers
    grid.entries.where((e) => e.value is LaserBeamCross || e.value is LaserBeamHorizontal || e.value is LaserBeamVertical).forEach((e) { grid[e.key] = Ground(); });

    // rotate mirrors
    grid.values.whereType<Mirror>().forEach((e) { for (var i = rand.nextInt(3) + 1; i != 0; i--) { e.rotate(RotationDirection.clockwise); } });

    //re-add lasers
    final laserStarts = grid.entries.where((e) => e.value is LaserStart);
    for (final e in laserStarts) {
      _placeLasersFrom(grid, e.key.translate((e.value as LaserStart).dir), (e.value as LaserStart).dir);
    }
    
    // get all remaining Grounds, shuffle Positions
    final remainingGrounds = grid.keys.where((e) => grid[e] is Ground).toList()..shuffle(rand);
    // choose random 3 Ground Positions to place Coins
    remainingGrounds.take(3).forEach((e) { grid[e] = Coin(); });
    // place the Player at random Ground Position
    grid[remainingGrounds[3]] = Player();

    return grid;
  }

  Future<void> _loadLevelData(int levelID) async {
    if(levelID <= 0) {
      _levelMap = _generateRandomLevel();
    } else if(_levelID != levelID) {
      _levelMap = _parseLevelRows(const LineSplitter().convert(await rootBundle.loadString('assets/levels/$levelID.txt')));
    } else {
      _levelMap = _generateRandomLevel();
    }
    _levelID = levelID;
    initialPlayerPosition = _levelMap.entries.firstWhere((e) => e.value is Player).key;
    initialMirrorsPosition = _levelMap.entries.where((e) => e.value is Mirror).map((e) => e.key).toList();
    isReady = true;
    notifyListeners();
  }

  Map<Position, ElementLevel> _parseLevelRows(List<String> levelRows) {
    height = levelRows.length;
    width = levelRows[0].length;

    return Map.fromIterable(
      Iterable.generate(
        height * width, 
        (i) => Position((i % width), i ~/ width)
      ), 
      value: (pos) => switch (levelRows[pos.y][pos.x]) {
        'C' => Coin(),
        'E' => LaserEnd(),
        'G' => Ground(),
        'M' => Mirror(Random().nextInt(4)),  // random orientation of the mirror
        'P' => Player(),
        'U' => LaserStart(Direction.up),
        'R' => LaserStart(Direction.right),
        'D' => LaserStart(Direction.down),
        'L' => LaserStart(Direction.left),
        String() => Wall() // "default" case
      }
    );
  }

  @override
  void dispose() {
    
  }
}