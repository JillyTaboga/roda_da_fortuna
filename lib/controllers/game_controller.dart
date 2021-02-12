import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roda_da_fortuna/controllers/ai_controller.dart';
import 'package:roda_da_fortuna/controllers/sound_controller.dart';
import 'package:roda_da_fortuna/gui/screens/config_screen.dart';
import 'package:roda_da_fortuna/repositories/points.dart';
import 'package:roda_da_fortuna/repositories/records.dart';
import 'package:roda_da_fortuna/repositories/words.dart';

enum GamePhase { SPIN, GUESS, CONFIRM, WORD }

class GameController extends GetxController {
  @override
  onInit() {
    super.onInit();
  }

  GameController.solo(String name) {
    players = [Player.human(1, name: name)];
    solo = true;
    newGame();
  }

  GameController.normal({
    @required int humanPlayers,
    @required List<String> nameOfPlayers,
  }) {
    solo = false;
    switch (humanPlayers) {
      case 1:
        _onePlayer(nameOfPlayers[0]);
        break;
      case 2:
        _twoPlayers(nameOfPlayers);
        break;
      case 3:
        _treePlayers(nameOfPlayers);
        break;
      default:
    }
    newGame();
  }

  int turnTime = 1;
  GamePhase phase;
  List<Player> players;
  List<Words> selectedWords;
  String category;
  List<String> guessedLetters = [];
  bool autoSpin = false;
  bool solo;
  int game = 0;

  SpinStateScreen get screenState {
    switch (phase) {
      case GamePhase.CONFIRM:
        return SpinStateScreen.chars();
        break;
      case GamePhase.SPIN:
        return SpinStateScreen.wheel();
        break;
      case GamePhase.GUESS:
        return SpinStateScreen.words();
        break;
      case GamePhase.WORD:
        return SpinStateScreen.words();
        break;
      default:
        return SpinStateScreen.chars();
    }
  }

  bool get aiTurn => players[turnTime - 1].ai;

  int get missingLetters {
    var missing = 0;
    for (final word in selectedWords) {
      missing += word.missingLetters;
    }
    return missing;
  }

  _snackBar(String title, String content) {
    Get.snackbar(
      title,
      content,
      borderColor: Colors.orange,
      borderWidth: 2,
      backgroundColor: Colors.white,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black,
    );
  }

  confirm() {
    phase = GamePhase.SPIN;
    if (aiTurn) {
      autoSpin = true;
    } else {
      autoSpin = false;
    }
    update();
  }

  _getCategory() {
    category = categories[Random().nextInt(categories.length)];
    update();
  }

  Words _selectWord() {
    final wordsOfCategory = words
        .where((element) => element.categories.contains(category))
        .toList();
    return wordsOfCategory[Random().nextInt(wordsOfCategory.length)];
  }

  _getWords() {
    selectedWords = [];
    for (var n = 0; n < 3; n++) {
      var possibleWord = _selectWord();
      while (selectedWords.contains(possibleWord)) {
        possibleWord = _selectWord();
      }
      selectedWords.add(possibleWord);
    }
    update();
  }

  nextTurn() {
    if (turnTime < 3) {
      turnTime++;
    } else {
      turnTime = 1;
    }
    phase = GamePhase.CONFIRM;
    update();
  }

  guessLetter({
    @required String letter,
    @required double value,
  }) async {
    guessedLetters.add(letter);
    var totalHits = 0;
    for (final word in selectedWords) {
      totalHits += word.hits(letter);
    }
    if (totalHits > 0) {
      _hited(
        value: value,
        totalHits: totalHits,
        letter: letter,
      );
    } else {
      _missed(
        letter: letter,
        value: value,
      );
    }
  }

  _hited({
    @required double value,
    @required int totalHits,
    @required String letter,
  }) async {
    Get.find<SoundController>().playSuccess();
    _snackBar(
        'Acertou!',
        totalHits.toStringAsFixed(0) +
            ' - Letra $letter - ' +
            (totalHits * value).toStringAsFixed(0) +
            ' pontos!');
    Get.find<PointsRepositories>().addPoints(
      place: turnTime,
      points: (value * totalHits).floor(),
    );
    await Future.delayed(Duration(milliseconds: 500));
    if (missingLetters > 0) {
      phase = GamePhase.SPIN;
      if (aiTurn) autoSpin = true;
      update();
    } else {
      newGame();
    }
  }

  _missed({
    @required String letter,
    @required double value,
  }) {
    Get.find<SoundController>().playError();
    if (solo) {
      Get.find<PointsRepositories>().addPoints(
        place: turnTime,
        points: (-value).floor(),
      );
      _snackBar(
        'Errou!',
        'Letra $letter - Perdeu ${value.toStringAsFixed(0)} pontos...',
      );
      phase = GamePhase.SPIN;
      update();
    } else {
      _snackBar(
        'Errou!',
        'Letra $letter - E passou a vez...',
      );
      nextTurn();
    }
  }

