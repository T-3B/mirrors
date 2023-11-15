import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Player extends ChangeNotifier {
  double x = 600;
  double y = 200;

  void moveLeft() {
    x -= 10;
    print("object " + x.toString() + " " + y.toString());
    notifyListeners();
  }

  void moveRight() {
    x += 10;
    notifyListeners();
  }

  void moveUp() {
    y -= 10;
    notifyListeners();
  }

  void moveDown() {
    y += 10;
    notifyListeners();
  }
}
