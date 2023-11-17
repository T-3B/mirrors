import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mirrors/models/global_settings.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/animation/endless_animation.dart';
import 'package:mirrors/views/animation/sprite_animation.dart';
import 'package:mirrors/views/menu/common.dart';
import 'package:mirrors/views/menu/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var defaultButtonStyle = const ButtonStyle(
      iconColor: MaterialStatePropertyAll(Colors.white),
    );

    return Consumer2(builder: (context, HomeAssets homeAssets, GlobalSettings settings, _) {
      if (!homeAssets.ready) {
        return const Loading();
      } else {
        // play music
        if(settings.volume) {
          homeAssets.mainTheme!.resume();
          homeAssets.mainTheme!.setReleaseMode(ReleaseMode.loop);
        } else {
          homeAssets.mainTheme!.stop();
        }

        //MusicPlayer(homeAssets.mainTheme!);

        return Common(
          Stack(
            children: [
              /*Consumer(
                builder: (context, GlobalSettings settings, child) {
                  if(settings.volume) {
                    homeAssets.mainTheme!.resume();
                    homeAssets.mainTheme!.setReleaseMode(ReleaseMode.loop);
                  } else {
                    homeAssets.mainTheme!.stop();
                  }
                },
              ),*/
              Positioned(
                top: 0,
                right: 0,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'settings');
                      },
                      style: defaultButtonStyle,
                      child: Icon(
                        Icons.settings,
                        size: MediaQuery.of(context).size.width / 17,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'about', arguments: {
                          'provider': homeAssets,
                        });
                      },
                      style: defaultButtonStyle,
                      child: Icon(
                        Icons.info,
                        size: MediaQuery.of(context).size.width / 17,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.height / 20,
                  left: MediaQuery.of(context).size.width / 2 -
                      ((MediaQuery.of(context).size.height / 3) / 2),
                  child: SizedBox(
                      width: (MediaQuery.of(context).size.height / 3),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          children: [
                            homeAssets.face,
                            Stack(children: [
                              Text(
                                'Reflector\nQuest',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 5
                                      ..color = Colors.green),
                              ),
                              const Text(
                                'Reflector\nQuest',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              )
                            ]),
                          ],
                        ),
                      ))),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'play');
                      },
                      child: Stack(children: [
                        Text(
                          'PLAY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 50,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 7
                                ..color = Colors.white),
                        ),
                        const Text(
                          'PLAY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.blueAccent,
                          ),
                        )
                      ]),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          width: double.infinity,
                          height: 50,
                          child: MovingPathAnimation(homeAssets.ground,
                              const Duration(milliseconds: 800)),
                        ),
                        Positioned(
                          bottom: 15,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 70,
                            child: SpriteAnimation(
                                homeAssets.movablePlayerState,
                                const Duration(milliseconds: 150)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

/*class MusicPlayer extends StatefulWidget {
  final AudioPlayer player;

  const MusicPlayer(this.player, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MusicPlayerState();
  }
}

class MusicPlayerState extends State<MusicPlayer> with WidgetsBindingObserver {
  late AppLifecycleState appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState = state;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (widget.player.state == PlayerState.playing) {
        widget.player.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (widget.player.state == PlayerState.paused) {
        widget.player.resume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/
