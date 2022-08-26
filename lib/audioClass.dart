
import 'package:audioplayers/audioplayers.dart';

class Audio {
  final player = AudioPlayer();

  Future<void> playWinSound() async {

    await player.play(AssetSource(
      'sounds/winSound.mp3',
    ));

    await Future.delayed(Duration(milliseconds: 3500));
    await player.release();
  }

  Future<void> playSound(String soundName) async {

    await player.play(AssetSource(
      'sounds/$soundName.mp3',
    ));

    await Future.delayed(Duration(milliseconds: 200));
    await player.release();
  }
}
