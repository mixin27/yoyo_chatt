import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yoyo_chatt/src/features/account/account.dart';
import 'package:yoyo_chatt/src/features/account/profile/presentation/profile/profile_controller.dart';
import 'package:yoyo_chatt/src/routes/routes.dart';
import 'package:yoyo_chatt/src/shared/constants.dart';
import 'package:yoyo_chatt/src/shared/constants/app_sizes.dart';
import 'package:yoyo_chatt/src/shared/extensions/dart_extensions.dart';
import 'package:yoyo_chatt/src/shared/utils/async/async_value_ui.dart';
import 'package:yoyo_chatt/src/shared/utils/utils.dart';

@RoutePage()
class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      profileDataProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final profileState = ref.watch(profileDataProvider);

    return Scaffold(
      // drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: Text('Edit'.hardcoded),
        //   ),
        // ],
      ),
      body: profileState.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('No user data'),
            );
          }

          return ListView(
            children: [
              gapH16,
              Align(
                alignment: Alignment.center,
                child: ProfileAvatarWidget(avatarUrl: user.imageUrl ?? ''),
              ),
              gapH16,
              Align(
                alignment: Alignment.center,
                child: Text(
                  getFullName(user.firstName, user.lastName),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              gapH16,
              ListTile(
                onTap: () => context.router.push(
                  const AccountSettingsRoute(),
                ),
                leading: const Icon(IconlyLight.lock),
                title: Text('Account'.hardcoded),
                subtitle: Text(
                  'Security, email, password and delete account'.hardcoded,
                ),
              ),
              ListTile(
                onTap: () => context.router.push(const NotificationRoute()),
                leading: const Icon(IconlyLight.notification),
                title: Text('Notification'.hardcoded),
                subtitle: Text('Push notification'.hardcoded),
              ),
              ListTile(
                onTap: () => context.router.push(const AboutRoute()),
                leading: const Icon(IconlyLight.info_circle),
                title: Text('About Yoyo Chatt'.hardcoded),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                ),
                child: Divider(),
              ),
              ListTile(
                onTap: () async {
                  if (!await launchUrl(Uri.parse(
                      'https://play.google.com/store/apps/details?id=com.norm.yoyo_chatt'))) {
                    throw Exception('Could not launch.');
                  }
                },
                leading: const Icon(IconlyLight.star),
                title: Text('Rate us'.hardcoded),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                ),
                child: Divider(),
              ),
              AboutListTile(
                icon: const Icon(IconlyLight.document),
                applicationIcon: Image.asset(
                  'assets/images/logo.png',
                  width: 24,
                  height: 24,
                ),
                applicationVersion: 'v2.0.0',
                applicationLegalese:
                    'Copyright © ${DateTime.now().year} KYAW ZAYAR TUN',
                child: Text('License'.hardcoded),
                // child: const Markdown(
                //   data: AppStrings.aboutYoyoChatt,
                // ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                ),
                child: Divider(),
              ),
              ListTile(
                onTap: () => context.router.push(
                  const PrivacyPolicyRoute(),
                ),
                leading: const Icon(IconlyLight.shield_done),
                title: Text('Privacy policy'.hardcoded),
                trailing: IconButton(
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse(
                        'https://www.termsfeed.com/live/c7928b94-c830-4e23-8ef2-ba8cdb09c35f'))) {
                      throw Exception('Could not launch Privacy policy.');
                    }
                  },
                  icon: const Icon(
                    Icons.open_in_new_outlined,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                ),
                child: Divider(),
              ),
              gapH8,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p16,
                ),
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const LogoutTile(),
              // const DangerZoneWidget(),
            ],
          );
        },
        error: (_, error) => const SizedBox(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ProfileAvatarWidget extends StatefulHookConsumerWidget {
  const ProfileAvatarWidget({
    super.key,
    required this.avatarUrl,
  });

  final String avatarUrl;

  @override
  ConsumerState<ProfileAvatarWidget> createState() =>
      _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends ConsumerState<ProfileAvatarWidget> {
  bool _isAttachmentUploading = false;

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _handleImageSelection([
    ImageSource source = ImageSource.gallery,
  ]) async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: source,
    );

    if (result != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
      );

      if (croppedFile != null) {
        _setAttachmentUploading(true);

        final downloadUrl = await ref
            .read(profileControllerProvider.notifier)
            .uploadImage(XFile(croppedFile.path));
        if (downloadUrl == null) {
          _setAttachmentUploading(false);
          return;
        }

        await ref
            .read(profileControllerProvider.notifier)
            .updateProfileAvatar(downloadUrl);

        _setAttachmentUploading(false);
      }
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection(ImageSource.camera);
                },
                leading: const Icon(Icons.camera_outlined),
                title: Text('Camera'.hardcoded),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  _handleImageSelection(ImageSource.gallery);
                },
                leading: const Icon(Icons.image_outlined),
                title: Text('Gallery'.hardcoded),
              ),

              // TextButton(
              //   onPressed: () => Navigator.pop(context),
              //   child: const Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: Text('Cancel'),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            context.router.push(ProfileImageRoute(imageUrl: widget.avatarUrl));
          },
          child: CircleAvatar(
            radius: 54,
            backgroundColor: Colors.grey.shade300,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              // backgroundImage: NetworkImage(widget.avatarUrl),
              child: _isAttachmentUploading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.avatarUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        margin: const EdgeInsets.all(Sizes.p4),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.broken_image_outlined),
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          right: -10,
          bottom: -10,
          child: IconButton(
            onPressed: _handleAttachmentPressed,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            icon: const Icon(Icons.add_a_photo),
          ),
        ),
      ],
    );
  }
}
