import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum GameType { EASY, NORMAL, HARD, SOLO }

class RecordsRespositories extends GetxController {
  onInit() {
    _init();
    super.onInit();
  }

  GetStorage easy = GetStorage('easy');
  GetStorage normal = GetStorage('normal');
  GetStorage hard = GetStorage('hard');
  GetStorage solo = GetStorage('solo');

  GetStorage storageByType(GameType type) {
    switch (type) {
      case GameType.EASY:
        return easy;
        break;
      case GameType.NORMAL:
        return normal;
        break;
      case GameType.HARD:
        return hard;
        break;
      case GameType.SOLO:
        return solo;
        break;
      default:
        return easy;
    }
  }

  saveRecord({
    @required GameType type,
    @required String name,
    @required int points,
  }) {
    final record = Record(
      name: name,
      points: points,
      date: DateTime.now(),
    );
    storageByType(type).write(
      record.date.millisecondsSinceEpoch.toString(),
      record.toMap(),
    );
  }

  List<Record> getRecords(GameType type) {
    final iterable = storageByType(type).getValues();
    final values = (iterable as Iterable).toList().cast<Map>();
    var list = values.map((e) => Record.fromMap(e)).toList();
    list.sort((a, b) => b.points.compareTo(a.points));
    return list;
  }

  _init() async {
    await GetStorage.init();
  }
}

class Record {
  String name;
  int points;
  DateTime date;
  Record({
    @required this.name,
    @required this.points,
    @required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'points': points,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Record(
      name: map['name'],
      points: map['points'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Record.fromJson(String source) => Record.fromMap(json.decode(source));
}
