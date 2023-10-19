import 'package:flutter/material.dart';
import 'package:mirrors/views/menu/common.dart';

class CommonPage extends StatelessWidget {
  final Widget content;
  final String titlePage;
  const CommonPage(this.titlePage, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        shadowColor: Colors.transparent,
        title: Text(titlePage),
      ),
      body: Common(
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                content,
              ],
            )
          ],
        ),
      ),
    );
  }
}
