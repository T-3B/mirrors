import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';

import '../menu/loading.dart';

class LevelView extends StatefulWidget {
  final LevelDataManager levelDataManager;
  final double elementSize;

  const LevelView({super.key, required this.levelDataManager, required this.elementSize});

  @override
  State createState() => _LevelViewState();
}

class _LevelViewState extends State<LevelView> {
  _LevelViewState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _fetch(), builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Loading();
      } else if (snapshot.hasError) {
        return const Text('Error'); // TODO throw an exception?
      } else { // data was fetched and is ready
        return SizedBox(
          width: widget.elementSize * widget.levelDataManager.width,  // instead of displaying Elements at fixed size, we fixed the size of the whole GridView
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: widget.levelDataManager.width, childAspectRatio: 1),
            itemCount: widget.levelDataManager.width * widget.levelDataManager.height,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => snapshot.data?[widget.levelDataManager.getElementAt(Position(index % widget.levelDataManager.width, index ~/ widget.levelDataManager.width))]
          )
        );
      }
    });
  }

  Future<Map<ElementLevel, dynamic>> _fetch() async => {
    Coin(): await Coin().view,
    Ground(): await Ground().view,
    Wall(): await Wall().view,
  };
}