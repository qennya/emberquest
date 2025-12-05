import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'actors/ember.dart';
import 'actors/water_enemy.dart';
import 'managers/segment_manager.dart';
import 'objects/ground_block.dart';
import 'objects/platform_block.dart';
import 'objects/star.dart';
import 'overlays/hud.dart';
import 'objects/door_block.dart';

class EmberQuestGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  EmberQuestGame();

  late EmberPlayer _ember;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;

  int starsCollected = 0;
  int health = 3;
  double cloudSpeed = 0.0;
  double objectSpeed = 0.0;

  Color currentBackgroundColor =
  const Color.fromARGB(255, 173, 223, 247);
  late RectangleComponent _bgRect;

  @override
  Future<void> onLoad() async {
    //debugMode = true; // Uncomment to see the bounding boxes
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'door.png',
      'water_enemy.png',
    ]);
    camera.viewfinder.anchor = Anchor.topLeft;

    // Create a background rectangle that fills the screen
    _bgRect = RectangleComponent(
      position: Vector2.zero(),
      size: size, // initial game size
      paint: Paint()..color = currentBackgroundColor,
      priority: -10, // make sure it renders behind everything else
    );
    world.add(_bgRect);


    initializeGame(loadHud: true);
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }

  @override
  Color backgroundColor() {
    return currentBackgroundColor;
  }

  void loadGameSegments(int segmentIndex, double xPositionOffset) {
    for (final block in segments[segmentIndex]) {
      final component = switch (block.blockType) {
        const (GroundBlock) => GroundBlock(
          gridPosition: block.gridPosition,
          xOffset: xPositionOffset,
        ),
        const (PlatformBlock) => PlatformBlock(
          gridPosition: block.gridPosition,
          xOffset: xPositionOffset,
        ),
        const (Star) => Star(
          gridPosition: block.gridPosition,
          xOffset: xPositionOffset,
        ),
        const (WaterEnemy) => WaterEnemy(
          gridPosition: block.gridPosition,
          xOffset: xPositionOffset,
        ),
        const (DoorBlock) => DoorBlock(
          gridPosition: block.gridPosition,
          xOffset: xPositionOffset,
        ),
        _ => throw UnimplementedError(),
      };
      world.add(component);
    }
  }


  void initializeGame({required bool loadHud}) {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    final clampedSegmentsToLoad =
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= clampedSegmentsToLoad; i++) {
      final xOffset = (640 * i).toDouble();

      // Loop through the segments list in order.
      // Since worldChangeSegment is last in the list,
      // the door will appear at the end before the cycle repeats.
      final index = i % segments.length;
      loadGameSegments(index, xOffset);
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    world.add(_ember);

    if (loadHud) {
      camera.viewport.add(Hud());
    }
  }



  void reset() {
    // 1. Clear score and health
    starsCollected = 0;
    health = 3;

    // 2. Remove all world entities (including the old Ember)
    // Convert toList() first so we don't modify while iterating
    for (final c in world.children.toList()) {
      c.removeFromParent();
    }

    // 3. Clear HUD / viewport components (health/hearts, etc.)
    for (final c in camera.viewport.children.toList()) {
      c.removeFromParent();
    }

    // 4. Remove GameOver overlay if it is active
    if (overlays.isActive('GameOver')) {
      overlays.remove('GameOver');
    }

    // 5. Re-initialize the game (new Ember, new segments, new HUD)
    initializeGame(loadHud: true);
  }


  void changeWorld() {
    // 1. Save Ember’s current progress
    final savedStars = starsCollected;
    final savedHealth = health;

    // 2. Remove current world blocks/enemies/collectibles/doors
    world.children.whereType<GroundBlock>().forEach((c) => c.removeFromParent());
    world.children.whereType<PlatformBlock>().forEach((c) => c.removeFromParent());
    world.children.whereType<Star>().forEach((c) => c.removeFromParent());
    world.children.whereType<WaterEnemy>().forEach((c) => c.removeFromParent());
    world.children.whereType<DoorBlock>().forEach((c) => c.removeFromParent());

    // 3. Reset Ember’s position to the start (keep the same Ember instance)
    _ember.position = Vector2(128, canvasSize.y - 128);

    // 4. Reload segments in the same order as initializeGame
    final segmentsToLoad = (size.x / 640).ceil();
    final clampedSegmentsToLoad =
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= clampedSegmentsToLoad; i++) {
      final xOffset = (640 * i).toDouble();
      final index = i % segments.length;
      loadGameSegments(index, xOffset);
    }


    // 5. Restore Ember’s progress
    starsCollected = savedStars;
    health = savedHealth;
    _ember.moveSpeed = (_ember.moveSpeed + 200).clamp(200, 1000);



    // After restoring stars & health
    if (currentBackgroundColor ==
        const Color.fromARGB(255, 173, 223, 247)) {
      currentBackgroundColor = const Color.fromARGB(255, 150, 80, 200);
    } else {
      currentBackgroundColor = const Color.fromARGB(255, 173, 223, 247);
    }

    _bgRect.paint.color = currentBackgroundColor;

  }


}
