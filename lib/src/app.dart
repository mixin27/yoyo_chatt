import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'routes/app_router.dart';
import 'routes/app_router_observer.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Yoyo Chatt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
