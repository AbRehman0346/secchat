import 'package:flutter/material.dart';

class XText extends StatelessWidget {
  final String content;
  double? fontSize;
  XText({Key? key, required this.content, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(content, style: TextStyle(fontSize: fontSize));
  }
}
