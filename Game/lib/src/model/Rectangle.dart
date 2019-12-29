import 'package:DoNotLookDown/src/model/Element.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';

abstract class Rectangle extends Element {

  Position _positionBottomLeft;
  Position _positionBottomRight;
  Position _positionTopLeft;
  Position _positionTopRight;
  String _touchedSize = "";

  //Creates a new object of the class Rectangle.
  Rectangle(this._positionBottomLeft, this._positionBottomRight, this._positionTopLeft, this._positionTopRight, bool permeable, String type, Position currentPosition, int radius, MotionController motionController)
      : super(radius, permeable, type, currentPosition, motionController);

  //Required getter-methods
  Position get positionTopLeft => this._positionTopLeft;
  Position get positionTopRight => this._positionTopRight;
  Position get positionBottomLeft => this._positionBottomLeft;
  Position get positionBottomRight => this._positionBottomRight;
  int get top => positionTopLeft.Y.floor();
  int get left => positionTopLeft.X.floor();
  int get width => (positionTopRight.X - positionTopLeft.X).floor();
  int get height => (positionBottomLeft.Y - positionTopLeft.Y).floor();
  String get touchedSite => this._touchedSize;

  //Required setter-methods
  set positionBottomLeft(Position positionBottomLeft) => this._positionBottomLeft = positionBottomLeft;
  set positionBottomRight(Position positionBottomRight) => this._positionBottomRight = positionBottomRight;
  set positionTopLeft(Position positionTopLeft) => this._positionTopLeft = positionTopLeft;
  set positionTopRight(Position positionTopRight) => this._positionTopRight = positionTopRight;
  set touchedSite(String site) => this._touchedSize = site;

  //Updates the y-coordinate of all positions.
  void updatePositionOnlyY(double y) {
    this.positionTopLeft.Y = y;
    this.positionTopRight.Y = y;
    this.positionBottomLeft.Y = y;
    this.positionBottomRight.Y = y;
    if(this.currentPosition != null) this.currentPosition.Y = y;
  }

}