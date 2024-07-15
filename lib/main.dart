import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'src/app_bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // create an app bootstrap instance
  final appBootstrap = AppBootstrap();

  // * uncomment this to connect to the Firebase emulators
  // await appBootstrap.setupEmulators();

  // create a container configured with all the required instances
  final container = await appBootstrap.createProviderContainer();

  // use the container above to create the root widget
  final root = appBootstrap.createRootWidget(container: container);

  // start the app
  runApp(root);
}
