import 'package:flutter/material.dart';
import 'package:mirrors/models/game_map.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/level/level.dart';
import 'package:mirrors/views/menu/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelSelection extends StatelessWidget {
  const LevelSelection({super.key,});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, HomeAssets homeAssets, _) {
        if (!homeAssets.ready) {
          return const Loading();
        } else {
          List<String> levelNames = ['random'];
          levelNames.addAll(homeAssets.levelNames!);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Levels'),
              backgroundColor: Colors.red,
            ),
            backgroundColor: Colors.grey,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: levelNames.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {
                      final levelID = (levelNames[index] == 'random')
                          ? -1
                          : int.parse(levelNames[index]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Builder(
                              builder: (context) {
                                return ChangeNotifierProvider(
                                  create: (context) => GameMap(levelID),
                                  child: LevelView(levelID: levelID),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      borderOnForeground: false,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/in_game/level_selector_bg.png'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Stack(
                            children: [
                              Center(child: Text('Level ${levelNames[index]}'),),
                              (levelNames[index] == 'random') ? Container() :
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    
                                    children: List.generate(3, (coinIndex) => FutureBuilder(
                                      future: _loadCoinSave(int.parse(levelNames[index])),
                                      builder: (context, snapshot) {
                                        if(snapshot.connectionState != ConnectionState.waiting) {
                                          return Image(
                                            image: (coinIndex < (snapshot.data ?? 0)) ? const AssetImage('assets/in_game/coin_1.png') : const AssetImage('assets/in_game/coin_grey.png'),
                                            width: 35,
                                            height: 35,
                                          );
                                        }
                                        return Container();
                                      }
                                    ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }


  Future<int> _loadCoinSave(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numberOfCoin = 0;
    numberOfCoin = prefs.getInt('levelCoin$id') ?? 0;
    return numberOfCoin;
  }
}


