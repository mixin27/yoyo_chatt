import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:native_id/native_id.dart';

Future<String?> getNativeDeviceId() async {
  try {
    final nativeIdPlugin = NativeId();

    return await nativeIdPlugin.getId();
  } on PlatformException catch (e) {
    debugPrint('Error(native_id): ${e.message}');

    return null;
  }
}
