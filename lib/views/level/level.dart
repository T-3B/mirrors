//import 'dart:io';
//import 'package:flutter/services.dart' show rootBundle;

//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:mirrors/game_element/element.dart';

final List<String> LEVEL1 = [
  'WWWWWWWW',
  'WGCCCCGW',
  'WGGCCGGW',
  'WGCCCCGW',
  'WWWWWWWW'
];

/// Assumes the given path is a text-file-asset.
//Future<String> getFileData(String path) async {
  //return await rootBundle.loadString(path);
//}

class LevelView extends StatelessWidget {
  const LevelView(this.levelID, {super.key});
  final int levelID;


  @override
  Widget build(BuildContext context) {
    List<String> lines = LEVEL1; //File('~/assets/levels/$levelID.txt').readAsLinesSync();
    //String data = await getFileData('assets/levels/$levelID.txt');
    final int width = lines[0].length;
    final int height = lines.length;
    return Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: width, childAspectRatio: 1),
          itemCount: width * height,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(width: MediaQuery.of(context).size.width * .1,  // TODO for whatever reason no maxsize is working
              child: switch (lines[index ~/ width][index % width]) {
                'W' => Wall().view,
                'C' => Stack(children: [Ground().view, Coin().view]),
                _ => Ground().view
            });
          })
    );

  }

}