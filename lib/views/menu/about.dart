import 'package:flutter/material.dart';
import 'package:mirrors/models/home/home_assets.dart';
import 'package:mirrors/views/menu/common_page.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    HomeAssets homeAssets = arguments['provider'];
    return CommonPage(
      'About',
      Expanded(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
          children: <Widget>[
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: homeAssets.face,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reflector Quest',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Version 0.1\n',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Creators :\n - Louis Paquet Boussard,\n - Clément Smagghe,\n - Emon Dhar',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('''

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eu sollicitudin sem. In sed placerat risus. Curabitur interdum turpis orci, non pellentesque felis hendrerit eget. Nam fringilla risus velit, volutpat consectetur ex sollicitudin id. Donec accumsan mi erat, eget suscipit massa mollis nec. Pellentesque porta sem vitae magna mattis rhoncus. Integer rutrum, neque sed mollis pretium, mauris arcu ornare ex, at imperdiet felis nisi sed est. Pellentesque volutpat vitae tellus vel bibendum. Nunc non massa efficitur, aliquam ex eget, imperdiet leo. Phasellus a erat feugiat, bibendum nibh sed, varius ante. Suspendisse sed libero vitae lorem fringilla molestie. Duis laoreet vulputate est in imperdiet.

In sit amet consectetur arcu. In sollicitudin non sapien nec sodales. Integer purus enim, pulvinar vel tellus ac, vestibulum condimentum sem. Donec pellentesque ex et eros sodales vulputate. Curabitur et velit justo. Aliquam erat volutpat. Phasellus lacus nisi, vestibulum id fringilla rhoncus, ullamcorper eu ipsum. Praesent sodales risus ac dolor pellentesque, eu rutrum nisl pellentesque. Proin pulvinar volutpat tincidunt. Phasellus commodo aliquam diam, quis mattis odio pellentesque a. '''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
