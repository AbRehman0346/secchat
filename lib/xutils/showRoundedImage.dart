import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:secchat/services/firebase_storage_services.dart';
import '../constants/AppConstants.dart';

class ShowRoundedImage extends StatelessWidget {
  final double radius;
  final String imageURL;
  final bool setSelected;

  const ShowRoundedImage({
    Key? key,
    required this.radius,
    required this.imageURL,
    this.setSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseStorageServices().getImage(imageURL),
      builder: (context, AsyncSnapshot snapshot) {
        return CircleAvatar(
          radius: radius,
          child: Stack(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl: snapshot.data ?? "",
                  placeholder: (context, s) {
                    return Image.asset(
                      AppContent.profilePlaceHolder,
                      fit: BoxFit.cover,
                    );
                  },
                  errorWidget: (context, s, d) {
                    return Image.asset(
                      AppContent.profilePlaceHolder,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              setSelected
                  ? const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
