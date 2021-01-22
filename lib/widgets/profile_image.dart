import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImage extends StatelessWidget {
  ProfileImage({Key key, @required this.imgUrl, this.handleImageTap}) : super(key: key);
  final imgUrl;

  final Function handleImageTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleImageTap(imgUrl),
      child: Material(
        borderRadius: BorderRadius.circular(45.0),
        clipBehavior: Clip.hardEdge,
        child: Container(
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            placeholder: (ctx, url) => Container(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
              width: 90.0,
              height: 90.0,
              padding: EdgeInsets.all(20.0),
            ),
            width: 90.0,
            height: 90.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
