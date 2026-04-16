import 'package:flutter/material.dart';

class AmberGradientStyle extends StatelessWidget {
  const AmberGradientStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade400, Colors.orange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: const Center(
        child: Icon(Icons.touch_app_rounded, color: Colors.white, size: 36),
      ),
    );
  }
}
