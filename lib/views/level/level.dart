import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirrors/models/element.dart';

import '../menu/loading.dart';

class LevelView extends StatelessWidget {
  const LevelView(this.levelID, {super.key});
  final int levelID;

  @override
  Widget build(BuildContext context) {
    final double itemSize = MediaQuery.of(context).size.width * .09; // always display Elements at 9% of screen width

    return FutureBuilder(future: _fetch(), builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Loading();
      } else if (snapshot.hasError) {
        return const Text('Error'); // TODO throw an exception?
      } else { // data was fetched and is ready
        final List<String> levelData = snapshot.data?['levelData'].split('\n'); // store each line separately
        final int width = levelData[0].length;
        final int height = levelData.length;
        return Scaffold(
          body: Center(
            child: SizedBox(
              width: itemSize * width,  // instead of displaying Elements at fixed size, we fixed the size of the whole GridView
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: width, childAspectRatio: 1),
                itemCount: width * height,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) => snapshot.data?[levelData[index ~/ width][index % width]] // get Element.view using char
              )
            )
          )
        );
      }
    });
  }

  Future<Map<String, dynamic>> _fetch() async => {
    'C': await Coin().view,
    'G': await Ground().view,
    'W': await Wall().view,
    'levelData': await rootBundle.loadString('assets/levels/$levelID.txt')
  };
}