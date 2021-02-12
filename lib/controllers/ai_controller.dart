import 'dart:math';

import 'package:get/get.dart';
import 'package:meta/meta.dart';

import 'package:roda_da_fortuna/controllers/game_controller.dart';
import 'package:roda_da_fortuna/repositories/letters.dart';

class AiController extends GetxController {
  int dificult = 0;
  AiController({
    @required this.dificult,
  });

  setDificult(int dif) {
    dificult = dif;
    update();
  }

  String get _randomLetter => letters[Random().nextInt(letters.length - 1)];

  String aiGuess() {
    if (dificult == 0) {
      var possibleLetter = _randomLetter;
      while (
          Get.find<GameController>().guessedLetters.contains(possibleLetter)) {
        possibleLetter = _randomLetter;
      }
      return possibleLetter;
    } else {
      final decision = Random().nextInt(100);
      print(decision.toString() + '---------------------');
      if ((dificult == 1 && decision > 30) ||
          (dificult == 2 && decision > 15)) {
        return _rightLetter();
      } else {
        return _wrongLetter();
      }
    }
  }

  String _rightLetter() {
    var possibleLetter;
    var hits = 0;
    while (hits == 0) {
      possibleLetter = _randomLetter;
      hits = 0;
      if (!Get.find<GameController>().guessedLetters.contains(possibleLetter)) {
        for (final word in Get.find<GameController>().selectedWords) {
          hits += word.hits(possibleLetter);
        }
        print('hits');
        print(hits);
      }
    }
    return possibleLetter;
  }

  String _wrongLetter() {
    var possibleLetter;
    var hits = 1;
    while (hits > 0) {
      possibleLetter = _randomLetter;
      hits = 0;
      if (!Get.find<GameController>().guessedLetters.contains(possibleLetter)) {
        for (final word in Get.find<GameController>().selectedWords) {
          hits += word.hits(possibleLetter);
        }
        print('hits');
        print(hits);
      }
    }
    return possibleLetter;
  }
}
