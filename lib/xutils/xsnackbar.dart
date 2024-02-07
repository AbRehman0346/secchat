import 'package:flutter/material.dart';

class XSnackBar {
  XSnackBar(BuildContext context, String msg, {Color color = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
    ));
  }
}
