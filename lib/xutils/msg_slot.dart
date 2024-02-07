import 'package:flutter/material.dart';
import 'package:secchat/xutils/xtext.dart';

class MsgSlot extends StatelessWidget {
  final bool makeRight;
  final String content;
  final makeHighLighted;
  const MsgSlot(
      {Key? key,
      this.makeRight = false,
      required this.content,
      this.makeHighLighted = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          color: makeHighLighted ? Colors.blue : Colors.transparent,
          child: Align(
            alignment: makeRight ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                color: makeRight ? Colors.grey : Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 10, bottom: 10),
              margin: const EdgeInsets.all(3),
              width: MediaQuery.of(context).size.width / 1.5,
              child: XText(
                content: content,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
