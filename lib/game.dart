import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import '/actors/player.dart';
import '/levels/level.dart';

class Gain extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late CameraComponent cam;
  Player player = Player();
  List<String> levelNames = ["Blue World One", "Blue World Two", "Blue World Three"];
  int _levelIndex = 0;
  double volume = 0.5;
  bool playSoundEffect = true;
  late Level currLevel;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages(); // into cache
    _loadLevel();
    return super.onLoad();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);
    if (_levelIndex < levelNames.length - 1) {
      _levelIndex++;
      _loadLevel();
    } else {
      _levelIndex = 0;
      _loadLevel();
      // You beat the game
    }
  }

  void _loadLevel() {
    Level world = Level(levelName: levelNames[_levelIndex], player: player);
    currLevel = world;
    cam = CameraComponent.withFixedResolution(world: world, width: 640, height: 320);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([world, cam]);
  }
}
