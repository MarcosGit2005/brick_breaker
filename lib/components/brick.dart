import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../brick_breaker.dart';
import '../config.dart';
import 'ball.dart';
import 'bat.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {
  Brick({required super.position, required Color color, required this.hits})
      : super(
    size: Vector2(brickWidth, brickHeight),
    anchor: Anchor.center,
    paint: Paint()
      ..color = color.withAlpha((255/3).round()*hits)
      ..style = PaintingStyle.fill,
    children: [RectangleHitbox()],
  );

  int hits;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    hits--;
    if (hits==0){
      removeFromParent();
      game.score.value++;
      if (game.world.children.query<Brick>().length == 1) {
        game.playState = PlayState.won;
        game.world.removeAll(game.world.children.query<Ball>());
        game.world.removeAll(game.world.children.query<Bat>());
      }
    } else {
      paint.color = paint.color.withAlpha((255/3).round()*hits);
    }
  }
}