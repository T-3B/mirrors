import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/element.dart';
import '../views/level/level.dart';

enum Direction { up, down, left, right, none }

class LevelController extends StatefulWidget {
  final int levelID;

  const LevelController({super.key, required this.levelID});

  @override
  State createState() => _LevelControllerState();
}

class _LevelControllerState extends State<LevelController> {
  late final Player _player;
  late final LevelView _levelView;
  late final LevelDataManager _levelDataManager;

  @override
  void initState() {
    super.initState();
    _levelDataManager = LevelDataManager();
  }

  @override
  Widget build(BuildContext context) {
    double elementSize = MediaQuery.of(context).size.width * .09;  // always display Elements at 9% of screen width
    _levelDataManager.loadLevelData(widget.levelID);
    _levelView = LevelView(levelDataManager: _levelDataManager, elementSize: elementSize);
    _player = Player(_levelDataManager, elementSize);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _player,
        ),
      ],
      child: Builder(builder: (context) => Scaffold(
        backgroundColor: primaryDarkColor,
        body: Stack(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  Positioned(top: context.watch<Player>().offset.dy, left: context.watch<Player>().offset.dx, width: elementSize,
                    child: const Image(image: AssetImage('assets/in_game/player_south_static.png'), fit: BoxFit.contain)  // TODO change that to async load (easier when we'll have a Player extending Element)
                  ),
                  _levelView,
                ],
              )
            ),
            Positioned(bottom: 20, left: 20, child: DirectionButtonScreen())
          ]
        )
      ))
    );
  }
}

class DirectionButtonScreen extends StatefulWidget {
  const DirectionButtonScreen({super.key});

  @override
  State createState() => _DirectionButtonScreenState();
}

class _DirectionButtonScreenState extends State<DirectionButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionButton(
                icon: Icon(Icons.arrow_upward),
                  direction: Direction.up
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionButton(
                icon: Icon(Icons.arrow_back),
                  direction: Direction.left
              ),
              SizedBox(width: 50),
              DirectionButton(
                icon: Icon(Icons.arrow_forward),
                  direction: Direction.right
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DirectionButton(
                icon: Icon(Icons.arrow_downward),
                direction: Direction.down
              ),
            ]
          ),
        ],
      ),
    );
  }
}

class DirectionButton extends StatefulWidget {
  final Icon icon;
  final Direction direction;

  const DirectionButton({super.key, required this.icon, required this.direction});

  @override
  State createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<DirectionButton> {
  bool _isHeld = false;

  void _continuousMove() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isHeld) {
        context.read<Player>().tryMove(widget.direction);
        _continuousMove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _isHeld = true;
        _continuousMove();
      },
      onTapUp: (_) {
        _isHeld = false;
      },
      onTapCancel: () {
        _isHeld = false;
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: widget.icon,
      ),
    );
  }
}

class Player extends ChangeNotifier {
  final LevelDataManager _levelDataManager;
  final double _step;  // this is the step between 2 Elements in the LevelView
  late Offset offset;  // Player is placed on the screen using Offset relative to top left
  late Position position;

  Player(this._levelDataManager, this._step) {
    position = _levelDataManager.initialPlayerPosition;
    offset = Offset(position.x * _step, position.y * _step);
  }

  bool tryMove(Direction dir) {  // we move only if possible, and if we moved then return true
    final newPosition = position.translate(dir);

    if (_levelDataManager.getElementAt(newPosition).runtimeType != Wall) {
      _move(dir);
      return true;
    }
    return false;
  }

  void _move(Direction dir) {
    offset = switch (dir) {
      Direction.up => offset.translate(0.0, -_step),
      Direction.down => offset.translate(0.0, _step),
      Direction.left => offset.translate(-_step, 0.0),
      Direction.right => offset.translate(_step, 0.0),
      Direction.none => offset
    };
    position = position.translate(dir);
    notifyListeners();
  }
}

class Position {
  int x, y;
  Position(this.x, this.y);

  Position _translate(int dx, int dy) => Position(x + dx, y + dy);
  Position translate(Direction dir) => switch (dir) {
    Direction.up => _translate(0, -1),
    Direction.down => _translate(0, 1),
    Direction.left => _translate(-1, 0),
    Direction.right => _translate(1, 0),
    Direction.none => this
  };
}

class LevelDataManager {  // singleton
  static LevelDataManager? _instance;
  late final List<String> _levelRows;
  late final List<List<ElementLevel>> _levelData;
  late final Position initialPlayerPosition;
  LevelDataManager._privateConstructor();

  factory LevelDataManager() {
    _instance ??= LevelDataManager._privateConstructor();
    return _instance!;
  }

  Future<void> loadLevelData(int levelID) async {
    initialPlayerPosition = Position(0, 0);  // TODO remove this when LevelController await for loadLevelData
    _levelRows = (await rootBundle.loadString('assets/levels/$levelID.txt')).split('\n');
    _levelData = _parseLevelData();
  }

  ElementLevel getElementAt(Position position) {
    if (_levelData.isEmpty || position.x < 0 || position.y < 0 || position.x >= width || position.y >= height) {
      return Wall(); // Default to ground if out of bounds
    }
    return _levelData[position.x][position.y];
  }

  List<List<ElementLevel>> _parseLevelData() {
    int rowIndex = -1, charIndex;  // will be used to store the initialPlayerPosition
    return _levelRows.map((row) {
      rowIndex++;
      charIndex = -1;
      return row.split('').map((char) {
        charIndex++;
        if (char == 'P') {
          // initialPlayerPosition = Position(rowIndex, charIndex); TODO
        }
        return switch (char) {
          'C' => Coin(),
          'G' => Ground(),
          'P' => Ground(),  // TODO the Player should be an element, easier to instanciate it here (and move the initPlayerPosition here too)
          String() => Wall() // "default" case
        };
      }).toList();
    }).toList();
  }

  int get width => _levelData[0].length;
  int get height => _levelData.length;
}