import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'ember_quest.dart';
import 'overlays/game_over.dart';
import 'overlays/main_menu.dart';
import 'overlays/speed_boost_overlay.dart'; // ⬅ add this

void main() {
  runApp(
    GameWidget<EmberQuestGame>.controlled(
      gameFactory: EmberQuestGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'GameOver': (_, game) => GameOver(game: game),
        'SpeedBoost': (_, game) => SpeedBoostOverlay(game: game), // ⬅ new
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
