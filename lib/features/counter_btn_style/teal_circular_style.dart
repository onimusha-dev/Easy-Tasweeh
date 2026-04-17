import 'package:flutter/material.dart';

class TealCircularStyle extends StatelessWidget {
  const TealCircularStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
