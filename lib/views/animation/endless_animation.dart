import 'package:flutter/material.dart';

class MovingPathAnimation extends StatefulWidget {
  final Image _ground;
  final Duration duration;
  const MovingPathAnimation(this._ground, this.duration, {super.key});

  @override
  MovingPathAnimationState createState() => MovingPathAnimationState();
}

class MovingPathAnimationState extends State<MovingPathAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMovingContainer(double position) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double containerPosition =
            position - (_controller.value * 100.0); // with container
        if (containerPosition < -200.0) {
          containerPosition += 800.0; // total width path
        }
        return Positioned(
          left: containerPosition,
          child: Container(
            width: 50.0,
            color: Colors.blue,
            child: widget._ground,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ground = [];
    int index = 0;
    for (double i = 0.0;
        i < MediaQuery.of(context).size.width + 100;
        i += 50.0) {
      ground.insert(index++, _buildMovingContainer(i));
    }

    return Stack(
      children: ground,
    );
  }
}
