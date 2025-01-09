import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PresetFormPage extends StatefulWidget {
  const PresetFormPage({super.key});

  @override
  State<PresetFormPage> createState() => _PresetFormPageState();
}

class _PresetFormPageState extends State<PresetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _presetNameController = TextEditingController();
  final List<TextEditingController> _magazineControllers = [];
  static const int maxMagazines = 10;

  @override
  void initState() {
    super.initState();
    _addMagazineField();
  }

  void _addMagazineField() {
    if (_magazineControllers.length < maxMagazines) {
      setState(() {
        _magazineControllers.add(TextEditingController());
      });
    }
  }

  void _removeMagazineField(int index) {
    setState(() {
      _magazineControllers[index].dispose();
      _magazineControllers.removeAt(index);
    });
  }

  Future<void> _savePreset() async {
    if (_formKey.currentState!.validate()) {
      final parameters = <String, String>{};
      for (var i = 0; i < _magazineControllers.length; i++) {
        parameters['Magazine${i + 1}'] = _magazineControllers[i].text;
      }

      final preset = {
        "presetName": _presetNameController.text,
        "createdAt": DateTime.now().toUtc().toIso8601String(),
        "parameters": parameters
      };

      try {
        // Get the application documents directory
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/presets.json');
        
        Map<String, dynamic> jsonContent;
        if (await file.exists()) {
          final content = await file.readAsString();
          jsonContent = json.decode(content);
          jsonContent['presets'].add(preset);
        } else {
          jsonContent = {
            "presets": [preset]
          };
        }

        await file.writeAsString(json.encode(jsonContent));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preset saved successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving preset: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Preset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _presetNameController,
                decoration: const InputDecoration(
                  labelText: 'Preset Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a preset name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Magazines (${_magazineControllers.length}/$maxMagazines)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ..._buildMagazineFields(),
              const SizedBox(height: 16),
              if (_magazineControllers.length < maxMagazines)
                ElevatedButton.icon(
                  onPressed: _addMagazineField,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Magazine'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _magazineControllers.isNotEmpty ? _savePreset : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save Preset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMagazineFields() {
    return List.generate(_magazineControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _magazineControllers[index],
                decoration: InputDecoration(
                  labelText: 'Magazine ${index + 1} Capacity',
                  border: const OutlineInputBorder(),
                  suffixText: 'rounds',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0 || number > 9999) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => _removeMagazineField(index),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _presetNameController.dispose();
    for (var controller in _magazineControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}