import 'package:flutter/material.dart';

class PurpleOutlinedStyle extends StatelessWidget {
  const PurpleOutlinedStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.75,
          heightFactor: 0.75,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
