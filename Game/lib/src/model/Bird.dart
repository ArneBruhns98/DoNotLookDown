import 'dart:math';
import 'dart:html';
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/MotionController.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Circle.dart';

class Bird extends Circle {

  int _id;
  static List<Bird> _created = new List<Bird>();
  final Random _random = new Random();
  bool _isLeft;
  bool _moveDownwards = false;
  bool _changeSide = false;
  String directionToLook = "north";

  //Creates a new object of the class Bird.
  Bird(int radius, Position currentPosition, MotionController motionController, bool isLeft) : super(radius, currentPosition, false, "Bird", motionController) {
    this._id = _created.length;
    _created.add(this);
    this._isLeft = isLeft;
  }

  //Factory method to return an object of the class Bird.
  factory Bird.fromId(int id, int radius, Position currentPosition, MotionController motionController, bool isLeft){
    var existing;
    if(_created.length < id) existing = _created.elementAt(id);
    if(existing != null) {
      existing.setRadius(radius);
      existing.currentPosition = currentPosition;
      existing.setMotionController = motionController;
    } else {
      existing = new Bird(radius, currentPosition, motionController, isLeft);
    }
    return existing;
  }

  //Simulate the movement of the object.
  void simulate(){
    int randomNum = _random.nextInt(250);
    if(!this._changeSide && (randomNum == 1) && (this.currentPosition.Y < (window.innerHeight - (this.radius * 3)))){
      this._changeSide = true;
    }
    if(this._changeSide){
      if(this._isLeft){
        this.directionToLook = "east";
        this.currentPosition.X = 10;
        if(this.currentPosition.X >= (window.innerWidth - this.radius)){
          this._isLeft = false;
          this._changeSide = false;
          this.currentPosition.x = (window.innerWidth - this.radius).toDouble();
        }
      } else {
        this.directionToLook = "west";
        this.currentPosition.X = -10;
        if (this.currentPosition.X <= this.radius) {
          this._isLeft = true;
          this._changeSide = false;
          this.currentPosition.x = this.radius.toDouble();
        }
      }
    } else {
      if(this._moveDownwards){
        this.directionToLook = "south";
        if(this.currentPosition.Y < window.innerHeight - this.radius){
          this.currentPosition.Y = 5;
        } else{
          this._moveDownwards = false;
        }
      } else{
        this.directionToLook = "north";
        if(this.currentPosition.Y > this.radius){
          this.currentPosition.Y = -5;
        } else {
          this._moveDownwards = true;
        }
      }
    }
  }

  @override
  bool checkCollisionToCrab(Crab crab) {
    if(sqrt(pow(crab.currentPosition.X - this.currentPosition.X, 2) + pow(crab.currentPosition.Y - this.currentPosition.Y, 2)) < this.radius) {
      this.motionController.crab.cancelSimulateExplosionMotion();
      this.motionController.crabExplodes = false;
      return true;
    } else{
      return false;
    }
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