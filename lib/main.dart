import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:leena_tutorial/world/ground.dart';
import 'package:tiled/tiled.dart';
import 'package:flame/input.dart';
import 'package:leena_tutorial/actors/leena.dart';

void main() {
  runApp(GameWidget(game: LeenaGame()));
}

// add collision detection to FlameGame
class LeenaGame extends FlameGame with HasCollisionDetection, TapDetector {
  // inertia
  final double gravity = 2.8;
  final double pushSpeed = 100;
  final double jumpForce = 150;
  Vector2 velocity = Vector2(0, 0);

  // background
  late TiledComponent homeMap;

  // leena character
  Leena leena = Leena();

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    homeMap = await TiledComponent.load(
      "map.tmx",
      Vector2.all(32),
    );
    add(homeMap);

    // camera and viewport
    double mapWidth = 32.0 * homeMap.tileMap.map.width;
    double mapHeight = 32.0 * homeMap.tileMap.map.height;
    camera.viewport = FixedResolutionViewport(
      Vector2(mapWidth, mapHeight),
    );

    // collision detection
    final obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>("ground");
    for (final obj in obstacleGroup!.objects) {
      add(
        Ground(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y),
        ),
      );
    }

    // character
    add(
      leena
        ..sprite = await loadSprite("girl.png")
        ..size = Vector2.all(100)
        ..position = Vector2(400, 30),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!leena.onGround) {
      velocity.y += gravity;
    }
    leena.position += velocity * dt;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (leena.onGround) {
      // tap on far left of screen
      if (info.eventPosition.game.x < 100) {
        // move left
        if (leena.facingRight) {
          leena.flipHorizontallyAroundCenter();
          leena.facingRight = false;
        }
        velocity.x -= pushSpeed;
        print("move left");
      }

      // tap on far right of screen
      else if (info.eventPosition.game.x > size[0] - 100) {
        // move right
        if (!leena.facingRight) {
          leena.flipHorizontallyAroundCenter();
          leena.facingRight = true;
        }
        velocity.x += pushSpeed;
        print("move right");
      }

      // tap on top of screen
      if (info.eventPosition.game.y < 100) {
        leena.y -= 10;
        velocity.y = -jumpForce;
        print("jump up");
      }
    }
  }
}
