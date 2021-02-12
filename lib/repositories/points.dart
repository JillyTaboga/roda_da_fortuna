import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PointsRepositories extends GetxController {
  int place1Points = 0;
  int place2Points = 0;
  int place3Points = 0;

  int points(int place) {
    switch (place) {
      case 1:
        return place1Points;
        break;
      case 2:
        return place2Points;
        break;
      case 3:
        return place3Points;
        break;
      default:
        return place1Points;
    }
  }

  int get playerWin {
    final listPoints = [place1Points, place2Points, place3Points];
    final winnerPoints =
        listPoints.reduce((value, element) => max(value, element));
    return listPoints.indexOf(winnerPoints);
  }

  addPoints({
    @required int place,
    @required int points,
  }) {
    switch (place) {
      case 1:
        place1Points += points;
        break;
      case 2:
        place2Points += points;
        break;
      case 3:
        place3Points += points;
        break;
      default:
    }
    update();
  }

  resetPoints(int place) {
    switch (place) {
      case 1:
        place1Points = 0;
        break;
      case 2:
        place2Points = 0;
        break;
      case 3:
        place3Points = 0;
        break;
      default:
    }
    update();
  }
}
