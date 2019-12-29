import 'dart:math';
import 'package:DoNotLookDown/src/model/Circle.dart';
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/Bridge.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';

class EvilCrab extends Circle {

  int _id;
  bool _changeDirection = false;
  bool _touchedCrab = false;
  static List<EvilCrab> _created = new List<EvilCrab>();

  //Creates a new object of the class EvilCrab.
  EvilCrab(int radius, Position currentPosition, MotionController motionController) : super(radius, currentPosition, false, "EvilCrab", motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class EvilCrab.
  factory EvilCrab.fromId(int id, int radius, Position currentPosition, MotionController motionController){
    var existing;
    if(_created.length < id) existing = _created.elementAt(id);
    if(existing != null) {
      existing.setRadius(radius);
      existing.currentPosition = currentPosition;
      existing.setMotionController = motionController;
    } else {
      existing = new EvilCrab(radius, currentPosition, motionController);
    }
    return existing;
  }

  //Simulate the movement of the object.
  void simulate(Bridge b){
    double bridgeleft = b.positionTopLeft.X + this.radius;
    double bridgeright = b.positionTopRight.X - this.radius;

    if(!_changeDirection){
      if((this.currentPosition.X >= bridgeright) || (this._touchedCrab && this.motionController.touchedElementIsAvailable)){
        this._changeDirection = true;
        this.currentPosition.X = -5;
      } else {
        this.currentPosition.X = 5;
      }
    } else {
        if((this.currentPosition.X <= bridgeleft) || (this._touchedCrab && this.motionController.touchedElementIsAvailable)){
          this._changeDirection = false;
          this.currentPosition.X = 5;
        } else {
          this.currentPosition.X = -5;
        }
    }
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if(sqrt(pow(crab.currentPosition.X - this.currentPosition.X, 2) + pow(crab.currentPosition.Y - this.currentPosition.Y, 2)) <= (crab.radius + this.radius)) {
      this._touchedCrab = true;
      return true;
    } else {
      this._touchedCrab = false;
      return false;
    }
  }

  @override
  bool checkMovementIsPossible(Crab crab) {
    if(sqrt(pow(crab.currentPosition.X - this.currentPosition.X, 2) + pow(crab.currentPosition.Y - this.currentPosition.Y, 2)) >= (crab.radius + this.radius)) return true;
    return false;
  }

  @override
  Position determinePossiblePosition(Crab crab, Position position) {
    if(this.permeable) return position;
    else {
      double vectorLength;
      vectorLength = sqrt(pow(this.currentPosition.X.abs() - position.X.abs(), 2) + pow(this.currentPosition.Y.abs() - position.Y.abs() , 2));

      position.x = (this.currentPosition.X + (crab.radius + this.radius) * (1 / vectorLength) * (position.X - this.currentPosition.X));
      position.y = (this.currentPosition.Y + (crab.radius + this.radius) * (1 / vectorLength) * (position.Y - this.currentPosition.Y));

      return position;
    }
  }
}