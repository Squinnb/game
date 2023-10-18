import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:gain/actors/player.dart';
import 'package:gain/levels/level.dart';

class Gain extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late CameraComponent cam;
  Player player = Player();
  List<String> levelNames = ["Grass Land", "Desert Plain2", "Ice Mountain"];
  int _levelIndex = 0;
  double volume = 0.5;
  bool playSoundEffect = true;

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
    cam = CameraComponent(world: world);
    cam.follow(player);
    addAll([world, cam]);
  }
}
