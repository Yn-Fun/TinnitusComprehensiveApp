import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../configs/media_QSize.dart';

class RefAudioPlayUI extends StatefulWidget {
  @override
  _RefAudioPlayUIState createState() => _RefAudioPlayUIState();
}

class _RefAudioPlayUIState extends State<RefAudioPlayUI> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      //onAudioPositionChanged
      setState(() {
        _position = position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 40, left: 80, right: 80, bottom: 50) *
          MediaQSize.heightRefScale,
      child: Padding(
        padding: EdgeInsets.all(20 * MediaQSize.heightRefScale),
        child: Column(
          children: <Widget>[
            Text('耳鸣治疗中......',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: (30 * MediaQSize.heightRefScale)) //以竖直缩放比为字体大小的依据
                ),
            SizedBox(height: 160 * MediaQSize.heightRefScale),
            Slider(
              value: _position.inSeconds.toDouble(),
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  seekToSecond(value.toInt());
                  value = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("00:00:00",
                    style:
                        TextStyle(fontSize: (15 * MediaQSize.heightRefScale))),
                Text("03:00:00",
                    style:
                        TextStyle(fontSize: (15 * MediaQSize.heightRefScale))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.fast_rewind,
                      size: 50 * MediaQSize.heightRefScale),
                  onPressed: () {
                    _audioPlayer
                        .seek(Duration(seconds: _position.inSeconds - 10));
                  },
                ),
                IconButton(
                  icon: _isPlaying
                      ? Icon(Icons.pause, size: 50 * MediaQSize.heightRefScale)
                      : Icon(Icons.play_arrow,
                          size: 50 * MediaQSize.heightRefScale),
                  onPressed: () {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                      setState(() {
                        _isPlaying = false;
                      });
                    } else {
                      _audioPlayer.resume();
                      setState(() {
                        _isPlaying = true;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fast_forward,
                      size: 50 * MediaQSize.heightRefScale),
                  onPressed: () {
                    _audioPlayer
                        .seek(Duration(seconds: _position.inSeconds + 10));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _audioPlayer.seek(newDuration);
  }
}
