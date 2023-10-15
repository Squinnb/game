import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:gain/actors/player.dart';
import 'package:gain/components/background_tile.dart';
import 'package:gain/components/fruit.dart';
import 'package:gain/components/saw.dart';
import 'package:gain/levels/platform.dart';
import 'package:flame/experimental.dart';

class Level extends World with HasGameRef {
  String levelName;
  Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    _spawnActors();
    _createPlatforms();
    // _setupCam();
    add(level);
    return super.onLoad();
  }

  void _spawnActors() {
    ObjectGroup? spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');
    if (spawnPointLayer != null) {
      for (TiledObject spawnPoint in spawnPointLayer.objects) {
        if (spawnPoint.class_ == "Player") {
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          player.spawnLocation = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
        } else if (spawnPoint.class_ == "Fruit") {
          Fruit f = Fruit(fruitType: spawnPoint.name, position: Vector2(spawnPoint.x, spawnPoint.y), size: Vector2(spawnPoint.width, spawnPoint.height));
          add(f);
        } else if (spawnPoint.class_ == "Saw") {
          double offNegative = spawnPoint.properties.getValue("offNegative");
          double offPositive = spawnPoint.properties.getValue("offPositive");
          bool isVertical = spawnPoint.properties.getValue("isVertical");
          Saw s = Saw(
              isVertical: isVertical,
              offNegative: offNegative,
              offPositive: offPositive,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height));
          add(s);
        }
      }
    }
  }

  void _createPlatforms() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        if (collision.class_ == "Passable") {
          // need to change class name
          final platform = Platform(position: Vector2(collision.x, collision.y), size: Vector2(collision.width, collision.height), isPassable: true);
          add(platform);
        } else {
          final block = Platform(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          add(block);
        }
      }
    }
  }

  void _setupCam() {
    double boundsWidth = (level.tileMap.map.width * level.tileMap.map.tileWidth).toDouble();
    double boundsHeight = (level.tileMap.map.height * level.tileMap.map.tileHeight).toDouble();
    Rect rect = Rect.fromLTWH(0, 0, boundsWidth, boundsHeight);
    gameRef.camera.setBounds(Rectangle.fromRect(rect));
  }

  void _addBackground() {
    Layer? background = level.tileMap.getLayer("Background");
    if (background != null) {
      String? bgColor = background.properties.getValue("BackgroundColor");
      const int tileSize = 64;
      int numTilesY = (game.size.y / tileSize).floor();
      int numTilesX = (game.size.x / tileSize).floor();
      for (double y = 0; y < (game.size.y / numTilesY); y++) {
        for (double x = 0; x < (game.size.x / numTilesX); x++) {
          BackgroundTile bgTile = BackgroundTile(color: bgColor ?? 'Gray', position: Vector2(x, y));
          add(bgTile);
        }
      }
    }
  }
}
