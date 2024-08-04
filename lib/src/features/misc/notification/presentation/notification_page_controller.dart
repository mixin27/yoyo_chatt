import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yoyo_chatt/src/shared/utils/onesignal/onesignal.dart';

part 'notification_page_controller.g.dart';

@Riverpod(keepAlive: true)
class PushScubscriptionFlag extends _$PushScubscriptionFlag {
  @override
  FutureOr<bool?> build() {
    return getPushSubsciption();
  }
}
