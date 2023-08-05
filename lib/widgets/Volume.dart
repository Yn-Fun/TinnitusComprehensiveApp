import 'dart:developer';

import 'package:flutter/material.dart';
import '../configs/audio_set.dart';

import '../configs/media_QSize.dart';

class VolumeControl extends StatefulWidget {
  final int leftVolume;
  final int rightVolume;
  final void onPressed;
  const VolumeControl(
      {Key? key,
      required this.leftVolume,
      required this.rightVolume,
      this.onPressed})
      : super(key: key);

  @override
  _VolumeControlState createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  late double _leftVolume;
  late double _rightVolume;
  late void _onPressed;
  @override
  void initState() {
    super.initState();
    _leftVolume = widget.leftVolume.toDouble();
    _rightVolume = widget.rightVolume.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //左音棒组件设置
        Stack(alignment: AlignmentDirectional.topCenter, children: [
          RotatedBox(
            quarterTurns: -1,
            child: Slider(
              value: _leftVolume,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (double newValue) {
                setState(() {
                  _leftVolume = newValue;
                  AudioConfig.leftVolume0_100 = _leftVolume;
                  log('左声压级 ${AudioConfig.leftVolume0_100}');
                  // num substractdB = _leftVolume - 100;
                  // num mutiples1 = Math.pow(10, (substractdB / 20));
                  AudioConfig.leftVolGainRadio = AudioConfig.getGainRadio(
                          AudioConfig.leftVolume0_100,
                          AudioConfig.leftCalibVolume)
                      .toDouble();

                  log("左音频增益${AudioConfig.leftVolGainRadio}");
                });
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('左耳',
                  style: TextStyle(fontSize: 15 * MediaQSize.heightRefScale)),
              Text(
                "${(_leftVolume.toStringAsFixed(0))} / 100",
                style: TextStyle(fontSize: 10 * MediaQSize.heightRefScale),
              ),
            ],
          ),
          //以竖直缩放比为字体大小的依据
        ]),
        const SizedBox(width: 16),
        //右音棒组件设置
        Stack(alignment: AlignmentDirectional.bottomCenter, children: [
          RotatedBox(
            quarterTurns: -1,
            child: Slider(
              value: _rightVolume,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (double newValue) {
                setState(() {
                  _rightVolume = newValue;
                  AudioConfig.rightVolume0_100 = _rightVolume;
                  log('右声压级 ${AudioConfig.rightVolume0_100}');

                  AudioConfig.rightVolGainRadio = AudioConfig.getGainRadio(
                          AudioConfig.rightVolume0_100,
                          AudioConfig.rightCalibVolume)
                      .toDouble();
                  log("右音频增益${AudioConfig.rightVolGainRadio}");
                });
              },
            ),
          ),
          Column(
            children: [
              Text('右耳',
                  style: TextStyle(
                      fontSize:
                          15 * MediaQSize.heightRefScale)) //以竖直缩放比为字体大小的依据
              ,
              Text(
                "${(_rightVolume.toStringAsFixed(0))} / 100",
                style: TextStyle(fontSize: 10 * MediaQSize.heightRefScale),
              ),
            ],
          ),
        ]),
      ],
    );
  }
}
