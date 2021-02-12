import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:soundpool/soundpool.dart';

class SoundController extends GetxController {
  onInit() {
    init();
    super.onInit();
  }

  Soundpool pool = Soundpool(streamType: StreamType.notification);
  bool mute = false;
  int _error;
  int _success;
  int _clack;
  int _music;

  init() async {
    await _setSounds();
    playMusic();
  }

  playError() {
    if (!mute) pool.play(_error);
  }

  playSuccess() {
    if (!mute) pool.play(_success);
  }

  playClack() {
    if (!mute) pool.play(_clack, rate: 1.5);
  }

  playMusic() {
    if (!mute) pool.play(_music, repeat: 1);
  }

  _setSounds() async {
    _error =
        await rootBundle.load("assets/error.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    _success =
        await rootBundle.load("assets/success.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    _clack =
        await rootBundle.load("assets/click.mp3").then((ByteData soundData) {
      return pool.load(soundData);
    });
    _music =
        await rootBundle.load("assets/sound.wav").then((ByteData soundData) {
      return pool.load(soundData);
    });
    pool.setVolume(volume: 0.3);
  }

  setMute() {
    mute = !mute;
    if (mute) {
      pool.stop(_clack);
      pool.stop(_success);
      pool.stop(_error);
    }
    update();
  }

  @override
  void onClose() {
    pool.dispose();
    super.onClose();
  }
}
