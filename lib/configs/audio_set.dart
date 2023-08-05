import 'dart:math' as Math;

class AudioConfig {
  //数据表 301freq-100spl
  static List<List<dynamic>>? excelData = [];
  static double leftVolGainRadio = 1.0; //左右耳音量增益比例 //0-1.0
  static double rightVolGainRadio = 1.0;

//所谓音量
  static double leftVolume0_100 = 100; //标称声压级（目标）
  static double rightVolume0_100 = 100;

  //11个频率节点 顺序按照：
  //125Hz	250Hz	500Hz	750Hz	1000Hz	2000Hz	3000Hz	4000Hz	6000Hz	8000Hz	10kHz

  static double getCalibSPL(String seletedFile) {
    switch (seletedFile) {
      case '100Hz':
        return 118;
      case '125Hz':
        return 117;
      case '250Hz':
        return 114;
      case '500Hz':
        return 112;
      case '750Hz':
        return 109;
      case '1000Hz':
        return 112;
      case '2000Hz':
        return 118;
      case '3000Hz':
        return 124;
      case '4000Hz':
        return 125;
      case '6000Hz':
        return 114;
      case '8000Hz':
        return 110;
      case '10000Hz':
        return 120;
      case '12000Hz':
        return 107;
      default:
        return 100;
    }
  }

  static double leftCalibVolume = 100; //左标定声压 音频1倍播放的声压级（校准数据）
  static double rightCalibVolume = 100;

  //计算增益 targetDB是所选择的dB calibDB是系数为1时对应的真实的dB
  static num getGainRadio(double targetDB, double calibDB) {
    // 计算折算
    double substractdB = targetDB - calibDB; //比如标定值为118  要校准并播放80dB  则要-38
    return Math.pow(10, (substractdB / 20));
  }

  // static void refreshVolBar() {
  //   //想要同步到音量棒
  //   VolumeControl(
  //     // leftVolume: (20 * Math.log(AudioConfig.leftVolumeRadio) +100) .toInt(),
  //     leftVolume: AudioConfig.leftVolume0_100.toInt(),
  //     rightVolume: AudioConfig.rightVolume0_100.toInt(),
  //   );
  // }

}
