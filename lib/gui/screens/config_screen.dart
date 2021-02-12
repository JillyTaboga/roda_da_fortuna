import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:roda_da_fortuna/controllers/ai_controller.dart';
import 'package:roda_da_fortuna/controllers/game_controller.dart';
import 'package:roda_da_fortuna/controllers/sound_controller.dart';
import 'package:roda_da_fortuna/gui/screens/spin_screen.dart';
import 'package:roda_da_fortuna/repositories/records.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(SoundController(), permanent: true);
    Get.put(RecordsRespositories(), permanent: true);
    _init();
  }

  bool multiplayer = true;
  int numberOfHumans = 1;
  int dificult = 0;
  List<String> nameOfPlayers = ['Jogador 1', 'Jogador 2', 'Jogador 3'];
  FocusNode multiModeNode = FocusNode();
  FocusNode numberPlayersNode = FocusNode();
  FocusNode dificultPlayerNode = FocusNode();
  FocusNode recordNode = FocusNode();
  FocusNode playNode = FocusNode();

  List<bool> get typeToggle => multiplayer ? [true, false] : [false, true];
  List<bool> get humanPlayers => numberOfHumans == 1
      ? [true, false, false]
      : numberOfHumans == 2
          ? [false, true, false]
          : [false, false, true];
  List<bool> get dificultToggle => dificult == 0
      ? [true, false, false]
      : dificult == 1
          ? [false, true, false]
          : [false, false, true];

  _init() async {
    await Future.delayed(Duration(milliseconds: 5));
    FocusScope.of(context).requestFocus(multiModeNode);
  }

  _restart() {
    setState(() {
      multiplayer = true;
      numberOfHumans = 1;
      dificult = 0;
      nameOfPlayers = ['Jogador 1', 'Jogador 2', 'Jogador 3'];
      FocusScope.of(context).requestFocus(multiModeNode);
    });
  }

  _startGame() {
    Get.put(AiController(dificult: dificult), permanent: true);
    if (multiplayer) {
      Get.put(GameController.normal(
        nameOfPlayers: nameOfPlayers,
        humanPlayers: numberOfHumans,
      ));
    } else {
      Get.put(GameController.solo(nameOfPlayers[0]));
    }
    Get.to(SpinScreen()).then((value) => _restart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: Get.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Roda Roda',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Text('Modo de jogo:'),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    ToggleButtons(
                      focusNodes: [multiModeNode, FocusNode()],
                      children: [
                        Text('Normal'),
                        Text('Solo'),
                      ],
                      isSelected: typeToggle,
                      onPressed: (value) {
                        setState(() {
                          multiplayer = value == 0 ? true : false;
                          if (!multiplayer) {
                            numberOfHumans = 1;
                          }
                        });
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.help),
                          onPressed: () {
                            Get.dialog(
                              Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text('Instruções:'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'O jogo consiste em adivinhar letras de uma série de 3 palavras ligadas por um tema, antes de adivinhar cada jogador gira uma roda de prêmios que define o quanto ganhará de pontos para cada letra que descobrir, nessa roda ele também pode passar a vez e perder todos os pontos acumulados até o momento.\nSe um jogador faz um palpite de letra que tenha correspondente nas palavras ele continua jogando com um novo giro da roda, caso não tenha nenhuma letra nas palavras ele passa a vez.\n O jogo termina após 3 rodadas de palavras sendo declarado vencedor aquele que possuir a maior pontuação.',
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text('Modo Solo:'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'As regras no modo solo são praticamente as mesmas, contudo caso o jogador tente uma letra que não exista na palavra ele perde a quantidade de pontos que tirou na roda de prêmios, caso caia no passe a vez ele perde 1000 pontos e caso caia no perdeu tudo o jogo termina.',
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                if (multiplayer) ...[
                  SizedBox(
                    height: 30,
                  ),
                  Text('Jogadores Humanos:'),
                  SizedBox(
                    height: 5,
                  ),
                  ToggleButtons(
                    focusNodes: [numberPlayersNode, FocusNode(), FocusNode()],
                    children: [
                      Text('1'),
                      Text('2'),
                      Text('3'),
                    ],
                    isSelected: humanPlayers,
                    onPressed: (value) {
                      setState(() {
                        numberOfHumans = value + 1;
                      });
                    },
                  ),
                ],
                if (multiplayer && numberOfHumans < 3) ...[
                  SizedBox(
                    height: 30,
                  ),
                  Text('Dificuldade:'),
                  SizedBox(
                    height: 5,
                  ),
                  ToggleButtons(
                    focusNodes: [dificultPlayerNode, FocusNode(), FocusNode()],
                    children: [
                      Text('Fácil'),
                      Text('Médio'),
                      Text('Difícil'),
                    ],
                    isSelected: dificultToggle,
                    onPressed: (value) {
                      setState(() {
                        dificult = value;
                      });
                    },
                  ),
                ],
                SizedBox(
                  height: 30,
                ),
                Text('Nome dos Jogadores:'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfHumans,
                    itemBuilder: (context, index) {
                      return TextFormField(
                        initialValue: nameOfPlayers[index],
                        onChanged: (text) {
                          nameOfPlayers[index] = text;
                        },
                        onFieldSubmitted: (text) {
                          FocusScope.of(context).requestFocus(playNode);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      focusNode: playNode,
                      onPressed: _startGame,
                      child: Text('Jogar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.dialog(RecordDialog());
                      },
                      child: Text('Pontuações'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecordDialog extends StatefulWidget {
  const RecordDialog({
    Key key,
  }) : super(key: key);

  @override
  _RecordDialogState createState() => _RecordDialogState();
}

class _RecordDialogState extends State<RecordDialog> {
  GameType type = GameType.NORMAL;

  List<bool> get typeToggle {
    switch (type) {
      case GameType.EASY:
        return [true, false, false, false];
        break;
      case GameType.NORMAL:
        return [false, true, false, false];
        break;
      case GameType.HARD:
        return [false, false, true, false];
        break;
      case GameType.SOLO:
        return [false, false, false, true];
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Melhores pontuações:'),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                    constraints: BoxConstraints(
                      minHeight: 30,
                      minWidth: 60,
                    ),
                    children: [
                      Text('Fácil'),
                      Text('Normal'),
                      Text('Difícil'),
                      Text('Solo'),
                    ],
                    isSelected: typeToggle,
                    onPressed: (value) {
                      setState(() {
                        switch (value) {
                          case 0:
                            type = GameType.EASY;
                            break;
                          case 1:
                            type = GameType.NORMAL;
                            break;
                          case 2:
                            type = GameType.HARD;
                            break;
                          case 3:
                            type = GameType.SOLO;
                            break;
                          default:
                        }
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            GetBuilder<RecordsRespositories>(
              builder: (recordsController) {
                return recordsController.getRecords(type).isEmpty
                    ? Center(
                        child: Text('Nenhum recorde gravado ainda.'),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: recordsController.getRecords(type).length,
                        itemBuilder: (context, index) {
                          final record =
                              recordsController.getRecords(type)[index];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat.yMd().format(record.date),
                                  ),
                                  Text(
                                    record.name,
                                  ),
                                  Text(
                                    record.points.toStringAsFixed(0),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 3,
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ],
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
