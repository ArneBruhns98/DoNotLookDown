import 'dart:html';
import 'dart:math';

import 'package:DoNotLookDown/src/model/Circle.dart';
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/Bridge.dart';
import 'package:DoNotLookDown/src/model/DoNotLookDownModel.dart';
import 'package:DoNotLookDown/src/model/Element.dart';
import 'package:DoNotLookDown/src/model/Element.dart' as prefix;
import 'package:DoNotLookDown/src/model/Finishline.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Rectangle.dart';
import 'package:DoNotLookDown/src/model/Wind.dart';
import 'package:DoNotLookDown/src/model/Hole.dart';
import 'package:DoNotLookDown/src/model/Bird.dart';
import 'package:DoNotLookDown/src/model/EvilCrab.dart';
import 'package:DoNotLookDown/src/model/TNTBox.dart' as prefix;

class MotionController {

  DoNotLookDownModel _model;
  Wind _wind;
  Crab _crab;
  Map<String, List<prefix.Element>> _mapOfElements;

  double _vectorLength;
  double _x;
  double _y;
  prefix.Element _touchedElement;
  bool _crabTouchesFinishline = false;
  bool _crabFallsDown = false;
  bool _crabFallsDownLeft = false;
  bool _crabExplodes = false;
  bool _gameOver = false;
  bool _inverterActivated = false;
  bool fallHole = false;
  Hole holeToFall;


  //Creates a new object of the class MotionController.
  MotionController(this._model) {
    initializeEmptyMap();
  }

  //Required getter-methods
  Crab get crab => this._crab;
  Wind get wind => this._wind;
  DoNotLookDownModel get model => this._model;
  bool get isGameOver => this._gameOver;
  bool get crabTouchesLine => this._crabTouchesFinishline;
  bool get crabFallsDown => this._crabFallsDown;
  bool get crabFallsDownLeft => this._crabFallsDownLeft;
  bool get crabExplodes => this._crabExplodes;
  bool get inverterActivated => this._inverterActivated;
  bool get touchedElementIsAvailable => this._touchedElement == null ? false : true;
  prefix.Element get touchedElement => this._touchedElement;

  //Required getter-methods
  set crab(Crab crab) => this._crab = crab;
  set wind(Wind wind) => this._wind = wind;
  set isGameOver(bool b) => this._gameOver = b;
  set crabTouchesLine(bool b) => this._crabTouchesFinishline = b;
  set crabFallsDown(bool b) => this._crabFallsDown = b;
  set crabExplodes(bool b) => this._crabExplodes = b;
  set inverterActivated(bool b) => this._inverterActivated = b;
  set crabFallsDownLeft(bool b) => this._crabFallsDownLeft = b;


  //Returns an element from the map, which contains the elements of the game.
  Element getElement(String type, int id) => _mapOfElements[type][id - 1];

  //Returns the number of objects of a class.
  int numberOfElements(String type) => _mapOfElements[type].length;

  //Initialize an empty map for the elements.
  void initializeEmptyMap() {
    this._mapOfElements = {
      "Bridge": new List<prefix.Element>(),
      "Finishline": new List<prefix.Element>(),
      "Stone": new List<prefix.Element>(),
      "Hole": new List<prefix.Element>(),
      "EvilCrab": new List<prefix.Element>(),
      "Inverter": new List<prefix.Element>(),
      "TNTBox": new List<prefix.Element>(),
      "Wood": new List<prefix.Element>(),
      "Bird": new List<prefix.Element>()
    };
  }

  //Adds an element to the map, which contains the elements of the game.
  void fillMap(Element e) => _mapOfElements[e.type].add(e);

