import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:DoNotLookDown/src/DoNotLookDownView.dart';
import 'package:DoNotLookDown/src/model/DoNotLookDownModel.dart';
import 'package:DoNotLookDown/src/model/EvilCrab.dart';
import 'package:DoNotLookDown/src/model/Bird.dart';
import 'package:DoNotLookDown/src/model/Position.dart';


class DoNotLookDownController {

  DoNotLookDownView _view;
  DoNotLookDownModel _model;

  bool _mobile = false;
  bool _isClicked = false;
  bool _gameStarted = false;
  bool _blockedControl = false;
  bool _crabConfused = false;
  bool _countdownIsON = false;
  bool _viewWarningEnabled = false;
  double _defaultBeta;
  int _betaCounter = 0;
  Timer _timerCountdown;
  double _x = 0.0;
  double _y = 0.0;
  bool crabTouchedTNT = false;


  //Constructor Controller
  DoNotLookDownController() {
    this._view = new DoNotLookDownView(this);
    this._model = new DoNotLookDownModel(this);
    this._view.model = this._model;
    this._deviceCheckOnStart();
    this._viewCheck();
  }

  get mobile => this._mobile;
  get countdownIsON => this._countdownIsON;
  get view => this._view;
  set blockControl(bool b) => this._blockedControl = b;


  //Checks the Device, sets "mobile" and decides the startscreen Artwork.
  void _deviceCheckOnStart(){
    if (window.orientation != null){
      this._mobile = true;
      this._view.start.style.backgroundImage = "url(./img/startMobile.gif)";
      this._view.start.onClick.listen((ev){
        if(!this._gameStarted && !this._viewWarningEnabled){
          this._gameStarted = true;
          this._newGame();
        }
      });
    } else {
      this._mobile = false;
      this._view.start.style.backgroundImage = "url(./img/startPC.gif)";
      window.onKeyDown.listen((KeyboardEvent ev) {
        if(!this._gameStarted && !this._viewWarningEnabled){
          if(ev.keyCode == KeyCode.SPACE){
              this._gameStarted = true;
              this._newGame();
          }
        }
      });
    }
  }

