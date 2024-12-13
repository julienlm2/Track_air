import 'package:flutter/material.dart';
import 'package:track_air/ParametrePage.dart';
import 'package:track_air/StartPage.dart';

class landingPage extends StatelessWidget {
  const landingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Startpage()),
                );
              },
              child: const Text('Go to Page One'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParametrePage()),
                );
              },
              child: const Text('Go to Page Three'),
            ),
          ],
        ),
      ),
    );
  }
}
