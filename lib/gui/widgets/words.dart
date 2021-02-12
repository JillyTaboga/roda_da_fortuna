import 'package:flutter/material.dart';
import 'package:roda_da_fortuna/repositories/letters.dart';
import 'package:roda_da_fortuna/repositories/words.dart';

class WordRow extends StatelessWidget {
  const WordRow({
    Key key,
    @required this.word,
  }) : super(key: key);

  final Words word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 35,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: word.word.characters
              .map((e) => LetterBox(
                    letter: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class LetterBox extends StatelessWidget {
  const LetterBox({
    Key key,
    this.letter,
  }) : super(key: key);

  final String letter;

  @override
  Widget build(BuildContext context) {
    final char = Letter(letter: letter);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 1,
      ),
      height: 35,
      width: 30,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: char.isSpecial ? Colors.orange : Colors.white,
      ),
      alignment: Alignment.center,
      child: (char.isSpecial || char.revealed)
          ? Text(
              letter,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            )
          : null,
    );
  }
}
