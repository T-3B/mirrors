import 'package:flutter/material.dart';

class SpriteAnimation extends StatefulWidget {
  final List<Widget> listSprites;
  final Duration duration;

  const SpriteAnimation(this.listSprites, this.duration, {super.key});

  @override
  State createState() => _SpriteAnimationState();
}

class _SpriteAnimationState extends State<SpriteAnimation> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.listSprites.length;
        });
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.listSprites[_currentIndex];
  }

  @override
  void dispose() {
    super.dispose();
  }
}

