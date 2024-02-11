import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:yoyo_chatt/src/shared/utils/utils.dart';

const String onesignalAppId = 'fb7ecbe1-5e62-4cab-bf96-cd7dfea7e23b';

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
