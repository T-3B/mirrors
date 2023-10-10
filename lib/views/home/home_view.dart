import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mirrors/controllers/navigation_controller.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    NavigationController navigation = NavigationController();

    var backLines = <Widget>[];
    for (var i = 0; i < 4; i++) {
      backLines.insert(
          i * 2,
          CustomPaint(
            size: const Size(double.infinity, 20.0),
            painter: BackgroundLine(color: Colors.blueAccent),
          ));
      backLines.insert(
          i * 2 + 1,
          CustomPaint(
            size: const Size(double.infinity, 20.0),
            painter: BackgroundLine(width: 20.0, color: Colors.black),
          ));
    }

    var defaultButtonStyle = ButtonStyle(
        backgroundColor:
            const MaterialStatePropertyAll<Color>(Colors.blueAccent),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0))));

    return Consumer(builder: (context, HomeAssets homeAssets, _) {
      if(!homeAssets.ready) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Loading'),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              )
            ],
          ),
        );
      } else {
        return Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: <Widget>[
                    Column(children: backLines),
                    Positioned(
                        top: MediaQuery.of(context).size.height / 8,
                        left: (MediaQuery.of(context).size.width / 2) - 75,
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              homeAssets.face,
                              Stack(
                                children: <Widget>[
                                  Text(
                                    'Reflector',
                                    style: TextStyle(
                                      fontSize: 25,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 5
                                        ..color = Colors.green
                                    ),
                                  ),
                                  const Text(
                                    'Reflector',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                children: <Widget>[
                                  Text(
                                    'Quest',
                                    style: TextStyle(
                                      fontSize: 25,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 5
                                        ..color = Colors.green
                                    ),
                                  ),
                                  const Text(
                                    'Quest',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: (MediaQuery.of(context).size.height / 15),
                                  top: 40
                                ),
                                width: double.infinity,
                                height: 50,
                                child: _MovingPathAnimation(homeAssets.ground),
                              ),
                              Positioned(
                                bottom: (MediaQuery.of(context).size.height / 15 + 15),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  width: 70,
                                  child: _AnimatedPlayer(homeAssets.movablePlayerState),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: defaultButtonStyle,
                                    onPressed: () => navigation.pushNewPage(context, 'settings'),
                                    child: const Icon(Icons.settings)),
                                ElevatedButton(
                                    style: defaultButtonStyle,
                                    onPressed: () => navigation.pushNewPage(context, 'about'),
                                    child: const Icon(Icons.info))
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: defaultButtonStyle,
                                  onPressed: () => navigation.pushNewPage(context, 'play'),
                                  child: const Text('PLAY'))),
                        ],
                      ),
                    ),
                  ],
                ));
      }
    });
  }
}

class BackgroundLine extends CustomPainter {
  final double angle;
  final double width;
  final Color color;

  BackgroundLine(
      {this.angle = 30, this.width = 10.0, this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        Path()
          ..moveTo(0.0, size.height)
          ..lineTo(size.width, size.width * tan(angle * (pi / 180.0))),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AnimatedPlayer extends StatefulWidget {
  final List<Image> _movablePlayerState;
  const _AnimatedPlayer(this._movablePlayerState);
  @override
  State<StatefulWidget> createState() => _AnimatedPlayerState();
}

class _AnimatedPlayerState extends State<_AnimatedPlayer> {
  late Image _sprite;
  int _i = 0;
  @override
  void initState() {
    super.initState();
    _sprite = widget._movablePlayerState[0];
  }
  @override
  Widget build(BuildContext context) {
    _startAnimation();
    return AnimatedSwitcher(
      duration: const Duration(seconds: 0),
      child: _sprite,
    );
  }

  void _startAnimation() {
    Timer(const Duration(milliseconds: 150), () {
      _updateSprite();
    });
  }

  void _updateSprite() {
    setState(() {
      _i = (_i >= 3) ? 0 : _i + 1;
      _sprite = widget._movablePlayerState[_i];
    });
  }
}

class _MovingPathAnimation extends StatefulWidget {
  final Image _ground;
  const _MovingPathAnimation(this._ground);

  @override
  _MovingPathAnimationState createState() => _MovingPathAnimationState();
}

class _MovingPathAnimationState extends State<_MovingPathAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
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
        double containerPosition = position - (_controller.value * 100.0); // with container
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
    for(double i = 0.0; i < MediaQuery.of(context).size.width + 100; i += 50.0) {
      ground.insert(index++, _buildMovingContainer(i));
    }

    return Stack(
      children: ground,
    );
  }
}

