import 'package:easy_tasweeh/core/constants/app_constants.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSupportScreen extends StatelessWidget {
  const AboutSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About & Support',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),
          buildSettingTile(
            context,
            icon: Icons.favorite_border_rounded,
            title: 'Support & donate',
            subtitle: '100% goes to charity',
            iconColor: AppIconColors.pink(context),
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.star_border_rounded,
            title: 'Rate the app',
            subtitle: 'Help others find Easy Tasbeeh',
            iconColor: AppIconColors.amber(context),
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.mail_outline_rounded,
            title: 'Send feedback',
            subtitle: 'Suggest features or report bugs',
            iconColor: AppIconColors.teal(context),
            onTap: () => _launchEmail(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
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
      // Fallback: try launching without canLaunchUrl check,
      // as it sometimes fails on Android even if it works.
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
