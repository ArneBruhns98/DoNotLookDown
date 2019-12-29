import 'dart:async';

class Wind {

  bool _enabled = false;
  bool _maximumReached = false;
  double _maxStrength;
  double _currentStrength = 0.0;
  double _growthFactor;
  int _timeBetweenChanges;
  String _directionEast;


  //Creates a new object of the class Wind.
  Wind(this._maxStrength, this._growthFactor, this._timeBetweenChanges, this._directionEast);

  //Required getter-methods
  double get currentStrength => this._currentStrength;
  bool get enabled => this._enabled;
  String get directionEast => this._directionEast;

  //Simulates wind.
  void simulateWindStrength(){
    if(this._maxStrength > 0.0) {
      new Timer.periodic(new Duration(seconds: this._timeBetweenChanges), (update) {

        this._enabled = true;

        if(!this._maximumReached) {
          this._currentStrength += this._directionEast == "true" ? this._growthFactor : (-1) * this._growthFactor;
          if(this._directionEast == "true" && this._currentStrength >= this._maxStrength) this._maximumReached = true;
          if(this._directionEast != "true" && this._currentStrength <= (-1) * this._maxStrength) this._maximumReached = true;
        } else {
          this._currentStrength -= this._directionEast == "true" ? this._growthFactor : (-1) * this._growthFactor;
        }

        if(this._currentStrength == 0) {
          this._currentStrength = 0.0;
          this._maximumReached = false;
        }
      });
    }
  }
}