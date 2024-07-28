import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/routes/routes.dart';

class MyApp extends HookConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Yoyo Chatt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Routes
      routerConfig: _appRouter.config(
        navigatorObservers: () => [
          AppRouteObserver(),
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        // reevaluateListenable: ,
      ),
    );
  }
}
