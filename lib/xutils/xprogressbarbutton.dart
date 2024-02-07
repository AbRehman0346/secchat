import 'package:flutter/material.dart';

class XProgressBarButton extends StatelessWidget {
  final bool loadingValue;
  final String buttonText;
  final double fontSize;
  final Color textColor;
  final Function? onPressed;
  const XProgressBarButton({
    Key? key,
    required this.loadingValue,
    required this.buttonText,
    required this.onPressed,
    this.fontSize = 25,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 50,
      decoration: BoxDecoration(
        color: onPressed == null ? Colors.grey : Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: loadingValue
          ? Center(
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 5,
                  bottom: 5,
                ),
                child: const CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            )
          : InkWell(
              onTap: () {
                try {
                  onPressed!();
                } catch (e) {}
              },
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
              ),
            ),
    );
  }
}
