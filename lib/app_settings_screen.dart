import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';

class AppSettingsScreen extends StatelessWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
      ),
      body: SafeArea(
        child:ListView(
          children: [
            SettingsGroup(
              title: 'GENERAL',
              children: <Widget>[
                SwitchSettingsTile(
                  settingKey: 'key-simulation',
                  title: 'Simulation',
                  enabledLabel: 'Enabled',
                  disabledLabel: 'Disabled',
                  leading: const Icon(Icons.gps_off),
                  onChange: (value) {
                  },
                ),
              ]
            ),
          SettingsGroup(
              title: 'NAVIGATION',
              children: <Widget>[
                SwitchSettingsTile(
                  settingKey: 'key-north-up',
                  title: 'Navigation',
                  enabledLabel: 'North Up',
                  disabledLabel: 'Track Up',
                  defaultValue: true,
                  leading: const Icon(Icons.navigation),
                  onChange: (value) {
                  },
                ),
              ]
            ),
          ] //
        )
      )
    );
  }
}