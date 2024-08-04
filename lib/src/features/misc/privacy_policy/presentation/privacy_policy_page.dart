import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yoyo_chatt/src/shared/constants.dart';
import 'package:yoyo_chatt/src/shared/extensions.dart';

@RoutePage()
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy policy'.hardcoded),
      ),
      body: Markdown(
        data: AppStrings.privacyPolicy,
        onTapLink: (text, href, title) async {
          if (href.isNullOrEmpty) return;

          if (!await launchUrl(Uri.parse(href!))) {
            throw Exception('Could not launch $href.');
          }
        },
      ),
    );
  }
}
