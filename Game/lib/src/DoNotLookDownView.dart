import 'dart:html';
import 'dart:math';
import 'dart:async';

import 'package:DoNotLookDown/src/DoNotLookDownController.dart';
import 'package:DoNotLookDown/src/model/Bridge.dart';
import 'package:DoNotLookDown/src/model/DoNotLookDownModel.dart';
import 'package:DoNotLookDown/src/model/Finishline.dart';
import 'package:DoNotLookDown/src/model/Stone.dart';
import 'package:DoNotLookDown/src/model/Hole.dart';
import 'package:DoNotLookDown/src/model/EvilCrab.dart';
import 'package:DoNotLookDown/src/model/TNTBox.dart';
import 'package:DoNotLookDown/src/model/Wood.dart';
import 'package:DoNotLookDown/src/model/Inverter.dart';
import 'package:DoNotLookDown/src/model/Bird.dart';

class DoNotLookDownView {

  DoNotLookDownController _controller;
  DoNotLookDownModel _model;
  bool _windDirectionChosen = false;


  final headline = querySelector("#headline");
  final start = querySelector("#start");
  final gameOver = querySelector("#gameOver");
  final countdown = querySelector("#countdown");
  final nextLevel = querySelector("#nextLevel");
  final highScore = querySelector("#highScore");
  final reachedScore = querySelector("#reachedScore");
  final maxReached = querySelector("#maxReached");
  final bridge = querySelector("#bridge");
  final finishline = querySelector("#finishline");
  final crab = querySelector("#crab");
  final wood = querySelector("#wood");
  final tntbox = querySelector("#tntbox");
  final bird = querySelector("#bird");
  final inverter = querySelector("#inverter");
  final stone = querySelector("#stone");
  final hole = querySelector("#hole");
  final evilCrab = querySelector("#evilCrab");
  final boom = querySelector("#boom");
  final wind = querySelector("#wind");
  final windWarning = querySelector("#windWarning");
  final viewWarning = querySelector("#viewWarning");
  final darkLevel = querySelector("#darkLevel");

  /*
   * Creates a new object of the class DoNotLookDownView.
   */
  DoNotLookDownView(this._controller);

  /* Sets the model */
  set model(DoNotLookDownModel model) => this._model = model;
  /* Returns the width of the window */
  int get width => window.innerWidth;
  /* Returns the height of the window */
  int get height => window.innerHeight;
  /* Returns the size */
  int get size => min(this.width, this.height);
  /* Returns the middle x-coordinate */
  double get center_x => this.width / 2;
  /* Returns the maximum y-coordinate */
  int get botton_y_max => this.height;

