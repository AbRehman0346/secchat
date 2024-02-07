import 'package:flutter/material.dart';
import 'package:secchat/xutils/showRoundedImage.dart';
import '../constants/AppConstants.dart';

class ChatRow extends StatelessWidget {
  final String name;
  final String email;
  final Function onTap;
  Function? onLongPress;
  final bool setSelected;
  ChatRow({
    Key? key,
    required this.name,
    required this.email,
    required this.onTap,
    this.onLongPress,
    this.setSelected = false,
  }) : super(key: key);

  double cardWidthAndHeight = 60;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      onLongPress: () {
        onLongPress!();
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          height: cardWidthAndHeight,
          child: Row(
            children: [
              const SizedBox(width: 5),
              ShowRoundedImage(
                radius: 24,
                imageURL:
                    "${AppContent.firebaseProfileImageFolderName}${AppContent.formatEmail(email)}",
                setSelected: setSelected,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(email),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
