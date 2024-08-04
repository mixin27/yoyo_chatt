import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';

@RoutePage()
class ProfileImagePage extends StatelessWidget {
  const ProfileImagePage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        foregroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Photo'.hardcoded),
      ),
      body: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) =>
            PhotoView(imageProvider: imageProvider),
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image_outlined),
        ),
      ),
    );
  }
}
