import 'dart:html';

import 'package:DoNotLookDown/src/DoNotLookDownController.dart';
import 'package:DoNotLookDown/src/DoNotLookDownView.dart';
import 'package:DoNotLookDown/src/model/Highscore.dart';
import 'package:DoNotLookDown/src/model/LevelGenerator.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';

class DoNotLookDownModel {

  DoNotLookDownController _controller;
  LevelGenerator _levelGenerator;
  MotionController _motionController;
  Highscore _highscore;

  int _level = 1;
  bool _nextLevel = false;

  //Creates a new object of the class DoNotLookDownModel.
  DoNotLookDownModel(this._controller) {
    this._levelGenerator = new LevelGenerator(this);
    this._motionController = new MotionController(this);
    this._highscore = new Highscore();
  }

  //Required getter-methods
  DoNotLookDownController get controller => this._controller;
  MotionController get motionController => this._motionController;
  LevelGenerator get levelGenerator => this._levelGenerator;
  Highscore get highscore => this._highscore;
  bool get nextLevel => this._nextLevel;
  int get level => this._level;

  //Required setter-methods
  set nextLevel(bool b) => this._nextLevel = b;
  set level(int level) => this._level = level;


  //Updates the position of the Crab.
  void updateCrabPosition(double x, double y) => this._motionController.updateCrabPosition(x, y);

  //Creates all necessary elements for the game.
  Future<bool> createElements(bool mobil) async {
    return await this.levelGenerator.makeRequest(this._level, mobil);
  }

  //Updates the level number:
  void updateLevel() => this._nextLevel == true ? this._level++ : this.level = 1;

  //Updates the level number:
  void restartLevel() => this.level == 1 ? 1 : this.level--;

}