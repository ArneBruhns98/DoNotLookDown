import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'package:DoNotLookDown/src/model/Bridge.dart';
import 'package:DoNotLookDown/src/model/Crab.dart';
import 'package:DoNotLookDown/src/model/DoNotLookDownModel.dart';
import 'package:DoNotLookDown/src/model/EvilCrab.dart';
import 'package:DoNotLookDown/src/model/Finishline.dart';
import 'package:DoNotLookDown/src/model/Hole.dart';
import 'package:DoNotLookDown/src/model/Stone.dart';
import 'package:DoNotLookDown/src/model/TNTBox.dart';
import 'package:DoNotLookDown/src/model/Tile.dart';
import 'package:DoNotLookDown/src/model/Wind.dart';
import 'package:DoNotLookDown/src/model/Inverter.dart';
import 'package:DoNotLookDown/src/model/Element.dart';
import 'package:DoNotLookDown/src/model/Position.dart';
import 'package:DoNotLookDown/src/model/Wood.dart';
import 'package:DoNotLookDown/src/model/Bird.dart';

class LevelGenerator {

  DoNotLookDownModel _model;
  final double FECR = 1.5; //Factor exclusive crab radius
  final double FICR = 2.5; //Factor inclusive crab radius
  final double FR = 0.75; //Factor for the height and width of the rectangles.

  Bridge _bridgeBottom;
  Bridge _bridgeTop;
  int _tileLength;
  int _bridgeWidth;
  int _bridgeHeight;

  String _pathLevel;
  HttpRequest _request;
  Element _element;
  Map<int, List<Tile>> _occupancyMatrix;
  Storage _storage = window.localStorage;
  final Random _random = new Random();

  //Creates a new object of the class LevelGenerator.
  LevelGenerator(this._model);

  //Make a request to the server to load a level file from the server.
  Future<bool> makeRequest(int level, bool mobil) async {
    this._request = new HttpRequest();
    this._pathLevel = './doc/level${level}.json';

    this._request
      ..open('GET', this._pathLevel)
      ..onLoadEnd.listen((e) async => await _requestComplete(this._request, mobil, level))
      ..send('');

    return true;
  }

  //Handles the response from the server.
  void _requestComplete(HttpRequest request, bool mobil, int level) {
    switch (request.status) {
      case 200:
        this._generateLevel(request.responseText, mobil);
        this._storage["DoNotLookDownLevel${level}"] = request.responseText;
        return;
      default: //Leveldatei aus dem Localstorage holen und diese dann verarbeiten.
        try {
          if(this._storage["DoNotLookDownLevel${level}"].isNotEmpty)this._generateLevel(this._storage["DoNotLookDownLevel${level}"], mobil);
        } catch (Exception) {
          print("Hist ist echt etwas schief gelaufen.");
          this._model.controller.restartLevel();
        }
        return;
    }
  }

  //Generates a new level by using the json-level-files.
  void _generateLevel(String response, bool mobil) {
    this._model.motionController.initializeEmptyMap();
    this._model.controller.view.removeChildrens();

    String type;
    int count;
    List<String> listOfResponse = this._transformString(response);

    listOfResponse[0].split(":")[1].trim() == "true" ? this._model.nextLevel = true : this._model.nextLevel = false;

    if(listOfResponse[1].split(":")[1].trim() == "true") this._model.controller.showDarkLevel(true);
    else this._model.controller.showDarkLevel(false);

    this._generateBasicElements(int.parse(listOfResponse[2].split(":")[1]), mobil);
    this._occupancyMatrix = this._generateOccupancyMatrix();

    for(int i = 2; i < listOfResponse.length - 1; i++) {
      type = listOfResponse[i].split(":")[0].trim();
      count = int.parse(listOfResponse[i].split(":")[1].trim());
      switch(type){
        case "EvilCrab":
          this._generateElements(type, count);
          continue;

        case "Hole":
          this._generateElements(type, count);
          continue;

        case "Bird":
          this._generateElements(type, count);
          continue;

        case "Stone":
          this._generateElements(type, count);
          continue;

        case "Wood":
          this._generateElements(type, count);
          continue;

        case "TNTBox":
          this._generateElements(type, count);
          continue;

        case "Inverter":
          this._generateElements(type, count);
          continue;
      }
    }

    List<String> windValues = listOfResponse.last.split(" ");
    this._model.motionController.wind = new Wind(double.parse(windValues[1]), double.parse(windValues[2]), int.parse(windValues[3]), windValues[4]);

    this._model.controller.generate();
  }

