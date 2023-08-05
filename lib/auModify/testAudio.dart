//生成纯音音频

import 'package:scidart/numdart.dart';

void main() {
  // 设置信号参数
  double amplitude = 1.0; // 振幅
  double frequency = 1000.0; // 频率
  double samplingFrequency = 44100.0; // 采样频率
  double duration = 2.0; // 信号持续时间（秒）

  // 生成正弦波信号
  var t = linspace(0, duration, num: (duration * samplingFrequency).toInt());
  var signal = t.map((x) => amplitude * sin(2 * pi * frequency * x)).toList();

  // 输出信号数据
  print(signal);
}
