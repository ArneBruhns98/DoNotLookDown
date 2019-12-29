import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Rectangle.dart';

class Finishline extends Rectangle {

  int _id;
  static List<Finishline> _created = new List<Finishline>();

  //Creates a new object of the class Finishline.
  Finishline(Position positionBottomLeft, Position positionBottomRight, Position positionTopLeft, Position positionTopRight, Position currentPosition, int radius, MotionController motionController)
      : super(positionBottomLeft, positionBottomRight, positionTopLeft, positionTopRight, true, "Finishline", currentPosition, radius, motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class Finishline.
  factory Finishline.fromId(int id, Position positionBottomLeft, Position positionBottomRight, Position positionTopLeft, Position positionTopRight, Position currentPosition, int radius, MotionController motionController){
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
      existing = new Finishline(positionBottomLeft, positionBottomRight, positionTopLeft, positionTopRight, currentPosition, radius, motionController);
    }
    return existing;
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if (crab.top <= this.positionBottomLeft.Y) {
      this.motionController.crab.cancelSimulateExplosionMotion();
      this.motionController.inverterActivated = false;
      this.motionController.crabExplodes = false;
      this.motionController.model.controller.newLevel();
      return true;
    }
    else return false;
  }

  @override
  bool checkMovementIsPossible(Crab crab) {
    return false;
  }

  @override
  Position determinePossiblePosition(Crab crab, Position position) {
    return position;
  }
}