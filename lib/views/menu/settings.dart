import 'package:flutter/material.dart';
import 'package:mirrors/views/menu/common_page.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    bool switchBool = false;
    return CommonPage(
      'Settings',
      Expanded(
        child: ListView(
          padding:
              const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Volume'),
                        Text(
                          'Enable/disable sound for all the application',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: switchBool,
                      onChanged: (bool switchBool) {
                        switchBool = !switchBool;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vibration'),
                        Text(
                          'Enable/disable vibrations for all the application',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: switchBool,
                      onChanged: (bool switchBool) {
                        switchBool = !switchBool;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
