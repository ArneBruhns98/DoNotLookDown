import 'dart:html';


class Highscore {

  Storage _storage = window.localStorage;

  //Creates a new object of the class Highscore.
  Highscore();

  //Required getter-methods
  int get highscore => this._storage.containsKey("DoNotLookDownHighscore") ? int.parse(this._storage["DoNotLookDownHighscore"]) : 0;

  //Updates the personal highscore.
  void updateHighsore(int score){
    if(this.highscore < score) this._storage["DoNotLookDownHighscore"] = score.toString();
  }
}