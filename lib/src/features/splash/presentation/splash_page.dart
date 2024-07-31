import 'package:flutter/material.dart';

import 'package:auto_route/annotations.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SPLASH'),
      ),
    );
  }
}