  //Starts one of your possible control-setups and starts a heartbeat for the view
  Future _newGame() async {
    await this._model.createElements(this._mobile);
    if(this._mobile == true) {this._activateMobileControl();}
    else {this._activateDesktopControl();}

    new Timer.periodic(new Duration(milliseconds: 20), (update) {
      this._handleCrabConditionShock();
      this._handleCrabConditionFalling();
      if(!this._mobile && !this._blockedControl) this._simulateDesktopControl();
      if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine && !this._viewWarningEnabled) this._simulateEnemies();

      try {
        if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine){
          this._view.update();
        }
      } catch (Exception) {
        print("Elemente wurden noch nicht generiert.");
      }
    });
  }

  //Simulation of the Crabmovement (PC)
  void _simulateDesktopControl(){
    if(!this._model.motionController.crabExplodes && !this._viewWarningEnabled) {
      if(!this._model.motionController.inverterActivated) {this._model.updateCrabPosition(this._x, this._y);}
      else {this._model.updateCrabPosition((-1) * this._x, (-1) * this._y);}
    } else {
      this._x = 0.0;
      this._y = 0.0;
    }
  }

  //Mobile Control
  void _activateMobileControl() {
    this._countdown();
    window.onDeviceOrientation.listen((DeviceOrientationEvent ev) {
      if(this._countdownIsON){
        this._defaultBeta += ev.beta;
        this._betaCounter++;
      }
      if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine && !this._blockedControl && !this._countdownIsON && !this._viewWarningEnabled){
        if (ev.alpha != null && ev.beta != null && ev.gamma != null) {
          final dy = min(_defaultBeta + 3, max(_defaultBeta - 3, ev.beta)) - _defaultBeta;
          final dx = min(3, max( -3, ev.gamma));
          if (!this._model.motionController.inverterActivated){ this._model.updateCrabPosition(dx, dy);}
          else {this._model.updateCrabPosition((-1) * dx, (-1) * dy);}
        }
      }
    });
  }

  //Desktop Control
  void _activateDesktopControl(){
    this._countdown();
    window.onMouseDown.listen((MouseEvent ev) {
      if(!this._blockedControl && !this._countdownIsON && !this._viewWarningEnabled) {
        if(!this._model.motionController.isGameOver && !this._model.motionController.crabTouchesLine) {
          if(this._x == 0 && this._y == 0) {
            Position crabPosition = this._model.motionController.crab.currentPosition;
            double vectorLength = sqrt(pow(ev.client.x.abs() - crabPosition.X.abs(), 2) + pow(ev.client.y.abs() - crabPosition.Y.abs() , 2));;
            this._x = ((3.0 / vectorLength) * (ev.client.x - crabPosition.X));
            this._y = ((3.0 / vectorLength) * (ev.client.y - crabPosition.Y));
          } else {
            this._x = 0.0;
            this._y = 0.0;
          }
        }
      }
    });
  }

  //GameOver Handler
  void gameOver(){
    this._x = 0.0;
    this._y = 0.0;
    this._blockedControl = true;
    this._isClicked = false;
    this._view.showGameOver();
    this._view.gameOver.onClick.listen((ev){
      if (!this._isClicked) {
        this._model.level = 1;
        this._isClicked = true;
        this._model.createElements(this._mobile);
      }
    });
  }

  //The Screen between different levels.
  void newLevel(){
    this._x = 0.0;
    this._y = 0.0;
    this._blockedControl = true;
    this._isClicked = false;
    this._model.highscore.updateHighsore(this._model.level);
    this._view.showNextLevel();
    this._model.updateLevel();
    this._view.nextLevel.onClick.listen((ev){
      if (!this._isClicked) {
        this._isClicked = true;
        this._model.createElements(this._mobile);
      }
    });
  }

  //The Screen between different levels.
  void restartLevel(){
    this._x = 0.0;
    this._y = 0.0;
    this._blockedControl = true;
    this._isClicked = false;
    this._view.showRestartLevel();
    this._model.restartLevel();
    this._view.nextLevel.onClick.listen((ev){
      if (!this._isClicked) {
        this._isClicked = true;
        this._model.createElements(this._mobile);
      }
    });
  }

  //Check the dimensions of the View and throw Alert in case of wrong usage
  void _viewCheck(){
    new Timer.periodic(new Duration(microseconds: 50), (update){
      //Mobile-Viewcheck
      if(window.orientation != null){
        if(window.innerHeight < window.innerWidth){
          this._view.showViewWarning(true);
          this._viewWarningEnabled = true;
        }
        else {
          this._view.showViewWarning(false);
          this._viewWarningEnabled = false;
        }
      }
      //PC ViewCheck
      else{
        if(window.innerWidth < window.screen.width || window.innerHeight <= window.screen.height * 0.75){
          this._view.showViewWarning(true);
          this._viewWarningEnabled = true;
        }
        else {
          this._view.showViewWarning(false);
          this._viewWarningEnabled = false;
        }
      }
    });
  }

  //Simulation of auto. enemy behaviour
  void _simulateEnemies(){
    //EvilCrab
    int numberOfEvils = this._model.motionController.numberOfElements("EvilCrab");
    if(numberOfEvils != 0){
      for(int i = 1; i <= numberOfEvils; i++ ){
        EvilCrab e = this._model.motionController.getElement("EvilCrab", i);
        e.simulate(this._model.motionController.getElement("Bridge", 1));
        this._model.motionController.checkCollisionEvilCrab(e);
      }
    }
    //Bird
    int numberOfBirds = this._model.motionController.numberOfElements("Bird");
    if(numberOfBirds != 0){
      for(int i = 1; i <= numberOfBirds; i++ ){
        Bird b = this._model.motionController.getElement("Bird", i);
        b.simulate();
        this._model.motionController.checkCollisionBird(b);
      }
    }
  }

  //Crab Confused Handler
  void _handleCrabConditionShock(){
    if(this._crabConfused == false && (this._model.motionController.crabExplodes == true || this._model.motionController.inverterActivated == true)){
      this._view.confusedCrab(true);
      this._crabConfused = true;
    }
    if(this._crabConfused == true && (this._model.motionController.crabExplodes == false && this._model.motionController.inverterActivated == false)){
      this._view.confusedCrab(false);
      this._crabConfused = false;
    }
  }

  //Crab Falling Handler
  void _handleCrabConditionFalling(){
    if(this._model.motionController.crabFallsDown || this._model.motionController.crabExplodes) {
      this._blockedControl = true;
      if (this._model.motionController.crab.radius <= 0) {
        this._model.motionController.isGameOver = true;
        this._model.motionController.fallHole = false;
        this.gameOver();
      }
      if (this._model.motionController.fallHole) this._model.motionController.crab.simulateHoleFall(this._model.motionController.holeToFall);
      else if (this._model.motionController.crabFallsDown) this._model.motionController.crab.simulateFallDown();
    }
  }

  //Generation of our Level. Connection btwn. View and Model
  void generate(){
    this._view.generateField();
    this._model.motionController.isGameOver = false;
    this._model.motionController.crabFallsDown = false;
    this._model.motionController.fallHole = false;
    this._model.motionController.crabTouchesLine = false;
    this._model.motionController.inverterActivated = false;
    this._blockedControl = false;
    if(!this._countdownIsON) this._model.motionController.wind.simulateWindStrength();
  }

  //Dark Level handler
  void showDarkLevel(bool status){
    if(status == true){
      this._view.showDarkLevel();
      this._view.crab.style.zIndex = "7";
    }
    else{
      this._view.crab.style.zIndex = "3";
    }
  }

  //Function for a Countdown at the beginning of our Game.
  void _countdown() {
      int countdown = 3;
      this._countdownIsON = true;
      this._betaCounter = 0;
      this._defaultBeta = 0.0;

      this._timerCountdown = new Timer.periodic(new Duration(seconds: 1), (update) {
        if (countdown == 0) {
          this._countdownIsON = false;
          this._defaultBeta /= this._betaCounter;
          this._timerCountdown.cancel();
        } else {
          this._view.showCountdown(this._mobile, countdown--);
        }
      });
  }
}