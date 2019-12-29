class Position {

  double _x;
  double _y;

  //Creates a new object of the class Position.
  Position(this._x, this._y);

  //Required setter-methods
  double get X => this._x;
  double get Y => this._y;

  //Required setter-methods
  set x(double x) => this._x = x;
  set y(double y) => this._y = y;
  set X(double x) => this._x += x;
  set Y(double y) => this._y += y;

}