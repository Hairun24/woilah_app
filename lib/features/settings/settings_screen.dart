import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/settings_service.dart';
import '../source_manager/source_manager_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Tema'),
            subtitle: Text('Light / Dark / Sistem'),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Sistem'),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) settings.setThemeMode(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Terang'),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) settings.setThemeMode(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Gelap'),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) settings.setThemeMode(value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Notifikasi'),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              settings.setNotificationsEnabled(value);
            },
          ),
          SwitchListTile(
            title: const Text('Konten dewasa'),
            value: settings.adultContentEnabled,
            onChanged: (value) {
              settings.setAdultContentEnabled(value);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Kelola source extension'),
            subtitle: const Text('Tambah, aktifkan, atau hapus source'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SourceManagerScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
