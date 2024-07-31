import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:yoyo_chatt/src/shared/utils/utils.dart';

// TODO(mixin27): replace with actual onesignal app id.
const String onesignalAppId = '';

Future<void> initOneSignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(onesignalAppId);

  OneSignal.Notifications.requestPermission(true);

  final deviceId = await getNativeDeviceId();
  if (deviceId != null) {
    await OneSignal.login(deviceId);
  }

  OneSignal.InAppMessages.addTrigger('current_build_number', '2');
}

Future<void> disablePush([bool disable = true]) async {
  if (disable) {
    OneSignal.User.pushSubscription.optOut();
  } else {
    OneSignal.User.pushSubscription.optIn();
  }
}
