import 'dart:math';
import 'package:DoNotLookDown/src/model/Circle.dart';
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';

class Hole extends Circle {

  int _id;
  static List<Hole> _created = new List<Hole>();

  //Creates a new object of the class Hole.
  Hole(int radius, Position currentPosition, MotionController motionController) : super(radius, currentPosition, true, "Hole", motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class Hole.
  factory Hole.fromId(int id, int radius, Position currentPosition, MotionController motionController){
    var existing;
    if(_created.length < id) existing = _created.elementAt(id);
    if(existing != null) {
      existing.setRadius(radius);
      existing.currentPosition = currentPosition;
      existing.setMotionController = motionController;
    } else {
      existing = new Hole(radius, currentPosition, motionController);
    }
    return existing;
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if(sqrt(pow(crab.currentPosition.X - this.currentPosition.X, 2) + pow(crab.currentPosition.Y - this.currentPosition.Y, 2)) < this.radius) {
      this.motionController.crab.cancelSimulateExplosionMotion();
      this.motionController.crabExplodes = false;
      return true;
    }
    else return false;
  }

  @override
  bool checkMovementIsPossible(Crab crab) {
    return true;
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