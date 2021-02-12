import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:roda_da_fortuna/controllers/game_controller.dart';
import 'package:roda_da_fortuna/repositories/points.dart';

class CharsCenter extends StatelessWidget {
  const CharsCenter({
    Key key,
    @required this.turn,
  }) : super(key: key);
  final int turn;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PointsRepositories>(
      builder: (points) {
        return GetBuilder<GameController>(
          builder: (gameController) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: gameController.players
                  .map(
                    (e) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: CharPlan(
                          place: gameController.players.indexOf(e) + 1,
                          turn: turn == (gameController.players.indexOf(e) + 1),
                          points: points
                              .points(gameController.players.indexOf(e) + 1),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}

class CharPlan extends StatelessWidget {
  const CharPlan({
    Key key,
    @required this.place,
    @required this.turn,
    @required this.points,
  }) : super(key: key);

  final int place;
  final bool turn;
  final int points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 25,
            child: Lottie.asset(
              'assets/char$place/char$place.json',
              height: constraints.maxHeight / 2,
            ),
          ),
          Positioned(
            top: Get.height / 4,
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Image.asset(
                'assets/plan$place.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: (Get.height / 4) + (Get.height / 4 / 6),
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                points.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            child: Container(
              width: Get.width / 3,
              child: Center(
                child: GetBuilder<GameController>(
                  builder: (gameController) {
                    return Text(
                      gameController.players[place - 1].name,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (turn)
            Positioned(
              top: (Get.height / 4) + (Get.height / 4 / 2),
              child: Container(
                width: Get.width / 3,
                child: Center(
                  child: Text(
                    'Sua vez',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
              ),
            )
        ],
      );
    });
  }
}
