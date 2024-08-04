import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/onesignal/onesignal.dart';

@RoutePage()
class NotificationPage extends StatefulHookConsumerWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  bool _enabled = true;

  @override
  void initState() {
    final flag = getPushSubsciption();
    setState(() {
      _enabled = flag ?? false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'.hardcoded),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: _enabled,
            onChanged: (newValue) async {
              setState(() {
                _enabled = newValue;
              });
              await disablePush(!newValue);
            },
            title: Text('Push notification'.hardcoded),
            subtitle: Text('Enabled or disabled push notifications'.hardcoded),
          ),
        ],
      ),
    );
  }
}