  newGame() {
    if (game == 3 && !solo) {
      Get.dialog(
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Parabéns!!!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  players[Get.find<PointsRepositories>().playerWin].name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  'Você foi o ganhador dessa partida',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!players[Get.find<PointsRepositories>().playerWin].ai) {
                      Get.find<RecordsRespositories>().saveRecord(
                          type: players.any((element) => element.ai)
                              ? Get.find<AiController>().dificult == 0
                                  ? GameType.EASY
                                  : Get.find<AiController>().dificult == 1
                                      ? GameType.NORMAL
                                      : Get.find<AiController>().dificult == 3
                                          ? GameType.HARD
                                          : GameType.NORMAL
                              : GameType.NORMAL,
                          name:
                              players[Get.find<PointsRepositories>().playerWin]
                                  .name,
                          points: Get.find<PointsRepositories>().points(
                              Get.find<PointsRepositories>().playerWin + 1));
                    }
                    Get.offAll(ConfigScreen());
                  },
                  child: Text(
                    'Demais!',
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      game++;
      guessedLetters = [];
      _getCategory();
      _getWords();
      turnTime = solo ? 1 : Random().nextInt(3) + 1;
      phase = GamePhase.CONFIRM;
      update();
    }
  }

  spinReturn(double value) async {
    print(value);
    autoSpin = false;
    if (value == 0) {
      if (solo) {
        Get.find<PointsRepositories>().addPoints(place: 1, points: -1000);
        _snackBar('Passou!', 'Perdeu 1000 pontos...');
      } else {
        _snackBar('Passou!', 'Mais sorte na próxima');
        nextTurn();
      }
    } else if (value == -1) {
      if (solo) {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: Colors.orange,
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fim de Jogo',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    Get.find<PointsRepositories>()
                        .place1Points
                        .toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    'Total de pontos conseguidos',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.find<RecordsRespositories>().saveRecord(
                        type: GameType.SOLO,
                        name: players[0].name,
                        points: Get.find<PointsRepositories>().place1Points,
                      );
                      Get.offAll(ConfigScreen());
                    },
                    child: Text(
                      'Salvar',
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.find<PointsRepositories>().resetPoints(turnTime);
        Get.find<SoundController>().playError();
        _snackBar('Olha a bruxa!', 'Perdeu tudo!');
        nextTurn();
      }
    } else {
      phase = GamePhase.GUESS;
      update();
      if (aiTurn) {
        await Future.delayed(Duration(milliseconds: 1000));
        guessLetter(
          letter: Get.find<AiController>().aiGuess(),
          value: value,
        );
      }
    }
  }

  _onePlayer(String name) {
    players = [
      Player.ai(1),
      Player.human(2, name: name),
      Player.ai(3),
    ];
    update();
  }

  _twoPlayers(List<String> names) {
    players = [
      Player.human(1, name: names[0]),
      Player.human(2, name: names[1]),
      Player.ai(3),
    ];
    update();
  }

  _treePlayers(List<String> names) {
    players = [
      Player.human(1, name: names[0]),
      Player.human(2, name: names[1]),
      Player.human(3, name: names[2]),
    ];
    update();
  }
}

class Player {
  String name;
  int position;
  bool ai;

  Color get color {
    switch (position) {
      case 1:
        return Colors.blue;
        break;
      case 2:
        return Colors.red;
        break;
      case 3:
        return Colors.yellow;
        break;
      default:
        return null;
    }
  }

  Player({
    @required this.name,
    @required this.position,
    @required this.ai,
  });
  Player.human(int place, {this.name}) {
    if (name == null) this.name = 'Jogador $place';
    position = place;
    ai = false;
  }
  Player.ai(int place) {
    name = 'Computador $place';
    position = place;
    ai = true;
  }
}

class SpinStateScreen {
  double wordsTop;
  double charsTop;
  double wheelBottom;

  double get width {
    return Get.height - (Get.height / 4);
    // if (Get.width > Get.height / 2) {
    //   return Get.height / 2;
    // } else if (Get.width > 600) {
    //   return 600;
    // } else {
    //   return Get.width;
    // }
  }

  SpinStateScreen.wheel() {
    wordsTop = 0;
    charsTop = Get.height / 3;
    wheelBottom = width;
  }
  SpinStateScreen.chars() {
    wordsTop = 0;
    charsTop = Get.height / 3;
    wheelBottom = width;
  }
  SpinStateScreen.words() {
    wordsTop = 0;
    charsTop = Get.height / 2;
    wheelBottom = width;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SpinStateScreen &&
        o.wordsTop == wordsTop &&
        o.charsTop == charsTop &&
        o.wheelBottom == wheelBottom;
  }

  @override
  int get hashCode =>
      wordsTop.hashCode ^ charsTop.hashCode ^ wheelBottom.hashCode;
}
