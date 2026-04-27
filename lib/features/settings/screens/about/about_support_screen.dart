import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/package_info_provider.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSupportScreen extends ConsumerWidget {
  const AboutSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About & Support',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 24),
          // Branding Section
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Version $appVersion',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          buildSettingsGroup(
            context,
            showBorder: false,
            children: [
              buildSettingTile(
                context,
                icon: Icons.favorite_border_rounded,
                title: 'Support & donate',
                subtitle: '100% goes to charity',
                iconColor: AppIconColors.pink(context),
                onTap: () {},
                showChevron: false,
              ),
              buildSettingTile(
                context,
                icon: Icons.star_border_rounded,
                title: 'Rate the app',
                subtitle: 'Help others find Easy Tasbeeh',
                iconColor: AppIconColors.amber(context),
                onTap: () {},
                showChevron: false,
              ),
              buildSettingTile(
                context,
                icon: Icons.mail_outline_rounded,
                title: 'Send feedback',
                subtitle: 'Suggest features or report bugs',
                iconColor: AppIconColors.sage(context),
                onTap: () => _launchEmail(context),
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Feedback - ${AppConstants.appName}',
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not find an email app. Please email us at musaddik.dev@gmail.com',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
