import 'package:DoNotLookDown/src/model/Position.dart';

class Tile {

  Position _center;
  double _size;
  bool _occupied = false;

  //Creates a new object of the class Tile.
  Tile(this._center, this._size);

  //Required getter-methods
  Position get center => this._center;
  double get size => this._size;
  bool get occupied => this._occupied;

  //Required setter-methods
  set occupied(bool b) => this._occupied = b;

  //Reserved for an obstacle an occupancy in the occupancy matrix.
  void reservateArea(Map<int, List<Tile>> map, int col, int row){
    for(int i = row - 1; i <= row + 1; i++) {
      for(int j = col - 1; j <= col + 1; j++) {
        try{
          map[i][j].occupied = true;
        } catch(Exception) {
          continue;
        }
      }
    }
  }

  //Reserved for an EvilCrab an occupancy in the occupancy matrix.
  void reservateEvilCrabArea(Map<int, List<Tile>> map, int col, int row){
    for(int i = 0; i <= map[col].length + 1; i++) {
      try {
        map[row][i].occupied = true;
      } catch(Exception) {
        continue;
      }
    }
  }
}