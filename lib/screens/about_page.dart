import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ms_music_player/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'About',
            isBackButtonVisible: true,
            onBackButtonPressed: () => Get.back(),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildAppHeader(),
                _buildSectionTitle('Developer'),
                _buildDeveloperInfo(),
                _buildSectionTitle('Social Media'),
                _buildSocialMediaLinks(),
                _buildSectionTitle('App Info'),
                _buildAppInfo(),
                _buildLicenseInfo(),
                _buildSectionTitle('Legal'),
                _buildLicenseInfo(),
                _buildCopyrightInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(Icons.music_note,
              size: 80, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 10),
          Text(
            'MS Music Player',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'A modern and feature-rich music player for Windows 11. Enjoy your local music library and explore new tunes with playlists, streaming, and more. Built with Flutter.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDeveloperInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Developed by'),
        subtitle: const Text('marufsharia '),
      ),
    );
  }

  Widget _buildSocialMediaLinks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildSocialMediaLinkTile(
            icon: Icons.web,
            name: 'Website',
            url: 'https://yourwebsite.com/marufsharia',
            themeProvider: Theme.of(context),
          ),
          _buildSocialMediaLinkTile(
            icon: Icons.facebook,
            name: 'Facebook',
            url: 'https://www.facebook.com/marufsharia',
            themeProvider: Theme.of(context),
          ),
          _buildSocialMediaLinkTile(
            icon: Icons.android,
            name: 'GitHub',
            url: 'https://github.com/marufsharia',
            themeProvider: Theme.of(context),
          ),
          _buildSocialMediaLinkTile(
            icon: Icons.logo_dev,
            name: 'LinkedIn',
            url: 'https://www.linkedin.com/in/marufsharia',
            themeProvider: Theme.of(context),
          ),
          _buildSocialMediaLinkTile(
            icon: Icons.camera_alt,
            name: 'Instagram',
            url: 'https://www.instagram.com/marufsharia',
            themeProvider: Theme.of(context),
          ),
          _buildSocialMediaLinkTile(
            icon: Icons.alternate_email,
            name: 'Twitter (X)',
            url: 'https://twitter.com/marufsharia',
            themeProvider: Theme.of(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaLinkTile({
    required IconData icon,
    required String name,
    required String url,
    required themeProvider,
  }) {
    return ListTile(
      leading: Icon(icon, color: themeProvider.colorScheme.primary),
      title: Text(name),
      trailing: Icon(Icons.open_in_new,
          color: themeProvider.iconTheme.color?.withOpacity(0.6)),
      onTap: () => _launchURL(url),
    );
  }

  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: Text(_packageInfo.version),
          ),
          ListTile(
            leading: const Icon(Icons.build),
            title: const Text('Build Number'),
            subtitle: Text(_packageInfo.buildNumber),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseInfo() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        leading: Icon(Icons.description_outlined),
        title: Text('License'),
        subtitle: Text('MIT License (Replace with your actual license)'),
      ),
    );
  }

  Widget _buildCopyrightInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        'Copyright © ${DateTime.now().year} marufsharia. All Rights Reserved.',
        textAlign: TextAlign.center,
        style: TextStyle(
            color:
                Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6)),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
