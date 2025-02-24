import 'package:brick_breaker/brick_breaker.dart';
import 'package:brick_breaker/components/play_area.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'bat.dart';
import 'brick.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
      radius: radius,
      anchor: Anchor.center,
      paint: Paint()
        ..color = const Color(0xff1e6091)
        ..style = PaintingStyle.fill,
      children: [CircleHitbox()]);

  final Vector2 velocity;
  final double difficultyModifier;
  bool paused = false;
  void pauseBall(){
    paused = !paused;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (paused){
      return;
    }
    position += velocity * dt;
    if (position.x+(width/2)<0){
      position.x=0;
    } else if (position.x>game.width-(width/2)) {
      position.x=game.width-(width/2);
    } else if (position.y+(height/2)<0){
      position.y=0;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(
          delay: 0.35,
          onComplete: () {
            game.playState = PlayState.gameOver;
          }
        ));
      }
    } else if (other is Bat) {
      velocity.y = -velocity.y;
      velocity.x = (position.x - other.position.x)*5 / other.size.x * game.width * 0.3;
      if (other.width>gameWidth * 0.1){
        other.width = other.width*0.99;
      }
    } else if (other is Brick) {
      super.paint = Paint()
        ..color = other.paint.color.withAlpha(255)
        ..style = PaintingStyle.fill;

      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      if (velocity.y<game.height/1.5){
        velocity.setFrom(velocity * difficultyModifier);
      }
    } else {
      debugPrint('collision with $other');
    }
  }
}
