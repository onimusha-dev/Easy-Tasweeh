import 'package:flutter/material.dart';

class NeonGlowStyle extends StatelessWidget {
  const NeonGlowStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.cyanAccent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'GO',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            shadows: [
              Shadow(
                color: Colors.cyanAccent,
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
