import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Rectangle.dart';

class Bridge extends Rectangle {

  int _id;
  static List<Bridge> _created = new List<Bridge>();

  //Creates a new object of the class Bridge.
  Bridge(Position positionBottomLeft, Position positionBottomRight, Position positionTopLeft, Position positionTopRight, Position currentPosition, int radius, MotionController motionController)
      : super(positionBottomLeft, positionBottomRight, positionTopLeft, positionTopRight, true, "Bridge", currentPosition, radius, motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class Bridge.
  factory Bridge.fromId(int id, Position positionBottomLeft, Position positionBottomRight, Position positionTopLeft, Position positionTopRight, Position currentPosition, int radius, MotionController motionController){
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
      existing = new Bridge(positionBottomLeft, positionBottomRight, positionTopLeft, positionTopRight, currentPosition, radius, motionController);
    }
    return existing;
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if (crab.currentPosition.X <= this.positionBottomLeft.X) {
      this.motionController.crab.cancelSimulateExplosionMotion();
      this.motionController.crabExplodes = false;
      this.motionController.crabFallsDown = true;
      this.motionController.crabFallsDownLeft = true;
      return true;
    }
    if (crab.currentPosition.X >= this.positionTopRight.X) {
      this.motionController.crab.cancelSimulateExplosionMotion();
      this.motionController.crabExplodes = false;
      this.motionController.crabFallsDown = true;
      this.motionController.crabFallsDownLeft = false;
      return true;
    }
    return false;
  }

  @override
  bool checkMovementIsPossible(Crab crab) {
    return true;
  }

  @override
  Position determinePossiblePosition(Crab crab, Position position) {
    return position;
  }
}