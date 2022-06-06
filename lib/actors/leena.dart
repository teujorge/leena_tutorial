import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:leena_tutorial/main.dart';
import 'package:leena_tutorial/world/ground.dart';

// new in Flame 1.1
// needed when you want an action to take place with a collision
class Leena extends SpriteComponent
    with CollisionCallbacks, HasGameRef<LeenaGame> {
  Leena() : super() {
    debugMode = true;
  }

  bool onGround = false;
  bool facingRight = true;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      gameRef.velocity.y = 0;
      onGround = true;
      // print("hit ground");
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    onGround = false;
  }
}
