import 'package:flutter/material.dart';

import '../widgets/full_photo.dart';

class FullPhotoScreen extends StatelessWidget {
  FullPhotoScreen({Key key, @required this.title, @required this.photoUrl})
      : super(key: key);
  final String title;
  final String photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title == '' ? Text('Full Photo') : Text(title),
      ),
      body: FullPhotoView(
        imageUrl: photoUrl,
      ),
    );
  }
}
