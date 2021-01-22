import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../widgets/full_photo.dart';

class FullPhotoScreen extends StatelessWidget {
  FullPhotoScreen({Key key, @required this.photoUrl}) : super(key: key);
  final String photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile Image'),
      ),
      body: FullPhotoView(
        imageUrl: photoUrl,
      ),
    );
  }
}
