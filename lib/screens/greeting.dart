import 'package:flutter/material.dart';

class GreetingScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const GreetingScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://res.cloudinary.com/drdefvojb/image/upload/v1745478191/proyects_uv/xn0qn2jzql2pnwowfltq.png',
              height: 150,
              width: 150,
              scale: 1.0,
            ),

            const SizedBox(height: 24),
            Text(
              '¡Bienvenido a Jammies!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Tu espacio para descubrir, compartir y disfrutar música como nunca antes.',
              style: TextStyle(fontSize: 18, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: onContinue,
              child: Text('Empezar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF86CECB),
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
