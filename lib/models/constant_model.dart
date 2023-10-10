enum Player { 
  east1,
  east2,
  eastStatic,
  north1,
  north2,
  northStatic,
  south1,
  south2,
  southStatic,
  west1,
  west2,
  westStatic,
  face,
}

const playerAssets = {
  Player.east1:       'assets/in_game/player_east_1.png',
  Player.east2:       'assets/in_game/player_east_2.png',
  Player.eastStatic:  'assets/in_game/player_east_static.png',
  Player.north1:      'assets/in_game/player_north_1.png',
  Player.north2:      'assets/in_game/player_north_2.png',
  Player.northStatic: 'assets/in_game/player_north_static.png',
  Player.south1:      'assets/in_game/player_south_1.png',
  Player.south2:      'assets/in_game/player_south_2.png',
  Player.southStatic: 'assets/in_game/player_south_static.png',
  Player.west1:       'assets/in_game/player_west_1.png',
  Player.west2:       'assets/in_game/player_west_1.png',
  Player.westStatic:  'assets/in_game/player_west_1.png',
  Player.face:        'assets/icon/playerFace.png',
};

enum Ground { concrete }

const groundAssets = {
  Ground.concrete: 'assets/in_game/ground.png',
};