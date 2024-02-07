import 'package:flutter/material.dart';

class XTextField extends StatelessWidget {
  final int maxLines;
  final int minLines;
  final String hint;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double fontSize;
  final double contentPadding;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  const XTextField({
    Key? key,
    this.maxLines = 1,
    this.minLines = 1,
    this.hint = "",
    this.borderColor = Colors.blue,
    this.borderWidth = 20,
    this.borderRadius = 0,
    this.fontSize = 20,
    this.contentPadding = 10,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      contentPadding: EdgeInsets.all(contentPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      hintText: hint,
    );

    TextStyle textStyle = TextStyle(fontSize: fontSize);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            autocorrect: autocorrect,
            enableSuggestions: enableSuggestions,
            maxLines: maxLines,
            minLines: minLines,
            decoration: decoration,
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
