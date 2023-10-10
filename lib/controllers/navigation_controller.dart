import 'package:flutter/material.dart';

class NavigationController {
  static NavigationController? _controller;

  NavigationController._privateConstructor();

  factory NavigationController() {
    _controller ??= NavigationController._privateConstructor();
    return _controller!;
  }

  void pushNewPage(BuildContext context, String page) {
    Navigator.pushNamed(context, page);
  }
}