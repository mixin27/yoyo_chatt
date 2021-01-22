import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class FullPhotoView extends StatefulWidget {
  FullPhotoView({Key key, @required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  _FullPhotoViewState createState() => _FullPhotoViewState();
}

class _FullPhotoViewState extends State<FullPhotoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(widget.imageUrl),
      ),
    );
  }
}
