import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Magazine {
  final int capacity;

  Magazine({required this.capacity});

  factory Magazine.fromJson(String capacity) {
    return Magazine(
      capacity: int.parse(capacity),
    );
  }
}

class Preset {
  final String name;
  final Map<String, dynamic> magazines;
  String date;

  Preset({
    required this.name,
    required this.magazines,
    required this.date,
  });

  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      name: json['presets'][0]['presetName'] as String,
      magazines: json['presets'][0]['parameters'] as Map<String, dynamic>, date: json['presets'][0]['createdAt'],
    );
  }

  List<Magazine> getMagazinesList() {
    List<Magazine> magazinesList = [];
    magazines.forEach((key, value) {
      if (key.startsWith('Magazine')) {
        magazinesList.add(Magazine.fromJson(value));
      }
    });
    return magazinesList;
  }
}

class MagazineDisplay extends StatefulWidget {
  final Preset preset;

  const MagazineDisplay({
    Key? key,
    required this.preset,
  }) : super(key: key);

  @override
  _MagazineDisplayState createState() => _MagazineDisplayState();
}

class _MagazineDisplayState extends State<MagazineDisplay> {
  Widget _buildMagazine(Magazine magazine, int index) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(0), // Inclinaison à gauche
      child: Column(
        children: [
          // Partie supérieure inclinée (le chargeur)
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.090,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 119, 114, 114),
              border: Border.all(color: const Color.fromARGB(255, 74, 74, 74), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${magazine.capacity}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Base solide
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.10,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

@override
Widget build(BuildContext context) {
  final magazinesList = widget.preset.getMagazinesList();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.preset.name),
    ),
    body: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // 5 items per row
                mainAxisSpacing: 16.0, // Space between rows
                crossAxisSpacing: 16.0, // Space between columns
              ),
              itemCount: magazinesList.length,
              itemBuilder: (context, index) {
                return _buildMagazine(magazinesList[index], index);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle end game button press
            },
            child: const Text('BOUTON FIN DE PARTIE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[100],
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    ),
  );
}
}