  //Updates the position of the Crab.
  void updateCrabPosition(double x, double y) {
    Position position;
    try {
      position = new Position(this._crab.currentPosition.X + x, this._crab.currentPosition.Y + y);
    } catch (Exception) {
      print("Krabbe wurde noch nicht erstellt.");
      return;
    }

    this._vectorLength = sqrt(pow(this._crab.currentPosition.X - position.X, 2) + pow(this._crab.currentPosition.Y - position.Y, 2));

    if (this._vectorLength > 4) {
      this._x = position.X - this._crab.currentPosition.X;
      this._y = position.Y - this._crab.currentPosition.Y;
      this._vectorLength = sqrt(pow(this._x, 2) + pow(this._y, 2));

      this._x = (4 / this._vectorLength) * x;
      this._y = (4 / this._vectorLength) * y;
    } else {
      this._x = x;
      this._y = y;
    }

    if (this._wind != null && x != 0 || y != 0) {
      this._x += this._wind.currentStrength;
      position.X = this._wind.currentStrength;
    }

    if (this._touchedElement != null) {
      if (!this._touchedElement.checkMovementIsPossible(this._crab)) {
        position = this._touchedElement.determinePossiblePosition(this._crab, position);
        if(this._crab.currentPosition.Y > window.innerHeight * 0.5 || (this.getElement("Bridge", 1) as Bridge).positionTopLeft.Y >= 0 || !y.isNegative) {
          this._crab.updatePositionWithPosition(position);
        } else {
          this._crab.updatePositionWithPositionOnlyX(position);
          this._updateElementsPosition(this._crab.currentPosition.Y - position.Y);
        }
      } else {
        this._touchedElement = null;
        if(this._crab.currentPosition.Y > window.innerHeight * 0.5 || (this.getElement("Bridge", 1) as Bridge).positionTopLeft.Y >= 0 || !y.isNegative) {
          this._crab.updatePositionWithPosition(position);
        } else {
          this._crab.updatePositionWithPositionOnlyX(position);
          this._updateElementsPosition((-1) * this._y);
        }
      }
    } else {
      this._checkCollision();
      if (this._touchedElement != null) {
        position = this._touchedElement.determinePossiblePosition(this._crab, position);
        if(this._crab.currentPosition.Y > window.innerHeight * 0.5 || (this.getElement("Bridge", 1) as Bridge).positionTopLeft.Y >= 0 || !y.isNegative) {
          this._crab.updatePositionWithPosition(position);
        } else {
          this._crab.updatePositionWithPositionOnlyX(position);
          this._updateElementsPosition((this._crab.currentPosition.Y - position.Y));
        }
      } else {
        if(this._crab.currentPosition.Y > window.innerHeight * 0.5 || (this.getElement("Bridge", 1) as Bridge).positionTopLeft.Y >= 0 || !y.isNegative) {
          this._crab.updatePosition(this._x, this._y);
        } else {
          this._crab.updatePositionOnlyX(this._x);
          this._updateElementsPosition((-1) * this._y);
        }
      }
    }

    this._crabTouchesFinishline = (getElement("Finishline", 1) as Finishline).checkCollisionToCrab(this.crab);
    this._crabFallsDown = (getElement("Bridge", 1) as Bridge).checkCollisionToCrab(this.crab);
    if (fallHole && !(getElement("Bridge", 1) as Bridge).checkCollisionToCrab(this.crab)) _crabFallsDown = true;
  }

  //Checks whether the crab collides with an object.
  void _checkCollision() {
    for (prefix.Element e in _mapOfElements["Stone"]) {
      if (e.checkCollisionToCrab(this._crab)) {
        this._touchedElement = e;
        return;
      }
    }
    for (prefix.Element e in _mapOfElements["Hole"]) {
      if (e.checkCollisionToCrab(this._crab)) {
        this._touchedElement = e;
        this.fallHole = true;
        this.holeToFall = _touchedElement;
        this._crabFallsDown = true;
        return;
      }
    }
    for (prefix.Element e in _mapOfElements["Inverter"]) {
      if (!this._inverterActivated && e.checkCollisionToCrab(this._crab)) {
        this._touchedElement = e;
        this._inverterActivated = true;
        return;
      }
    }
    for (prefix.TNTBox e in _mapOfElements["TNTBox"]) {
      if (e.visible == true &&  e.checkCollisionToCrab(this._crab)) {
        this._crabExplodes = true;
        this._crab.simulateExplosionMotion();
        this.model.controller.crabTouchedTNT = true;
        this._touchedElement = e;
        return;
      }
    }
    for (prefix.Element e in _mapOfElements["Wood"]) {
      if (e.checkCollisionToCrab(this._crab)) {
        this._touchedElement = e;
        return;
      }
    }
  }

  //Checks whether the crab collides with an EvilCrab.
  void checkCollisionEvilCrab(EvilCrab e){
      if (e.checkCollisionToCrab(this._crab)) {
        Position position = e.determinePossiblePosition(this._crab, this._crab.currentPosition);
        if(this._touchedElement == null) {
          if(this._crab.currentPosition.Y > window.innerHeight * 0.5 || (this.getElement("Bridge", 1) as Bridge).positionTopLeft.Y >= 0 || !position.Y.isNegative) {
            this._crab.updatePositionWithPosition(position);
          } else {
            this._crab.updatePositionWithPositionOnlyX(position);
            this._updateElementsPosition(this._y);
          }
        }
        if ((getElement("Bridge", 1) as Bridge).checkCollisionToCrab(this.crab)) this._crabFallsDown = true;
      }
  }

  //Checks whether the crab collides with a  Bird.
  void checkCollisionBird(Bird b){
    if(b.checkCollisionToCrab(this.crab)){
      this._model.controller.blockControl = true;
      this.isGameOver = true;
      this._model.controller.gameOver();
    }
  }

  //Updates the positions of all elements excepts the crab.
  void _updateElementsPosition(double y){
    for (Rectangle e in _mapOfElements["Bridge"]) e.updatePositionOnlyY(y);
    for (Rectangle e in _mapOfElements["Finishline"]) e.updatePositionOnlyY(y);
    for (Circle e in _mapOfElements["EvilCrab"]) e.updatePositionOnlyY(y);
    for (Circle e in _mapOfElements["Stone"]) e.updatePositionOnlyY(y);
    for (Circle e in _mapOfElements["Hole"]) e.updatePositionOnlyY(y);
    for (Rectangle e in _mapOfElements["Inverter"]) e.updatePositionOnlyY(y);
    for (Rectangle e in _mapOfElements["TNTBox"]) e.updatePositionOnlyY(y);
    for (Rectangle e in _mapOfElements["Wood"]) e.updatePositionOnlyY(y);
  }
}