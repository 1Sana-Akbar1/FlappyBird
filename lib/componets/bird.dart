import 'package:bonfire/bonfire.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappybird/componets/config.dart';
import 'package:flappybird/game/flappy_bird.dart';
import 'package:flutter/animation.dart';

import '../game/assets.dart';
enum BirdMovement {middle, up, down}
enum BirdColour {red, yellow}

//TODO: make sprite animation of flapping and control the angle of the bird

// TODO: fix the bird speed lmao that shits annoying asf, specifically for co -op for a longer gameplay
class Bird extends SpriteGroupComponent<BirdMovement> with HasGameRef<FlappyBirdGame>,
CollisionCallbacks {
  Bird({required this.x_position});
  num time=0;
  int score=0;
  double speed =0.0;
  double x_position;
  @override
  Future<void> onLoad() async{
    final birdMidFlap = await gameRef.loadSprite(Assets.blueBirdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.blueBirdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.blueBirdDownFlap);

    size = Vector2(gameRef.size.y/13, gameRef.size.y/13);
    position = Vector2(x_position, gameRef.size.y/2 - size.y/2);
    current = BirdMovement.middle;
    sprites ={
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up : birdUpFlap,
      BirdMovement.down : birdDownFlap
    };
    add(CircleHitbox());
  }
  

  void fly(){
   speed -= Config.birdVelocity;
   // remove move by effect and make time have a negative value so that it will move up ?
   
    // add(
    //   MoveByEffect(
    //       Vector2(0,Config.gravity),
    //       EffectController(duration: 1.0, curve: Curves.easeIn),
    //       onComplete: () => current = BirdMovement.down,
    //
    //   )
    // );
    FlameAudio.play(Assets.fly);
    current = BirdMovement.up;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ){
    super.onCollisionStart(intersectionPoints, other);
    FlameAudio.play(Assets.hit);
  gameOver();
  }

  void gameOver(){
    gameRef.pauseEngine();
    game.isHit =true;
    gameRef.overlays.add('gameOver');
  }

  @override
  void update(double dt){
    super.update(dt);
    speed += Config.gravity*dt;
    position.y += speed*dt; // makes it go down?
    if(position.y<0){
      gameOver();
    }
  }
  void reset(){
    position = Vector2(50, gameRef.size.y/2 - size.y/2);
    time =0;
    score =0;
  }
}