import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/element.dart';

class GameMap extends ChangeNotifier {
  static GameMap? _map;


  late Map<Position, ElementLevel> levelMap;
  Position initialPlayerPosition = Position(1, 1);
  int _levelID = 0;
  bool isReady = false;

  List<Position> initialMirrorsPosition = [];

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

  Iterable<Direction> _neighborGrounds(Map<Position, ElementLevel> grid, Position start, bool vertical) {
    final allowedDirs = vertical ? {Direction.up, Direction.down} : {Direction.left, Direction.right};
    return Direction.values.where((dir) => allowedDirs.contains(dir) && grid[start.translate(dir)] is Ground);
  }
  // synchronous generator
  Iterable<Position> _getPositionsUntilWall(Map<Position, ElementLevel> grid, Position start, Direction dir) sync* {
    while (grid[start] is! Wall) {
      yield start;
      start = start.translate(dir);
    }
  }
  // return the beam max length (before reaching a Wall) from Position `pos` with repeated translation of Direction `dir`
  // if isLastBeam is true, then
  List<Position> _getBeamEndPositions(Map<Position, ElementLevel> grid, Position start, Direction dir, bool isLastBeam) {
    var positions = _getPositionsUntilWall(grid, start, dir).toList();
    positions = positions.takeWhile((val) => positions.lastWhere((e) => grid[e] is Ground) != val).toList();
    // positions contains now all Positions from start to last ground before Wall

    if (!isLastBeam) {
      positions = positions.where((e) => _neighborGrounds(grid, start, dir == Direction.up || dir == Direction.down).isNotEmpty).toList();
    }
    return positions;
  }
  // return true if a path was found, and grid is filled with LaserBeam(), Mirror(), LaserEnd()
  bool _findBeamPath(Map<Position, ElementLevel> grid, Position start, Direction dir, int numMaxBeamLines) {
    var beamEndPositions = _getBeamEndPositions(grid, start, dir, numMaxBeamLines > 1);
    final nextDir = switch (dir) {
      Direction.up => [Direction.right, Direction.left][Random().nextInt(2)],
      Direction.down => [Direction.right, Direction.left][Random().nextInt(2)],
      Direction.left => [Direction.up, Direction.down][Random().nextInt(2)],
      Direction.right => [Direction.up, Direction.down][Random().nextInt(2)],
      Direction.none => Direction.up,
    };
    for (final beamEndPos in beamEndPositions..shuffle(Random())) {
      final gridBackup = {};
      for (Position pos = start; pos != beamEndPos; pos = pos.translate(dir)) {
        gridBackup[pos] = grid[pos];
        grid[pos] = dir == Direction.up || dir == Direction.down ? LaserBeamVertical() : LaserBeamHorizontal();
      }
      if (numMaxBeamLines <= 1) {  // so this was the last beam line, we had to simply choose a random end and fill with LaserBeam()
        grid[beamEndPos] = LaserEnd();
        return true;
      }
      final isFeasible = _findBeamPath(grid, start, nextDir, numMaxBeamLines - 1);
      if (isFeasible) {
        grid[beamEndPos] = Mirror.fromDirections(beamEndPos, dir, nextDir);
        return true;
      } else {
        // we didn't find a feasible beam, so restore original grid
        gridBackup.forEach((key, val) { grid[key] = val; });
      }
    }
    return false;
  }

  Map<Position, ElementLevel> _generateRandomLevel() {
    final rand = Random();
    final height = rand.nextInt(9) + 6;
    final width = rand.nextInt(19) + 6;
    final int numFreeBlocks = (width - 2) * (height - 2);  // number of available blocks in the grid (borders are wall)
    final int numAggregatedWalls = numFreeBlocks ~/ 8;  // = nbr of areas (*max*) to fill with X walls
    final int numAggregatedWallsSize = min(width, height) ~/ 3;  // = X walls (*max*) in each area

    // ground everywhere and wall on borders
    final Map<Position, ElementLevel> grid = Map.fromIterable(Iterable.generate(height * width, (i) => Position(i % width, i ~/ width)), value: (e) => e.y == 0 || e.y == height - 1 || e.x == 0 || e.x == width - 1 ? Wall() : Ground());

    // place Walls
    final groundsPosition = grid.keys.where((e) => grid[e] is Ground).toList();

    for (int i = 0; i < numAggregatedWalls; i++) {
      var pos = groundsPosition[rand.nextInt(groundsPosition.length)];
      for (int k = 0; k < numAggregatedWallsSize && grid[pos] is! Wall; k++) {
        // add the Wall, then check if level has unreachable areas (if yes remove that last Wall)
        grid[pos] = Wall();
        final groundsNonVisited = List.of(groundsPosition);  // clone
        _visitGroundsFrom(groundsNonVisited, groundsNonVisited.first);
        if (groundsNonVisited.isEmpty) {  // if all areas are reachable
          groundsPosition.remove(pos);
          pos = pos.translate(Direction.values[rand.nextInt(Direction.values.length)]);
        } else {
          grid[pos] = Ground();
        }
      }
    }

    // while more than half of the map is ground, continue to add laser starts
    while (grid.values.whereType<Ground>().length * 4 > grid.length) {
      final laserDirs = [Direction.up, Direction.down, Direction.left, Direction.right];
      laserDirs.shuffle(rand);
      outerLoop:
      for (final dir in laserDirs) { // laser start has a direction (other than none); iterate through all dirs in case one does not have any solution
        final laserStartPosList = grid.keys.where((pos) => grid[pos] is Ground && grid[pos.translate(dir)] is Ground).toList();  // place laser start where there is a ground next to it
        for (final laserStartPos in laserStartPosList..shuffle(rand)) {
          grid[laserStartPos] = LaserStart(dir);  // place the laser start, we are sure it was a Ground before
          final isFeasible = _findBeamPath(grid, laserStartPos.translate(dir), dir, rand.nextInt(3) + 1);  // each laser beam path has between 1 and 3 corners between start and end
          if (isFeasible) {
            break outerLoop;
          } else {
            grid[laserStartPos] = Ground();
          }
        }
      }
    }

    // TODO move the mirrors (remember to remove also the beams)
    // TODO put the player

    return grid;
  }

  Future<void> _loadLevelData(int levelID) async {
    if (_levelID <= 0) {
      levelMap = _generateRandomLevel();
    } else if (_levelID != levelID) {
      levelMap = _parseLevelRows((await rootBundle.loadString('assets/levels/$levelID.txt')).split('\n'));
    }
    _levelID = levelID;
    initialPlayerPosition = levelMap.entries.firstWhere((e) => e.value is Player).key;
    isReady = true;
    notifyListeners();
  }

  Map<Position, ElementLevel> _parseLevelRows(List<String> levelRows) {
    final height = levelRows.length, width = levelRows[0].length;
    return Map.fromIterable(Iterable.generate(height * width, (i) => Position(i % width, i ~/ width)), value: (pos) => switch (levelRows[pos.y][pos.x]) {
      'C' => Coin(),
      'E' => LaserEnd(),
      'G' => Ground(),
      'M' => Mirror(pos, Random().nextInt(4) * pi / 4),  // random orientation of the mirror
      'P' => Player(pos),
      'U' => LaserStart(Direction.up),
      'R' => LaserStart(Direction.right),
      'D' => LaserStart(Direction.down),
      'L' => LaserStart(Direction.left),
      String() => Wall() // "default" case
    });
  }

  @override
  void dispose() {
    
  }
}