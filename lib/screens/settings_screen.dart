import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              _buildSectionHeader('Game Settings'),
              SwitchListTile(
                title: const Text('Sound Effects'),
                subtitle: const Text('Play sounds on win or lose'),
                value: provider.isSoundEnabled,
                onChanged: (value) => provider.toggleSound(),
                activeColor: Colors.blue.shade800,
              ),
              SwitchListTile(
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Vibrate on tapping and flagging'),
                value: provider.isHapticEnabled,
                onChanged: (value) => provider.toggleHaptic(),
                activeColor: Colors.blue.shade800,
              ),
              ListTile(
                title: const Text('Appearance'),
                subtitle: const Text('Dark, Light, or System'),
                trailing: DropdownButton<ThemeMode>(
                  value: provider.themeMode,
                  onChanged: (ThemeMode? newValue) {
                    if (newValue != null) {
                      provider.setThemeMode(newValue);
                    }
                  },
                  items: ThemeMode.values.map<DropdownMenuItem<ThemeMode>>((ThemeMode mode) {
                    return DropdownMenuItem<ThemeMode>(
                      value: mode,
                      child: Text(mode.name[0].toUpperCase() + mode.name.substring(1)),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              _buildSectionHeader('About'),
              const ListTile(
                title: Text('Version'),
                trailing: Text('1.0.0'),
              ),
              const ListTile(
                title: Text('Developed by'),
                trailing: Text('SAHAN'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
