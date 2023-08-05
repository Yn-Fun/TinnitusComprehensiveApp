import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wav/wav.dart';
import 'dart:async';

import '../configs/media_QSize.dart';
import '../widgets/MusicDropdown.dart';
import '../widgets/Volume.dart';
import '../configs/audio_set.dart';

class calibrationPage extends StatefulWidget {
  String leftFilePath = "/storage/emulated/0/Music/sin_1000Hz.wav"; //sin_1000Hz
  String rightFilePath = "/storage/emulated/0/Music/sin_1000Hz.wav";
  // double leftVolume = 1.0;
  // double rightVolume = 1.0;//移到公共
  @override
  _calibrationPageState createState() => _calibrationPageState();
}

class _calibrationPageState extends State<calibrationPage> {
  double localLeftVol = AudioConfig.leftVolume0_100; //
  double localRightVol = AudioConfig.rightVolume0_100; //
  bool _isPlaying = false;
  bool _isPlaying2 = false;

  String _playButtonLabel = "播放";
  String _playInnerAudiosButtonLabel = "Play(from assets)";

  //定义一个与原生传递的 平台通道
  static const MethodChannel _channel =
      MethodChannel('com.example.myapp/audio');

//音频播放入口1
  Future<void> _playOrPauseAudio() async {
    try {
      if (_isPlaying) {
        await _channel.invokeMethod('toggleAudio');
        setState(() {
          _isPlaying = false;
          _playButtonLabel = "播放"; //Resume Audio 预备给下一个状态 恢复音频
        });
      } else {
        setState(() {
          _isPlaying = true;
          _playButtonLabel = "暂停"; //预备给下一个状态
        });
        await _channel.invokeMethod('playAudio', {
          'leftFilename': widget.leftFilePath,
          'rightFilename': widget.rightFilePath,
          'leftVolume': AudioConfig.leftVolGainRadio, //0-1.0
          'rightVolume': AudioConfig.rightVolGainRadio,
        });
      }
    } on PlatformException catch (e) {
      print("Failed to play/pause audio: '${e.message}'.");
    }
  }

//入口2 assets
  Future<void> _playOrPauseAssetsAudio() async {
    try {
      if (_isPlaying2) {
        await _channel.invokeMethod('toggleAudio2');
        setState(() {
          _isPlaying2 = false;
          _playInnerAudiosButtonLabel =
              "Play(from assets)"; //Resume Audio 预备给下一个状态 恢复音频
        });
      } else {
        setState(() {
          _isPlaying2 = true;
          _playInnerAudiosButtonLabel = "Stop"; //预备给下一个状态
        });
        ByteData leftwavByteData =
            await rootBundle.load('assets/Balancedmusic/新雨声.wav');
        ByteData rightwavByteData =
            await rootBundle.load('assets/Balancedmusic/新风声.wav'); //
        await _channel.invokeMethod('playAudio2', {
          // 将ByteData转换为字节数组
          'leftbyteData': leftwavByteData.buffer.asUint8List(),
          'rightbyteData': rightwavByteData.buffer.asUint8List(),
          'leftVolume': AudioConfig.leftVolGainRadio, //0-1.0
          'rightVolume': AudioConfig.rightVolGainRadio,
        });
      }
    } on PlatformException catch (e) {
      print("Failed to play/pause audio: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,

        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
        title: Text(
          '设备校准',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
        ),
      ),
      body: Center(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 100),
            child: Column(
              children: [
                Text("选择音乐（各纯音+白噪）",
                    style: TextStyle(fontSize: 20 * MediaQSize.heightRefScale)),
                SizedBox(
                  height: 50 * MediaQSize.heightRefScale,
                ),
                //频率下拉框行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //左耳频率 下拉键
                    MyMusicDropdown(
                      labelTitle: '左耳频率',
                      options: const [
                        '100Hz',
                        '125Hz',
                        '250Hz',
                        '500Hz',
                        '750Hz',
                        '1000Hz',
                        '2000Hz',
                        '3000Hz',
                        '4000Hz',
                        '6000Hz',
                        '8000Hz',
                        '10000Hz',
                        '12000Hz',
                        '白噪',
                        '空（底噪测试）'
                      ],
                      onSelection: (selectedOption) {
                        log('您选择了 $selectedOption');
                        if (selectedOption == '白噪') {
                          // String leftfilename = "sin_$selectedOption.wav";
                          widget.leftFilePath =
                              "/storage/emulated/0/Music/白噪.wav";
                        } else if (selectedOption == '空（底噪测试）') {
                          // String leftfilename = "sin_$selectedOption.wav";
                          widget.leftFilePath =
                              "/storage/emulated/0/Music/empty.wav";
                        } else {
                          String leftfilename =
                              "sin_$selectedOption.wav"; //文件名示例：sin_100Hz.wav
                          //String leftfilename ="${selectedOption.substring(0, selectedOption.indexOf("Hz"))}.wav";//文件名示例：100.wav （适配老师发的）
                          // String leftfilename = "sin100_$selectedOption.wav";
                          widget.leftFilePath =
                              "/storage/emulated/0/Music/$leftfilename";
                        }
                        log("左音频文件名${widget.leftFilePath}");

                        //查找此频率对应的标定声压级（用于校准
                        AudioConfig.leftCalibVolume =
                            AudioConfig.getCalibSPL(selectedOption);
                      },
                      onChangedRefresh: (localLeftVol, localRightVol) {
                        setState(() {
                          // 刷新refreshVolUI();
                          // localLeftVol = AudioConfig.leftVolume0_100;
                          // localRightVol = AudioConfig.rightVolume0_100;
                          log("下拉框频率选择完毕");
                        });
                      },
                    ),
                    //右耳频率 下拉键
                    MyMusicDropdown(
                      labelTitle: '右耳频率',
                      options: const [
                        '100Hz',
                        '125Hz',
                        '250Hz',
                        '500Hz',
                        '750Hz',
                        '1000Hz',
                        '2000Hz',
                        '3000Hz',
                        '4000Hz',
                        '6000Hz',
                        '8000Hz',
                        '10000Hz',
                        '12000Hz',
                        '白噪',
                        '空（底噪测试）'
                      ],
                      onSelection: (selectedOption) {
                        if (selectedOption == '白噪') {
                          // String leftfilename = "sin_$selectedOption.wav";
                          widget.rightFilePath =
                              "/storage/emulated/0/Music/白噪.wav";
                        } else if (selectedOption == '空（底噪测试）') {
                          // String rightFilePath = "sin_$selectedOption.wav";
                          widget.rightFilePath =
                              "/storage/emulated/0/Music/empty.wav";
                        } else {
                          String rightfilename = "sin_$selectedOption.wav";
                          // String rightfilename ="${selectedOption.substring(0, selectedOption.indexOf("Hz"))}.wav";
                          // String leftfilename = "sin100_$selectedOption.wav";
                          widget.rightFilePath =
                              "/storage/emulated/0/Music/$rightfilename";
                        }
                        log("右音频文件名${widget.rightFilePath}");
                        //查找此频率对应的标定声压级（用于校准
                        AudioConfig.rightCalibVolume =
                            AudioConfig.getCalibSPL(selectedOption);
                        log("${selectedOption}Hz下，标定声压级为：${AudioConfig.rightCalibVolume}");
                      },
                      onChangedRefresh: (localLeftVol, localRightVol) {
                        setState(() {
                          // 刷新refreshVolUI();
                          localLeftVol = AudioConfig.leftVolume0_100;
                          localRightVol = AudioConfig.rightVolume0_100;
                          log("下拉框选择");
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50 * MediaQSize.heightRefScale,
                ),
                //音量下拉框行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //左耳音量 下拉键
                    MyMusicDropdown(
                      labelTitle: '左耳音量',
                      options: const [
                        '120',
                        '119',
                        '118',
                        '117',
                        '116',
                        '115',
                        '114',
                        '113',
                        '112',
                        '111',
                        '110',
                        '109',
                        '108',
                        '107',
                        '106',
                        '105',
                        '104',
                        '103',
                        '102',
                        '101',
                        '100',
                        '90',
                        '80',
                        '70',
                        '60',
                        '50',
                        '40',
                        '30',
                        '20',
                        '10',
                        '5',
                        '4',
                        '3',
                        '2',
                        '1',
                        '0',
                        '-10',
                        '-20',
                        '-30'
                      ],
                      onSelection: (selectedOption) {
                        AudioConfig.leftVolume0_100 =
                            double.parse(selectedOption);
                        log('您目标声压级 ${AudioConfig.leftVolume0_100}');
                        AudioConfig.leftVolGainRadio = AudioConfig.getGainRadio(
                                AudioConfig.leftVolume0_100,
                                AudioConfig.leftCalibVolume)
                            .toDouble(); //获得左增益
                        log("左音频增益${AudioConfig.leftVolGainRadio}");
                      },
                      onChangedRefresh: (localLeftVol, localRightVol) {
                        setState(() {
                          // 刷新refreshVolUI();
                          localLeftVol = AudioConfig.leftVolume0_100;
                          localRightVol = AudioConfig.rightVolume0_100;
                        });
                      },
                    ),
                    //右耳音量 下拉键
                    MyMusicDropdown(
                      labelTitle: '右耳音量',
                      options: const [
                        '120',
                        '119',
                        '118',
                        '117',
                        '116',
                        '115',
                        '114',
                        '113',
                        '112',
                        '111',
                        '110',
                        '109',
                        '108',
                        '107',
                        '106',
                        '105',
                        '104',
                        '103',
                        '102',
                        '101',
                        '100',
                        '90',
                        '80',
                        '70',
                        '60',
                        '50',
                        '40',
                        '30',
                        '20',
                        '10',
                        '5',
                        '4',
                        '3',
                        '2',
                        '1',
                        '0',
                        '-10',
                        '-20',
                        '-30'
                      ],
                      onSelection: (selectedOption) {
                        AudioConfig.rightVolume0_100 =
                            double.parse(selectedOption);
                        log('右耳目标声压级 ${AudioConfig.rightVolume0_100}');

                        AudioConfig.rightVolGainRadio =
                            AudioConfig.getGainRadio(
                                    AudioConfig.rightVolume0_100,
                                    AudioConfig.rightCalibVolume)
                                .toDouble(); //获得右增益
                        log("右音频增益${AudioConfig.rightVolGainRadio}");
                      },
                      onChangedRefresh: (localLeftVol, localRightVol) {
                        setState(() {
                          // 刷新refreshVolUI();
                          localLeftVol = AudioConfig.leftVolume0_100;
                          localRightVol = AudioConfig.rightVolume0_100;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50 * MediaQSize.heightRefScale,
                ),

                //播放按键1
                ElevatedButton(
                  onPressed: _playOrPauseAudio,
                  child: Text(_playButtonLabel),
                ),
                //文字参数
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "左耳声压级（标）：${AudioConfig.leftVolume0_100.toStringAsFixed(0)}",
                            style: TextStyle(
                                fontSize: 15 * MediaQSize.heightRefScale)),
                        Text(
                            "左耳增益系数：${AudioConfig.leftVolGainRadio.toStringAsExponential(4)}",
                            style: TextStyle(
                                fontSize: 15 * MediaQSize.heightRefScale)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            "右耳声压级（标）：${AudioConfig.rightVolume0_100.toStringAsFixed(0)}",
                            style: TextStyle(
                                fontSize: 15 * MediaQSize.heightRefScale)),
                        Text(
                            "右耳增益系数：${AudioConfig.rightVolGainRadio.toStringAsExponential(4)}",
                            style: TextStyle(
                                fontSize: 15 * MediaQSize.heightRefScale)),
                      ],
                    )
                  ],
                ),
                //尝试
                ElevatedButton(
                  onPressed: _playOrPauseAssetsAudio,
                  //匿名函数包装fastwav 不能直接用 否则会报错
                  // fastwav(
                  //   [
                  //     "/storage/emulated/0/Music/sin_1000Hz.wav",
                  //     '/storage/emulated/0/Music/newsinHz.wav'
                  //   ],
                  // );
                  // fastwav(
                  //   [
                  //     "/data/user/0/com.example.QEHS/cache/assets/Balancedmusic/out2.wav",
                  //     "/data/user/0/com.example.QEHS/cache/assets/Balancedmusic/out3.wav"
                  //   ],
                  // );
                  child: Text(_playInnerAudiosButtonLabel),
                ),
              ],
            ),
          ),

          //音量棒
          Container(
              height: 0.8 * MediaQSize.thisDsize.height, //音量棒长度
              padding: const EdgeInsets.only(left: 20, top: 50, right: 20) *
                  MediaQSize.heightRefScale,
              child: VolumeControl(
                leftVolume: localLeftVol.toInt(),
                rightVolume: localRightVol.toInt(),
                //(20 * Math.log(AudioConfig.rightVolumeRadio) + 100)
              )),
        ]),
      ),
    );
  }

  void fastwav(List<String> argv) async {
    log("1");
    final wav = await Wav.readFile(argv[0]);
    final fastWav = Wav(wav.channels, wav.samplesPerSecond * 2);
    await fastWav.writeFile(argv[1]);
    // _channel.invokeMethod('playAudio2', {
    //   'leftFilename': argv[0],
    //   'rightFilename': argv[0],
    //   'leftVolume': AudioConfig.leftVolGainRadio, //0-1.0
    //   'rightVolume': AudioConfig.rightVolGainRadio,
    // });

    log("0");
  }
}
