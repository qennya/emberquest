import 'package:emberquest/ember_quest.dart';
import 'package:flutter/material.dart';

class SpeedBoostOverlay extends StatelessWidget {
  const SpeedBoostOverlay({super.key, required EmberQuestGame game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'SPEED BOOST!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(blurRadius: 4, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
