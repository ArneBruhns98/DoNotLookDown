import 'package:DoNotLookDown/src/model/Element.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';

abstract class Circle extends Element {

  //Creates a new object of the class Circle.
  Circle(int radius, currentPosition, bool preamble, String type, MotionController motionController) : super(radius, preamble, type, currentPosition, motionController);

  //Required getter-methods
  int get top => (this.currentPosition.Y - this.radius.roundToDouble()).floor();
  int get bottom => (this.currentPosition.Y  + this.radius.roundToDouble()).floor();
  int get left => (this.currentPosition.X - this.radius.roundToDouble()).floor();
  int get right  => (this.currentPosition.X + this.radius.roundToDouble()).floor();
  int get diameter => (2 * this.radius.roundToDouble()).floor();

  //Updates the y-coordinate of the currentPosition.
  void updatePositionOnlyY(double y) => this.currentPosition.Y = y;

}