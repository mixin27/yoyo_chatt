import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/shared/utils/onesignal/onesignal.dart';
import 'firebase_options.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  await initOneSignal();

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();

  // * Entry point of the app
  runApp(ProviderScope(
    child: MyApp(),
  ));
  // runApp(ProviderScope(
  //   child: AppStartupWidget(
  //     onLoaded: (context) => MyApp(),
  //   ),
  // ));
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
    // errorLogger.logError(details.exception, details.stack);

    // if (kReleaseMode) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    // }
  };

  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    // errorLogger.logError(error, stack);

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    // if (kReleaseMode) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    // }
    return true;
  };

  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('An error occurred'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Center(
          child: Text(details.toString()),
        ),
      ),
    );
  };
}