  /*
   * Generates the field for the game.
   */
  void generateField(){
    Element element;
    final round = "${size}px";

    this.start.style.display = "none";
    this.gameOver.style.display = "none";
    this.nextLevel.style.display = "none";
    this.windWarning.style.display = "none";
    this.highScore.style.display = "none";
    this.reachedScore.style.display = "none";
    this.maxReached.style.display = "none";
    this.boom.style.display = "none";
    this.wind.style.display = "none";
    this.countdown.style.display = "none";

    this.bridge.style.display = "unset";
    this.stone.style.display = "unset";
    this.hole.style.display = "unset";
    this.evilCrab.style.display = "unset";
    this.wood.style.display = "unset";
    this.tntbox.style.display = "unset";
    this.inverter.style.display = "unset";
    this.bird.style.display = "unset";

    for(int i = 1; i <= (_model.motionController.numberOfElements("Bridge")); i++){
      element = Element.div();
      element.id = "bridgeChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("Bridge", i) as Bridge).top}px";
      element.style.left = "${(_model.motionController.getElement("Bridge", i) as Bridge).left}px";
      element.style.height = "${(_model.motionController.getElement("Bridge", i) as Bridge).height}px";
      element.style.width = "${(_model.motionController.getElement("Bridge", i) as Bridge).width}px";
      this.bridge.children.add(element);
    }

    this.finishline.style.display = "unset";
    this.finishline.style.top = "${(_model.motionController.getElement("Finishline", 1) as Finishline).top}px";
    this.finishline.style.left = "${(_model.motionController.getElement("Finishline", 1) as Finishline).left}px";
    this.finishline.style.height = "${(_model.motionController.getElement("Finishline", 1) as Finishline).height}px";
    this.finishline.style.width = "${(_model.motionController.getElement("Finishline", 1) as Finishline).width}px";

    for(int i = 1; i <= (_model.motionController.numberOfElements("Stone")); i++){
      element = Element.div();
      element.id = "stoneChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("Stone", i) as Stone).top}px";
      element.style.left = "${(_model.motionController.getElement("Stone", i) as Stone).left}px";
      element.style.width = "${(_model.motionController.getElement("Stone", i) as Stone).diameter}px";
      element.style.height = "${(_model.motionController.getElement("Stone", i) as Stone).diameter}px";
      element.style.borderRadius = round;
      this.stone.children.add(element);
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Hole")); i++){
      element = Element.div();
      element.id = "holeChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("Hole", i) as Hole).top}px";
      element.style.left = "${(_model.motionController.getElement("Hole", i) as Hole).left}px";
      element.style.width = "${(_model.motionController.getElement("Hole", i) as Hole).diameter}px";
      element.style.height = "${(_model.motionController.getElement("Hole", i) as Hole).diameter}px";
      element.style.borderRadius = round;
      this.hole.children.add(element);
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("EvilCrab")); i++){
      element = Element.div();
      element.id = "evilCrabChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).top}px";
      element.style.left = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).left}px";
      element.style.width = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).diameter}px";
      element.style.height = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).diameter}px";
      element.style.borderRadius = round;
      this.evilCrab.children.add(element);
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Wood")); i++){
      element = Element.div();
      element.id = "woodChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("Wood", i) as Wood).top}px";
      element.style.left = "${(_model.motionController.getElement("Wood", i) as Wood).left}px";
      element.style.width = "${(_model.motionController.getElement("Wood", i) as Wood).height}px";
      element.style.height = "${(_model.motionController.getElement("Wood", i) as Wood).width}px";
      this.wood.children.add(element);
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("TNTBox")); i++){
      element = Element.div();
      element.id = "tntboxChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).top}px";
      element.style.left = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).left}px";
      element.style.width = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).height}px";
      element.style.height = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).width}px";
      this.tntbox.children.add(element);
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Inverter")); i++){
      element = Element.div();
      element.id = "inverterChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("Inverter", i) as Inverter).top}px";
      element.style.left = "${(_model.motionController.getElement("Inverter", i) as Inverter).left}px";
      element.style.width = "${(_model.motionController.getElement("Inverter", i) as Inverter).height}px";
      element.style.height = "${(_model.motionController.getElement("Inverter", i) as Inverter).width}px";
      this.inverter.children.add(element);
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Bird")); i++){
      element = Element.div();
      element.id = "birdChild";
      element.style.display = "unset";
      element.style.top = "${(_model.motionController.getElement("Bird", i) as Bird).top}px";
      element.style.left = "${(_model.motionController.getElement("Bird", i) as Bird).left}px";
      element.style.width = "${(_model.motionController.getElement("Bird", i) as Bird).diameter}px";
      element.style.height = "${(_model.motionController.getElement("Bird", i) as Bird).diameter}px";
      this.bird.children.add(element);
    }
  }

  /*
   * Updates the game-view.
   */
  void update(){
    if(!this._controller.countdownIsON) this.countdown.style.display = "none";
    final round = "${size}px";

    for(int i = 1; i <= (_model.motionController.numberOfElements("Bridge")); i++){
      this.bridge.children.elementAt(i-1).style.display = "unset";
      this.bridge.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("Bridge", i) as Bridge).top}px";
      this.bridge.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("Bridge", i) as Bridge).left}px";
      this.bridge.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("Bridge", i) as Bridge).height}px";
      this.bridge.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("Bridge", i) as Bridge).width}px";
    }

    this.finishline.style.top = "${(_model.motionController.getElement("Finishline", 1) as Finishline).top}px";
    this.finishline.style.left = "${(_model.motionController.getElement("Finishline", 1) as Finishline).left}px";
    this.finishline.style.height = "${(_model.motionController.getElement("Finishline", 1) as Finishline).height}px";
    this.finishline.style.width = "${(_model.motionController.getElement("Finishline", 1) as Finishline).width}px";

    if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine)
      this.crab.style.display = "unset";
    this.crab.style.top = "${_model.motionController.crab.top}px";
    this.crab.style.left = "${_model.motionController.crab.left}px";
    this.crab.style.width = "${_model.motionController.crab.diameter}px";
    this.crab.style.height = "${_model.motionController.crab.diameter}px";
    this.crab.style.borderRadius = round;

    for(int i = 1; i <= (_model.motionController.numberOfElements("Stone")); i++){
      this.stone.children.elementAt(i-1).style.display = "unset";
      this.stone.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("Stone", i) as Stone).top}px";
      this.stone.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("Stone", i) as Stone).left}px";
      this.stone.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("Stone", i) as Stone).diameter}px";
      this.stone.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("Stone", i) as Stone).diameter}px";
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Hole")); i++){
      this.hole.children.elementAt(i-1).style.display = "unset";
      this.hole.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("Hole", i) as Hole).top}px";
      this.hole.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("Hole", i) as Hole).left}px";
      this.hole.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("Hole", i) as Hole).diameter}px";
      this.hole.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("Hole", i) as Hole).diameter}px";
    }

    for(int i = 1; i <= this.evilCrab.children.length; i++){
      if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine)
        this.evilCrab.children.elementAt(i-1).style.display = "unset";
      this.evilCrab.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).top}px";
      this.evilCrab.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).left}px";
      this.evilCrab.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).diameter}px";
      this.evilCrab.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("EvilCrab", i) as EvilCrab).diameter}px";
      this.evilCrab.children.elementAt(i-1).style.borderRadius = round;
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Wood")); i++){
      this.wood.children.elementAt(i-1).style.display = "unset";
      this.wood.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("Wood", i) as Wood).top}px";
      this.wood.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("Wood", i) as Wood).left}px";
      this.wood.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("Wood", i) as Wood).height}px";
      this.wood.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("Wood", i) as Wood).width}px";
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("TNTBox")); i++){
      this.tntbox.children.elementAt(i-1).style.display = "unset";
      this.tntbox.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).top}px";
      this.tntbox.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).left}px";
      this.tntbox.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).height}px";
      this.tntbox.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("TNTBox", i) as TNTBox).width}px";
    }

    for(int i = 1; i <= (_model.motionController.numberOfElements("Inverter")); i++){
      this.inverter.children.elementAt(i-1).style.display = "unset";
      this.inverter.children.elementAt(i-1).style.top = "${(_model.motionController.getElement("Inverter", i) as Inverter).top}px";
      this.inverter.children.elementAt(i-1).style.left = "${(_model.motionController.getElement("Inverter", i) as Inverter).left}px";
      this.inverter.children.elementAt(i-1).style.width = "${(_model.motionController.getElement("Inverter", i) as Inverter).height}px";
      this.inverter.children.elementAt(i-1).style.height = "${(_model.motionController.getElement("Inverter", i) as Inverter).width}px";
    }

    for(int i = 1; i <= this.bird.children.length; i++){
      if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine) {
        switch ((_model.motionController.getElement("Bird", i) as Bird).directionToLook) {
          case "north":
            this.bird.children.elementAt(i - 1).style.backgroundImage = "url(./img/birdNorth.gif)";
            break;
          case "south":
            this.bird.children.elementAt(i - 1).style.backgroundImage = "url(./img/birdSouth.gif)";
            break;
          case "west":
            this.bird.children.elementAt(i - 1).style.backgroundImage = "url(./img/birdWest.gif)";
            break;
          case "east":
            this.bird.children.elementAt(i - 1).style.backgroundImage = "url(./img/birdEast.gif)";
            break;
        }

        this.bird.children.elementAt(i - 1).style.display = "unset";
        this.bird.children.elementAt(i - 1).style.top = "${(_model.motionController.getElement("Bird", i) as Bird).top}px";
        this.bird.children.elementAt(i - 1).style.left = "${(_model.motionController.getElement("Bird", i) as Bird).left}px";
        this.bird.children.elementAt(i - 1).style.width = "${(_model.motionController.getElement("Bird", i) as Bird).diameter}px";
        this.bird.children.elementAt(i - 1).style.height = "${(_model.motionController.getElement("Bird", i) as Bird).diameter}px";
        this.bird.children.elementAt(i - 1).style.borderRadius = round;
      }
    }

    for(int i = 1; i <= this.tntbox.children.length; i++){
      if(!(this._model.motionController.getElement("TNTBox", i) as TNTBox).visible){
        this.tntbox.children.elementAt(i-1).style.display = "none";
      }
    }

    this.simulateBoom();

    if(this._model.motionController.wind.enabled && !this._model.motionController.isGameOver &&
        !this._model.motionController.crabTouchesLine && !this._controller.crabTouchedTNT){
        this.showWind(true);
    } else if(!this._model.motionController.wind.enabled || this._controller.crabTouchedTNT){
        this.showWind(false);
    }
  }

  //Game Over Screen
  void showGameOver(){
    this.crab.style.display = "none";
    this.crab.style.width = "0px";
    this.crab.style.height = "0px";
    this.bridge.style.display = "none";
    this.finishline.style.display = "none";
    this.stone.style.display = "none";
    this.hole.style.display = "none";
    this.evilCrab.style.display = "none";
    this.bird.style.display = "none";
    this.wood.style.display = "none";
    this.tntbox.style.display = "none";
    this.nextLevel.style.display = "none";
    this.windWarning.style.display = "none";
    this.boom.style.display = "none";
    this.wind.style.display = "none";
    this.inverter.style.display = "none";
    this.countdown.style.display = "none";
    this.darkLevel.style.display = "none";
    this.maxReached.style.backgroundImage = "url(./img/maxReachedFalse.png)";
    this.reachedScore.innerHtml = "${this._model.level == 1 ? 0 : this._model.level - 1}";
    this.highScore.innerHtml = "${this._model.highscore.highscore}";
    this.highScore.style.display = "unset";
    this.reachedScore.style.display = "unset";
    this.maxReached.style.display = "unset";
    this.gameOver.style.display = "unset";
    this.removeChildrens();
  }

  //Next Level Screen
  void showNextLevel(){
    this.crab.style.display = "none";
    this.bridge.style.display = "none";
    this.finishline.style.display = "none";
    this.stone.style.display = "none";
    this.hole.style.display = "none";
    this.evilCrab.style.display = "none";
    this.bird.style.display = "none";
    this.wood.style.display = "none";
    this.tntbox.style.display = "none";
    this.gameOver.style.display = "none";
    this.highScore.style.display = "none";
    this.reachedScore.style.display = "none";
    this.maxReached.style.display = "none";
    this.windWarning.style.display = "none";
    this.boom.style.display = "none";
    this.wind.style.display = "none";
    this.inverter.style.display = "none";
    this.countdown.style.display = "none";
    this.darkLevel.style.display = "none";
    this.nextLevel.style.display = "unset";
    if(!this._model.nextLevel) {
      this.maxReached.style.backgroundImage = "url(./img/maxReachedTrue.png)";
      this.reachedScore.innerHtml = "${this._model.level}";
      this.highScore.innerHtml = "${this._model.highscore.highscore}";
      this.highScore.style.display = "unset";
      this.reachedScore.style.display = "unset";
      this.maxReached.style.display = "unset";
    }
    this.removeChildrens();
  }

  //Restart Screen
  void showRestartLevel(){
    this.start.style.display = "none";
    this.crab.style.display = "none";
    this.bridge.style.display = "none";
    this.finishline.style.display = "none";
    this.stone.style.display = "none";
    this.hole.style.display = "none";
    this.evilCrab.style.display = "none";
    this.bird.style.display = "none";
    this.wood.style.display = "none";
    this.tntbox.style.display = "none";
    this.gameOver.style.display = "none";
    this.highScore.style.display = "none";
    this.reachedScore.style.display = "none";
    this.maxReached.style.display = "none";
    this.windWarning.style.display = "none";
    this.boom.style.display = "none";
    this.darkLevel.style.display = "none";
    this.wind.style.display = "none";
    this.inverter.style.display = "none";
    this.countdown.style.display = "none";
    this.nextLevel.style.display = "unset";
    this.maxReached.style.backgroundImage = "url(./img/failLoad.png)";
    this.reachedScore.style.display = "unset";
    this.removeChildrens();
  }

  //Removes Children, which are not in use anymore
  void removeChildrens(){
    for(Element e in this.stone.children){ this.stone.children.remove(e);}
    for(Element e in this.hole.children){ this.hole.children.remove(e);}
    for(Element e in this.evilCrab.children) {this.evilCrab.children.remove(e);}
    for(Element e in this.bird.children) {this.bird.children.remove(e);}
    for(Element e in this.wood.children){ this.wood.children.remove(e);}
    for(Element e in this.tntbox.children) {this.tntbox.children.remove(e);}
    for(Element e in this.inverter.children) {this.inverter.children.remove(e);}
    for(Element e in this.bridge.children) {this.bridge.children.remove(e);}
  }

  //Wind Animation
  void showWind(bool status){
    if(status){
      //Want to avoid perma - direction-gif setting
      if(this._model.motionController.wind.directionEast == "true" && !this._windDirectionChosen){
        this.wind.style.backgroundImage = "url(./img/windW.gif)";
        this._windDirectionChosen = true;
      } else if(this._model.motionController.wind.directionEast == "false" && !this._windDirectionChosen){
        this.wind.style.backgroundImage = "url(./img/windO.gif)";
        this._windDirectionChosen = true;
      }
      this.windWarning.style.display = "unset";
      this.wind.style.display = "unset";
    }
    if(!status){
      this.windWarning.style.display = "none";
      this.wind.style.display = "none";
      this._windDirectionChosen = false;
    }
  }

  //Just a delayed Function for TNT explosion
  Future waitBoom() {
    return new Future.delayed(const Duration(seconds: 1), () {
      this.boom.style.display = "none";
      this._controller.crabTouchedTNT = false;
    });
  }

  //Simulation of TNT explosion
  void simulateBoom(){
    if(this._controller.crabTouchedTNT) {
      this.boom.style.display = "unset";
      waitBoom();
    }
  }

  //Sets the Crab Texture (Confused/Normal)
  void confusedCrab(bool status){
     if(status) {this.crab.style.backgroundImage = "url(./img/crabConfused.gif)";}
     else {this.crab.style.backgroundImage = "url(./img/crab.gif)";}
  }

  //Enable Countdown
  void showCountdown(bool mobile, int countdown){
    this.countdown.style.display = "unset";
    if(mobile) {
      this.countdown.innerHtml = "<br /> Starting in $countdown seconds <br /> (Calibrating)";
      this.countdown.style.fontSize = "4em";
    } else {
      this.countdown.innerHtml = "<br />Starting in $countdown seconds";
      this.countdown.style.fontSize = "5em";
    }
  }

  //Alert WRONG DIMENSIONS
  void showViewWarning(bool status){
      if(status == true){this.viewWarning.style.display = "unset";}
      else{this.viewWarning.style.display = "none";}
  }

  //DarkÖevel Toggle
  void showDarkLevel(){
    this.darkLevel.style.display = "unset";
  }
}