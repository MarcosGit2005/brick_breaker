import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../brick_breaker.dart';

enum State {LEFT,STATIC,RIGHT}

class Bat extends PositionComponent
    with DragCallbacks, HasGameReference<BrickBreaker> {

  Bat({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  State state = State.STATIC;
  final Radius cornerRadius;
  final _paint = Paint()
    ..color = const Color(0xff1e6091)
    ..style = PaintingStyle.fill;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size.toSize(),
          cornerRadius,
        ),
        _paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x).clamp(0+(width/2), game.width-(width/2));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state==State.STATIC){
      return;
    }

    print(position.x);
    print((state==State.LEFT?-100:100) * dt);
    position.x = ( position.x + (state==State.LEFT?-500:500) * dt).clamp(0+(width/2), game.width-(width/2));
  }
  void changeState(String side){
    if (side=="L"){
      state = State.LEFT;
    } else if (side=="R"){
      state = State.RIGHT;
    } else {
      state = State.STATIC;
    }
    print(state);
  }

  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2((position.x + dx).clamp(0+(width/2), game.width-(width/2)), position.y),
      EffectController(duration: 0.1),
    ));
  }
}
