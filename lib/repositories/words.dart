import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:roda_da_fortuna/controllers/game_controller.dart';
import 'package:roda_da_fortuna/repositories/letters.dart';

List<String> categories = [
  'Animais', //0
  'Coisas de geladeira', //1
  'Brinquedos', //2
  'Natureza', //3
  'Espaço sideral', //4
  'Coisas de banheiro', //5
];

List<Words> words = [
  Words(
    word: 'Marreco',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Gaivota',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Veado',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Chimpazé',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Orangutango',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Camundongo',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Elefante',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Perdiz',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Peru',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Mosquito',
    categories: [
      categories[0],
      categories[3],
    ],
  ),
  Words(
    word: 'Carvalho',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Gramado',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Floresta',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Cordilheira',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Oceano',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Pradaria',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Montanha',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Por-do-sol',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Nascente',
    categories: [
      categories[3],
    ],
  ),
  Words(
    word: 'Super-Cola',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Sorvete',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Ovos',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Limonada',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Cerveja',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Feijão',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Legumes',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Verduras',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Refrigerante',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Água',
    categories: [
      categories[1],
    ],
  ),
  Words(
    word: 'Baralho',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Carrinho',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Bicicleta',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Boneca',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Pipa',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Papagaio',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Pelúcia',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Bolinha de Gude',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Video-game',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Bambole',
    categories: [
      categories[2],
    ],
  ),
  Words(
    word: 'Foguete',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Estrela',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Planeta',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Asteróide',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Júpiter',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Nave Espacial',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Saturno',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Eclipse',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Solstício',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Equinócio',
    categories: [
      categories[4],
    ],
  ),
  Words(
    word: 'Privada',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Chuveiro',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Cortina',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Torneira',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Sabonete',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Xampú',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Condicionador',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Escova de dentes',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Pasta de dentes',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Pomada',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Escova',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Pente',
    categories: [
      categories[5],
    ],
  ),
  Words(
    word: 'Tubarão',
    categories: [
      categories[0],
    ],
  ),
  Words(
    word: 'Baleia',
    categories: [
      categories[0],
    ],
  ),
  Words(
    word: 'Besouro',
    categories: [
      categories[0],
    ],
  ),
  Words(
    word: 'Morcego',
    categories: [
      categories[0],
    ],
  ),
];

class Words {
  String word;
  List<String> categories;
  Words({
    @required this.word,
    @required this.categories,
  });

  List<String> get allLetters => word.characters.toList();

  int get missingLetters {
    var missing = 0;
    for (final char in word.characters) {
      final letter = Letter(letter: char);
      if (!Get.find<GameController>().guessedLetters.contains(letter.char) &&
          !letter.isSpecial) {
        missing++;
      }
    }
    return missing;
  }

  int hits(String letter) {
    var hits = 0;
    for (final char in word.characters) {
      final charLetter = Letter(letter: char);
      if (letter == charLetter.char) hits++;
    }
    return hits;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Words && o.word == word && listEquals(o.categories, categories);
  }

  @override
  int get hashCode => word.hashCode ^ categories.hashCode;
}
