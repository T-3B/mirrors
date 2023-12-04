import 'package:flutter/material.dart';
import 'package:mirrors/controllers/level.dart';
import 'package:mirrors/models/element.dart';
import 'package:provider/provider.dart';

class MirrorView extends StatelessWidget {
  final int length;
  final int width;
  final LevelController controller;

  const MirrorView({super.key, required this.controller, required this.length, required this.width});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> mirrors = [];
    for(var m in controller.mirrors) {
      mirrors.add(
        ChangeNotifierProvider(
          create: (context) => m,
          child: Consumer(builder: (context, Mirror mirror, _) {
            return Positioned(
              top: (MediaQuery.of(context).size.height / (length / width)) * mirror.position.x,
              left: (size.width - ((size.height / (length / width)) * width) - ((size.width / 2) - (((size.height / (length / width)) * width) / 2))) + (MediaQuery.of(context).size.height / (length / width)) * mirror.position.y,
              child: SizedBox(
                width: MediaQuery.of(context).size.height / (length / width),
                height: MediaQuery.of(context).size.height / (length / width),
                child: Container(
                  color: Colors.green,
                ),
              ),
            );
          },),
        )
      );
    }
    return Stack(children: mirrors,);
  }
}