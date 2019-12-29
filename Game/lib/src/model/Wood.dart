import 'dart:math' as math;
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Rectangle.dart';

class Wood extends Rectangle {

  int _id;
  static List<Wood> _created = new List<Wood>();

  //Creates a new object of the class Wood.
  Wood(Position positionBottomLeft, Position positionBottomRight, Position positionTopLeft, Position positionTopRight, Position currentPosition, int radius, MotionController motionController)
      : super(positionBottomLeft, positionBottomRight, positionTopLeft, positionTopRight, false, "Wood", currentPosition, radius,  motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class Wood.
  factory Wood.fromId(int id, Position positionBottomLeft, Position positionBottomRight, Position positionTopLeft, Position positionTopRight, Position currentPosition, int radius, MotionController motionController){
    var existing;
    if(_created.length < id) existing = _created.elementAt(id);
    if(existing != null) {
      existing.positionBottomLeft = positionBottomLeft;
      existing.positionBottomRight = positionBottomRight;
      existing.positionTopLeft = positionTopLeft;
      existing.positionTopRight = positionTopRight;
      existing.currentPosition = currentPosition;
      existing.motionController = motionController;
      existing.setRadius = radius;
    } else {
      existing = new Wood(positionBottomLeft, positionBottomRight, positionTopLeft, positionTopRight, currentPosition, radius, motionController);
    }
    return existing;
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if(math.sqrt(math.pow(crab.currentPosition.X - this.currentPosition.X, 2) + math.pow(crab.currentPosition.Y - this.currentPosition.Y, 2)) <= (this.radius + crab.radius)) {
      if(math.sqrt(math.pow(crab.currentPosition.X - this.positionBottomLeft.X, 2) + math.pow(crab.currentPosition.Y - this.positionBottomLeft.Y, 2)) <= crab.radius) return true;
      if(math.sqrt(math.pow(crab.currentPosition.X - this.positionBottomRight.X, 2) + math.pow(crab.currentPosition.Y - this.positionBottomRight.Y, 2)) <= crab.radius) return true;
      if(math.sqrt(math.pow(crab.currentPosition.X - this.positionTopLeft.X, 2) + math.pow(crab.currentPosition.Y - this.positionTopLeft.Y, 2)) <= crab.radius) return true;
      if(math.sqrt(math.pow(crab.currentPosition.X - this.positionTopRight.X, 2) + math.pow(crab.currentPosition.Y - this.positionTopRight.Y, 2)) <= crab.radius) return true;
      if(this.positionBottomLeft.Y <= crab.top && this.positionBottomLeft.Y + 5 >= crab.top ) {
        this.touchedSite = "bottom";
        return true;
      }
      if(this.positionTopLeft.Y >= crab.bottom && this.positionTopLeft.Y - 5 <= crab.bottom) {
        this.touchedSite = "top";
        return true;
      }
      if(this.positionTopRight.X >= crab.left && this.positionTopRight.X - 5 <= crab.left) {
        this.touchedSite = "right";
        return true;
      }
      if(this.positionTopLeft.X <= crab.right && this.positionTopLeft.X + 5 >= crab.right) {
        this.touchedSite = "left";
        return true;
      }
      return false;
    } else {
    return false;
    }
  }

  @override
  bool checkMovementIsPossible(Crab crab) {
    this.touchedSite = "";
    return !this.checkCollisionToCrab(crab);
  }

  @override
  Position determinePossiblePosition(Crab crab, Position position) {
    if(this.touchedSite == "") {
      if((position.X - this.currentPosition.X).abs() > (position.Y - this.currentPosition.Y).abs()) {
        if(position.X - this.currentPosition.X > 0) {
          position.x = this.currentPosition.X + width / 2 + crab.radius;
        } else {
          position.x = this.currentPosition.X - width / 2 - crab.radius;
        }
      } else {
        if(position.Y - this.currentPosition.Y > 0) {
          position.y = this.currentPosition.Y + height / 2 + crab.radius;
        } else {
          position.y = this.currentPosition.Y - height / 2 - crab.radius;
        }
      }
    } else {
      if(this.touchedSite == "bottom") {
        if(position.Y - crab.currentPosition.Y < 0) position.y = crab.currentPosition.Y;
      }
      if(this.touchedSite == "top") {
        if(position.Y - crab.currentPosition.Y > 0) position.y = crab.currentPosition.Y;
      }
      if(this.touchedSite == "right") {
        if(crab.currentPosition.X - position.X > 0) position.x = crab.currentPosition.X;
      }
      if(this.touchedSite == "left") {
        if(crab.currentPosition.X - position.X < 0) position.x = crab.currentPosition.X;
      }
    }
    return position;
  }
}