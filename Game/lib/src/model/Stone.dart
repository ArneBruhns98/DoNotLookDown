import 'dart:math';
import 'package:DoNotLookDown/src/model/Circle.dart';
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';

class Stone extends Circle {

  int _id;
  static List<Stone> _created = new List<Stone>();

  //Creates a new object of the class Stone.
  Stone(int radius, Position currentPosition, MotionController motionController) : super(radius, currentPosition, false, "Stone", motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class Stone.
  factory Stone.fromId(int id, int radius, Position currentPosition, MotionController motionController){
    var existing;
    if(_created.length < id) existing = _created.elementAt(id);
    if(existing != null) {
      existing.setRadius(radius);
      existing.currentPosition = currentPosition;
      existing.setMotionController = motionController;
    } else {
      existing = new Stone(radius, currentPosition, motionController);
    }
    return existing;
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if(sqrt(pow(crab.currentPosition.X - this.currentPosition.X, 2) + pow(crab.currentPosition.Y - this.currentPosition.Y, 2)) <= (crab.radius + this.radius)) return true;
    else return false;
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