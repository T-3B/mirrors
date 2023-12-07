import 'package:flutter/material.dart';

class Common extends StatelessWidget {
  
  final Widget content;

  const Common(this.content, {super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      
      child: content,
    );
  }
}