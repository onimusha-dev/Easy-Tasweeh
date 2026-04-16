import 'package:flutter/material.dart';

class CoralSoftStyle extends StatelessWidget {
  const CoralSoftStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFF7F50), // Coral
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7F50).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.fingerprint_rounded, color: Colors.white, size: 42),
      ),
    );
  }
}
