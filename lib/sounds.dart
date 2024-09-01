import 'package:audioplayers/audioplayers.dart';

enum SfxType {
  wrongAnswer,
  correctAnswer,
  buttonTap,
  complete,
  erase,
  swishSwish,
  flip,
  background,
}

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(SfxType type) async {
    final List<String> filenames = soundTypeToFilename(type);
    final double volume = soundTypeToVolume(type);

    if (filenames.isNotEmpty) {
      await _audioPlayer.setVolume(volume);
      await _audioPlayer.setReleaseMode(
          type == SfxType.background ? ReleaseMode.loop : ReleaseMode.stop);
      await _audioPlayer.play(AssetSource('sounds/${filenames[0]}'));
    }
  }

  void stop() {
    _audioPlayer.stop();
  }
  
  void pause() {
    _audioPlayer.pause();
  }

  void resume() {
    _audioPlayer.resume();
  }

  List<String> soundTypeToFilename(SfxType type) {
    switch (type) {
      case SfxType.wrongAnswer:
        return ['out.mp3'];
      case SfxType.correctAnswer:
        return ['start.mp3'];
      case SfxType.buttonTap:
        return ['on-tap.mp3'];
      case SfxType.complete:
        return ['complete.mp3'];
      case SfxType.erase:
        return ['fwfwfwfwfw1.mp3', 'fwfwfwfw1.mp3'];
      case SfxType.swishSwish:
        return ['swishswish1.mp3'];
      case SfxType.flip:
        return ['flip.mp3'];
      case SfxType.background:
        return ['bg2.mp3'];
      default:
        return [];
    }
  }

  double soundTypeToVolume(SfxType type) {
    switch (type) {
      case SfxType.wrongAnswer:
      case SfxType.correctAnswer:
      case SfxType.buttonTap:
      case SfxType.complete:
      case SfxType.erase:
      case SfxType.swishSwish:
      case SfxType.flip:
        return 0.5;
      case SfxType.background:
        return 0.1; // Background music volume set to 10%
      default:
        return 1.0;
    }
  }
}
