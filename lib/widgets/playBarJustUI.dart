import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayBarJustUI extends StatefulWidget {
  @override
  _PlayBarJustUIState createState() => _PlayBarJustUIState();
}

class _PlayBarJustUIState extends State<PlayBarJustUI> {
  double _volume = 0.5;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _volume,
          onChanged: (value) {
            setState(() {
              _volume = value;
            });
            _audioPlayer.setVolume(value);
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.play_arrow,
            size: 60,
          ),
          onPressed: () async {
            // await _audioPlayer.play('YOUR_AUDIO_FILE_URL');
          },
        ),
      ],
    );
  }
}