  //Transform the json-string in a valid list.
  List<String> _transformString(String response){
    List<String> list = List.of(response.replaceAll("{", "").replaceAll("}", "").replaceAll(",", "").replaceAll("[", "").replaceAll("]", "").replaceAll("\"", "")
        .replaceAll(" (Length)", "").replaceAll(" (Number)", "").replaceAll(" (Max Strength Growth Factor Time Between Changes Direction East)", "")
        .split("\n"));
    list.removeAt(0);
    list.removeLast();
    return list.map((value) => value.trim()).toList();
  }

  //Generates the basic elements.
  void _generateBasicElements(int bridgeLength, bool mobil){
    if(mobil) {
      for(int i = 1; i <= bridgeLength; i++) {
        this._element = new Bridge.fromId(i - 1,
            new Position(window.innerWidth / 5, window.innerHeight.floorToDouble() * (i - bridgeLength + 1)),
            new Position(4 * window.innerWidth / 5, window.innerHeight.floorToDouble() * (i - bridgeLength + 1)),
            new Position(window.innerWidth / 5, window.innerHeight.floorToDouble() * (i - bridgeLength)),
            new Position(4 * window.innerWidth / 5, window.innerHeight.floorToDouble() * (i - bridgeLength)),
            null,
            0,
            this._model.motionController);
        this._registerElement();
      }

      this._element = new Finishline.fromId(0,
          new Position(window.innerWidth / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength) + window.innerHeight / 40),
          new Position(4 * window.innerWidth / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength) + window.innerHeight / 40),
          new Position(window.innerWidth / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength)),
          new Position(4 * window.innerWidth / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength)),
          null,
          0,
          this._model.motionController);
      this._registerElement();
    } else {
      for(int i = 1; i <= bridgeLength; i++) {
        this._element = new Bridge.fromId(i - 1,
            new Position(2 * window.screen.width / 5, window.innerHeight.floorToDouble() * (i - bridgeLength + 1)),
            new Position(3 * window.screen.width / 5, window.innerHeight.floorToDouble() * (i - bridgeLength + 1)),
            new Position(2 * window.screen.width / 5, window.innerHeight.floorToDouble() * (i - bridgeLength)),
            new Position(3 * window.screen.width / 5, window.innerHeight.floorToDouble() * (i - bridgeLength)),
            null,
            0,
            this._model.motionController);
        this._registerElement();
      }

      this._element = new Finishline.fromId(0,
          new Position(2 * window.screen.width / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength) + window.screen.height / 40),
          new Position(3 * window.screen.width / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength) + window.screen.height / 40),
          new Position(2 * window.screen.width / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength)),
          new Position(3 * window.screen.width / 5, window.innerHeight.floorToDouble() * (1 - bridgeLength)),
          null,
          0,
          this._model.motionController);
      this._registerElement();
    }

    //Got to set the values here bc of the crab, which scales with our tiles
    this._bridgeTop = this._model.motionController.getElement("Bridge", 1);
    this._bridgeBottom = this._model.motionController.getElement("Bridge", bridgeLength);
    this._bridgeWidth = (this._bridgeTop.positionTopRight.X - this._bridgeTop.positionTopLeft.X).floor();
    this._bridgeHeight = (this._bridgeBottom.positionBottomRight.Y - this._bridgeTop.positionTopRight.Y).floor();
    this._tileLength = (this._bridgeWidth / 5).floor();

    this._element= new Crab.fromId(0,  (this._tileLength / 2).floor(), new Position((_model.controller.view.center_x), (_model.controller.view.botton_y_max.floor() - (_model.controller.view.size / 30))), this._model.motionController);
    this._model.motionController.crab = this._element;
  }


  //Generates a new object of the Class Circle.
  void _generateElements(String type, int count) {
    Tile tile;
    int x_random;
    int y_random;

    for(int i = 0; i < count; i++){
      for(int j = 0; j < 30; j++) {
        x_random = _random.nextInt(this._occupancyMatrix[0].length);
        y_random = _random.nextInt(this._occupancyMatrix.length);

        tile = this._occupancyMatrix[y_random][x_random];

        if(!tile.occupied || type == "Bird") {
          switch (type) {
            case "EvilCrab":
              this._element = new EvilCrab.fromId(0, (tile.size / 2).floor(),
                  tile.center,
                  this._model.motionController);
              this._registerElement();
              break;

            case "Hole":
              this._element = new Hole.fromId(0, (tile.size / 2).floor(),
                  tile.center,
                  this._model.motionController);
              this._registerElement();
              break;

            case "Bird":
              int birdRandom = _random.nextInt(2);
              int birdRandom2 = _random.nextInt((window.innerHeight - tile.size).floor()) + ((tile.size / 2).floor()) ;

              if(birdRandom == 0){
                this._element = new Bird.fromId(0, (tile.size / 2).floor(),
                    new Position((window.innerWidth - (tile.size / 2)), birdRandom2.toDouble()),
                    this._model.motionController, false);
              } else{
                this._element = new Bird.fromId(0, (tile.size / 2).floor(),
                    new Position((tile.size / 2), birdRandom2.toDouble()),
                    this._model.motionController, true);
              }
              this._registerElement();
              break;

            case "Stone":
              this._element = new Stone.fromId(0, (tile.size / 2).floor(),
                  tile.center,
                  this._model.motionController);
              this._registerElement();
              break;

            case "Wood":
              this._element = new Wood.fromId(
                  0,
                  new Position(tile.center.X + (-FR) * tile.size / 2, tile.center.Y + FR * tile.size / 2),
                  new Position(tile.center.X + FR * tile.size / 2, tile.center.Y + FR * tile.size / 2),
                  new Position(tile.center.X + (-FR) * tile.size / 2, tile.center.Y + (-FR) * tile.size / 2),
                  new Position(tile.center.X + FR * tile.size / 2, tile.center.Y + (-FR) * tile.size / 2),
                  tile.center, sqrt(pow(tile.center.X - (tile.center.X + FR * tile.size / 2), 2) + pow(tile.center.Y - (tile.center.Y + FR * tile.size / 2), 2)).floor(),
                  this._model.motionController);
              this._registerElement();
              break;

            case "TNTBox":
              this._element = new TNTBox.fromId(
                  0,
                  new Position(tile.center.X + (-FR) * tile.size / 2,
                      tile.center.Y + FR * tile.size / 2),
                  new Position(tile.center.X + FR * tile.size / 2,
                      tile.center.Y + FR * tile.size / 2),
                  new Position(tile.center.X + (-FR) * tile.size / 2,
                      tile.center.Y + (-FR) * tile.size / 2),
                  new Position(tile.center.X + FR * tile.size / 2,
                      tile.center.Y + (-FR) * tile.size / 2),
                  tile.center,
                  sqrt(pow(tile.center.X -
                      (tile.center.X + FR * tile.size / 2), 2) + pow(
                      tile.center.Y -
                          (tile.center.Y + FR * tile.size / 2), 2)).floor(),
                  this._model.motionController);
              this._registerElement();
              break;

            case "Inverter":
              this._element = new Inverter.fromId(
                  0,
                  new Position(tile.center.X + (-FR) * tile.size / 2,
                      tile.center.Y + FR * tile.size / 2),
                  new Position(tile.center.X + FR * tile.size / 2,
                      tile.center.Y + FR * tile.size / 2),
                  new Position(tile.center.X + (-FR) * tile.size / 2,
                      tile.center.Y + (-FR) * tile.size / 2),
                  new Position(tile.center.X + FR * tile.size / 2,
                      tile.center.Y + (-FR) * tile.size / 2),
                  tile.center,
                  sqrt(pow(tile.center.X -
                      (tile.center.X + FR * tile.size / 2), 2) + pow(
                      tile.center.Y -
                          (tile.center.Y + FR * tile.size / 2), 2)).floor(),
                  this._model.motionController);
              this._registerElement();
              break;
          }

          if (type == "EvilCrab") tile.reservateEvilCrabArea(this._occupancyMatrix, x_random, y_random);
          else tile.reservateArea(this._occupancyMatrix, x_random, y_random);

          break;
        }
      }
    }
  }


  //Generate the occupancy matrix.
  Map<int, List<Tile>> _generateOccupancyMatrix() {
    Map<int, List<Tile>> map = new Map<int, List<Tile>>();
    List<Tile> list = new List<Tile>();
    int tilesPerRow = 5;
    int tilesPerColumn = (this._bridgeHeight / this._tileLength).floor();
    double tempTileCenterX = (this._bridgeTop.positionTopLeft.X + this._tileLength / 2);
    double tempTileCenterY = (this._bridgeTop.positionTopLeft.Y + this._tileLength / 2);

    for(int i = 0; i < tilesPerColumn; i++) {
      list = new List<Tile>();
      for(int j = 0; j < tilesPerRow; j++) {
        Tile tileToInsert = new Tile(new Position(tempTileCenterX , tempTileCenterY), this._tileLength.toDouble());
        //Reservate Start/Goalzones
        if(i == 0 || i >= tilesPerColumn - 1) tileToInsert.occupied = true;
        list.add(tileToInsert);
        tempTileCenterX = tempTileCenterX + this._tileLength;
      }
      tempTileCenterX = (this._bridgeTop.positionTopLeft.X + this._tileLength / 2);
      tempTileCenterY = tempTileCenterY + this._tileLength;
      map.putIfAbsent(i, () => list);
    }

    return map;
  }

  //Passes a generated element to the MotionController
  void _registerElement() => this._model.motionController.fillMap(this._element);

}