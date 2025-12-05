// lib/objects/door_block.dart
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../ember_quest.dart';

class DoorBlock extends SpriteComponent
    with HasGameReference<EmberQuestGame> {
  final Vector2 gridPosition;
  final double xOffset;

  DoorBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(
    size: Vector2.all(64),
    anchor: Anchor.bottomLeft,
  );

  final Vector2 velocity = Vector2.zero();

  @override
  void onLoad() {
    // Make sure you have a door image in assets, e.g. 'door.png'
    final doorImage = game.images.fromCache('door.png');
    sprite = Sprite(doorImage);

    position = Vector2(
      (gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),
    );

    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;

    if (position.x < -size.x) {
      removeFromParent();
    }

    super.update(dt);
  }
}
