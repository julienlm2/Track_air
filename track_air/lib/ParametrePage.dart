import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParametrePage extends StatefulWidget {
  const ParametrePage({super.key});

  @override
  State<ParametrePage> createState() => _ParametrePageState();
}

class _ParametrePageState extends State<ParametrePage> {
  bool _isErgonomicMode = false;
  static const String _ergonomicModeKey = 'ergonomicMode';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isErgonomicMode = prefs.getBool(_ergonomicModeKey) ?? false;
    });
  }

  Future<void> _saveSettings(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ergonomicModeKey, value);
    setState(() {
      _isErgonomicMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Ergonomic Mode'),
              subtitle: const Text('Switch between ergonomic and detailed display'),
              trailing: Switch(
                value: _isErgonomicMode,
                onChanged: _saveSettings,
              ),
            ),
          ],
        ),
      ),
    );
  }
}