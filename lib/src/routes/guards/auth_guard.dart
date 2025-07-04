import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:yoyo_chatt/src/features/auth/data/auth_repository.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authRepository = AuthRepository(
      FirebaseAuth.instance,
      // FirebaseFirestore.instance,
    );

    final user = authRepository.currentUser;
    final isLoggedIn = user != null;

    if (isLoggedIn) {
      resolver.next(true);
    } else {
      // router.replaceAll([EmailPasswordSignInRoute()]);
      resolver.redirectUntil(
        EmailPasswordSignInRoute(
          onSignedIn: (success) {
            resolver.next(success);
          },
        ),
      );
    }
  }
}
