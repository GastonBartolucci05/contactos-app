import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Texto Grande', style: TextStyle(fontSize: 32)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(color: Colors.red, height: 50),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Container(color: Colors.blue, height: 60),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
