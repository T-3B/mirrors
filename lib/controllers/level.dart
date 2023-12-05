import 'package:mirrors/models/game_map.dart';
import '../models/element.dart';

class LevelController {
  final Player player;
  final GameMap map;
  final List<Mirror> mirrors;

  LevelController(this.player, this.map, this.mirrors) {
    //player = Player(Position(0,0));
  }

  int _computeMove(Direction direction) => switch(direction) {
    Direction.up => -1,
    Direction.down => 1,
    Direction.left => -2,
    Direction.right => 2,
    Direction.none => 0,
  };

  void movePlayer(Direction direction) {
    // int tmp = _computeMove(direction);
    // int x = (tmp < 0) ? - (tmp % 2) : tmp % 2 ;
    // int y = tmp ~/ 2;
    // switch(map.levelGrid[player.position.x + x][player.position.y + y]) {
    //   case Coin():
    //     map.levelGrid[player.position.x + x][player.position.y + y] = Ground();
    //     player.move(direction);
    //     return;
    //   case Ground():
    //     for(var m in mirrors) {
    //       if(m.position.x == player.position.x + x && m.position.y == player.position.y + y) {
    //         if(map.levelGrid[m.position.x + x][m.position.y + y] == Ground()) {
    //           m.move(direction);
    //           player.move(direction);
    //         }
    //         return;
    //       }
    //     }
    //     player.move(direction);
    //     return;
    //   case Wall():
    //     return;
    // }
    // return;
  }
}
/*
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
        backgroundColor: backgroundColor,
        body: Stack(
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  _levelView,
                  Positioned(top: context.watch<Player>().offset.dy, left: context.watch<Player>().offset.dx, width: elementSize,
                    child: const Image(image: AssetImage('assets/in_game/player_south_static.png'), fit: BoxFit.contain)  // TODO change that to async load (easier when we'll have a Player extending Element)
                  )
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
    context.read<Player>().tryMove(widget.direction);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isHeld) {
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

class LevelDataManager {  // singleton
  static LevelDataManager? _instance;
  late final List<String> _levelRows;
  late final List<List<ElementLevel>> _levelData;  // WARNING: _levelData is encoded as [lineNbr][Row] which is [y][x] (opposite as what we could think) (TODO change? we would need the transpose of that matrix)
  late final Position initialPlayerPosition;
  LevelDataManager._privateConstructor();

  factory LevelDataManager() {
    _instance ??= LevelDataManager._privateConstructor();
    return _instance!;
  }

  Future<void> loadLevelData(int levelID) async {
    initialPlayerPosition = Position(3, 2);  // TODO remove this when LevelController await for loadLevelData
    _levelRows = (await rootBundle.loadString('assets/levels/$levelID.txt')).split('\n');
    _levelData = _parseLevelData();
  }

  ElementLevel getElementAt(Position position) {
    if (_levelData.isEmpty || position.x < 0 || position.y < 0 || position.x >= width || position.y >= height) {
      return Wall(); // Default to ground if out of bounds
    }
    return _levelData[position.y][position.x];
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
}*/