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
            icon: Icons.info_outline_rounded,
            title: 'About Easy Tasbeeh',
            subtitle: 'Version, team, and mission',
            iconColor: AppIconColors.gray(context),
            onTap: () {},
          ),
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
            icon: Icons.code_rounded,
            title: 'View source on GitHub',
            subtitle: 'MIT licensed — free & open',
            iconColor: AppIconColors.blue(context),
            onTap: () => _launchUrl('https://github.com'),
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
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.policy_outlined,
            title: 'Privacy policy',
            subtitle: 'No data collected, ever',
            iconColor: AppIconColors.green(context),
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.article_outlined,
            title: 'Licenses',
            subtitle: 'Open source acknowledgements',
            iconColor: AppIconColors.gray(context),
            onTap: () => showLicensePage(context: context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
