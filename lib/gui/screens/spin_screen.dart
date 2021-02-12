import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roda_da_fortuna/controllers/game_controller.dart';
import 'package:roda_da_fortuna/controllers/sound_controller.dart';
import 'package:roda_da_fortuna/gui/widgets/charplaces.dart';
import 'package:roda_da_fortuna/gui/widgets/spinwheel.dart';
import 'package:roda_da_fortuna/gui/widgets/words.dart';
import 'package:roda_da_fortuna/repositories/letters.dart';
import 'package:roda_da_fortuna/repositories/points.dart';

class SpinScreen extends StatefulWidget {
  @override
  _SpinScreenState createState() => _SpinScreenState();
}

class _SpinScreenState extends State<SpinScreen> {
  double actualValue = 0;

  @override
  void initState() {
    super.initState();
    Get.put(PointsRepositories());
  }

  @override
  void dispose() {
    Get.delete<GameController>();
    Get.delete<PointsRepositories>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameController>(
      builder: (gameController) {
        return Scaffold(
          body: Theme(
            data: ThemeData(
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                  maxWidth: 600,
                ),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: gameController.screenState.wordsTop,
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: Get.height / 3,
                          width: constraints.maxWidth,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (Get.width < 600)
                                  SizedBox(
                                    height: 25,
                                  ),
                                Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      gameController.category,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    Expanded(
                                      child: GetBuilder<SoundController>(
                                          builder: (soundController) {
                                        return IconButton(
                                            icon: Icon(
                                              soundController.mute
                                                  ? Icons.music_note
                                                  : Icons.music_off,
                                              color: Colors.orange,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              soundController.setMute();
                                            });
                                      }),
                                    ),
                                  ],
                                ),
                                ...gameController.selectedWords
                                    .map((e) => WordRow(word: e))
                                    .toList(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: gameController.screenState.charsTop,
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: Get.height / 2,
                          width: constraints.maxWidth,
                          child: CharsCenter(
                            turn: gameController.turnTime,
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        top: gameController.screenState.wheelBottom,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            alignment: Alignment.topCenter,
                            height:
                                Get.width > 600 ? 400 : constraints.maxWidth,
                            width: Get.width > 600 ? 400 : constraints.maxWidth,
                            child: SpinWheel(
                              onStop: (value) {
                                actualValue = value;
                                gameController.spinReturn(value);
                              },
                              onTurn: (!gameController.autoSpin &&
                                  gameController.phase == GamePhase.SPIN),
                            ),
                          ),
                        ),
                      ),
                      if (gameController.phase == GamePhase.GUESS)
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Escolha uma letra:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 2,
                                  runSpacing: 2,
                                  children: letters
                                      .where((element) => !gameController
                                          .guessedLetters
                                          .contains(element))
                                      .toList()
                                      .map(
                                        (e) => ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: Size(45, 45),
                                              padding: EdgeInsets.all(0)),
                                          child: Text(e),
                                          onPressed: gameController.aiTurn
                                              ? null
                                              : () {
                                                  gameController.guessLetter(
                                                    letter: e,
                                                    value: actualValue,
                                                  );
                                                },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (gameController.phase == GamePhase.CONFIRM)
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'É a vez do:\n' +
                                      gameController
                                          .players[gameController.turnTime - 1]
                                          .name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    gameController.confirm();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
