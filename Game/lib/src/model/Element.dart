import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';

abstract class Element {

  MotionController _motionController;
  int _radius;
  bool _permeable;
  String _type;
  Position _currentPosition;

  //Creates a new object of the class Element.
  Element(this._radius, this._permeable, this._type, this._currentPosition, this._motionController);

  //Required getter-methods
  int get radius => this._radius;
  get permeable => this._permeable;
  get type => this._type;
  Position get currentPosition => this._currentPosition;
  MotionController get motionController => this._motionController;

  //Required setter-methods
  set setRadius(int radius) => this._radius = radius;
  set currentPosition(Position currentPosition) => this._currentPosition = currentPosition;
  set motionController(MotionController motionController) => this._motionController = motionController;

  //Checks whether the crab collides with an object.
  bool checkCollisionToCrab(Crab crab);

  //Checks whether the movement of the crab is possible.
  bool checkMovementIsPossible(Crab crab);

  //Determines a possible movement of the crab.
  Position determinePossiblePosition(Crab crab, Position position);

}