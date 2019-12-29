import 'dart:async';
import 'dart:math';
import 'package:DoNotLookDown/src/model/Bridge.dart';
import 'package:DoNotLookDown/src/model/Circle.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Hole.dart';

class Crab extends Circle{

  int _id;
  static List<Crab> _created = new List<Crab>();
  final Random _random = new Random();
  Timer _timer;
  int _updates;
  double _x_random;
  double _y_random;

  //Creates a new object of the class Crab.
  Crab(int radius, Position currentPosition, MotionController motionController) : super(radius, currentPosition, true, "Crab", motionController) {
    this._id = _created.length;
    _created.add(this);
  }

  //Factory method to return an object of the class Crab.
  factory Crab.fromId(int id, int radius, Position currentPosition, MotionController motionController) {
    var existing;
    if(_created.length < id) existing = _created.elementAt(id);
    if(existing != null) {
      existing.setRadius = radius ;
      existing.currentPosition = currentPosition;
      existing.setMotionController = motionController;
    } else {
      existing = new Crab(radius, currentPosition, motionController);
    }
    return existing;
  }

  //Cancel the simulation of the movement of the crab after the explosion.
  void cancelSimulateExplosionMotion() {
    if (this._timer != null) {
      this._timer.cancel();
      this._timer = null;
    }
  }

  //Updates the x-coordinate and the y-coordinate of the currentPosition.
  void updatePosition(double x, double y){
    this.currentPosition.X = x;
    this.currentPosition.Y = y;

    if (this.top < 1) this.currentPosition.y = this.radius.roundToDouble();
    if (this.bottom > this.motionController.model.controller.view.height - 1) this.currentPosition.y = this.motionController.model.controller.view.height - 1 - this.radius.roundToDouble();

    if (this.left < 1) this.currentPosition.x = this.radius.roundToDouble();
    if (this.right > this.motionController.model.controller.view.width - 1) this.currentPosition.x = this.motionController.model.controller.view.width - 1 - this.radius.roundToDouble();
  }

  //Updates the x-coordinate of the currentPosition.
  void updatePositionOnlyX(double x){
    this.currentPosition.X = x;

    if (this.top < 1) this.currentPosition.y = this.radius.roundToDouble();
    if (this.bottom > this.motionController.model.controller.view.height - 1) this.currentPosition.y = this.motionController.model.controller.view.height - 1 - this.radius.roundToDouble();

    if (this.left < 1) this.currentPosition.x = this.radius.roundToDouble();
    if (this.right > this.motionController.model.controller.view.width - 1) this.currentPosition.x = this.motionController.model.controller.view.width - 1 - this.radius.roundToDouble();
  }

  //Updates the x-coordinate and y-coordinate of the currentPosition.
  void updatePositionWithPosition(Position position) => this.currentPosition = position;

  //Updates the x-coordinate of the currentPosition.
  void updatePositionWithPositionOnlyX(Position position) => this.currentPosition.x = position.X;

  //Simulates the crab falling into the hole.
  void simulateHoleFall(Hole e){
        this.motionController.inverterActivated = false;
        this.updatePosition(e.currentPosition.X/5  - this.currentPosition.X/5 , e.currentPosition.Y/5 - this.currentPosition.Y/5);
        this.setRadius = ((this.radius / 1.000001).floor());
  }

  //Simulates the crab falling off the bridge.
  void simulateFallDown() {
      final Bridge bridge = this.motionController.getElement("Bridge", 1) as Bridge;
      this.motionController.inverterActivated = false;

      if (this.motionController.crabFallsDownLeft) {
        if (this.right >= bridge.positionBottomLeft.X) {
          this.updatePosition(-2, 0);
        } else {
          this.setRadius = ((this.radius / 1.000001).floor());

          this.updatePosition(2, 0);
        }
      } else {
        if (this.left <= bridge.positionTopRight.X) {
          this.updatePosition(2, 0);
        } else {
          this.setRadius = ((this.radius / 1.00000001).floor());

          this.updatePosition(-2, 0);
        }
      }
  }

  //Simulates the movement of the crab after the explosion.
  void simulateExplosionMotion(){
    this._updates = 500;
    if(this._timer != null) this._timer.cancel();
    this._timer = new Timer.periodic(new Duration(milliseconds: 20), (update) {
      _x_random = (_random.nextInt(9) - 4).toDouble();
      _y_random = (_random.nextInt(9) - 4).toDouble();
      this.motionController.updateCrabPosition(_x_random, _y_random);
      this._updates--;
      if(this._updates == 0) {
        this.motionController.crabExplodes = false;
        this.motionController.model..controller.blockControl = false;
        this._timer.cancel();
        this._timer = null;
      }
    });
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    return true;
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