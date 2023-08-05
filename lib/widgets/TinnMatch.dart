import 'package:flutter/material.dart';

import '../configs/audio_set.dart';
import '../configs/media_QSize.dart';

class TinnitusMatchWidget extends StatefulWidget {
  @override
  _TinnitusMatchWidgetState createState() => _TinnitusMatchWidgetState();
}

class _TinnitusMatchWidgetState extends State<TinnitusMatchWidget> {
  String _selectedEar = '左耳';
  double _frequency = 0.125;
//  int _volume = 62;

  final List<double> _frequencies = [
    0.125,
    0.25,
    0.5,
    0.75,
    1,
    2,
    3,
    4,
    6,
    8,
    10
  ];

  void _showAdjustFrequencyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('与现在的“耳机给声”的音调相比\n您“自身耳鸣声”的音调是更高，还是更低呢？',
              style: TextStyle(fontSize: (25 * MediaQSize.heightRefScale))),
          //content: const Text(''),
          actions: [
            TextButton(
              child: Text('自身耳鸣声的音调更低',
                  style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
              onPressed: () {
                int index = _frequencies.indexOf(_frequency);
                if (index > 0) {
                  setState(() => _frequency = _frequencies[index - 1]);
                }
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 30),
            TextButton(
              child: Text('自身耳鸣声的音调更高',
                  style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
              onPressed: () {
                int index = _frequencies.indexOf(_frequency);
                if (index < _frequencies.length - 1) {
                  setState(() => _frequency = _frequencies[index + 1]);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 50) *
          MediaQSize.heightRefScale,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _selectedEar = '左耳'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _selectedEar == '左耳' ? Colors.blue : Colors.grey),
                ),
                child: Text('左耳',
                    style:
                        TextStyle(fontSize: (25 * MediaQSize.heightRefScale))),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => setState(() => _selectedEar = '右耳'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      _selectedEar == '右耳' ? Colors.blue : Colors.grey),
                ),
                child: Text('右耳',
                    style:
                        TextStyle(fontSize: (25 * MediaQSize.heightRefScale))),
              ),
            ],
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            // color: Theme.of(context).primaryColor,
            onPressed: () => {_showAdjustFrequencyDialog()},
            child: Text('调整音调',
                style: TextStyle(
                    fontSize: (30 * MediaQSize.heightRefScale),
                    color: Theme.of(context).primaryTextTheme.button?.color)),
          ),
          const SizedBox(height: 20),
          Text('音调',
              style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () {
                  int index = _frequencies.indexOf(_frequency);
                  if (index > 0) {
                    setState(() => _frequency = _frequencies[index - 1]);
                  }
                },
              ),
              Text('${_frequency.toStringAsFixed(2)}k',
                  style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () {
                  int index = _frequencies.indexOf(_frequency);
                  if (index < _frequencies.length - 1) {
                    setState(() => _frequency = _frequencies[index + 1]);
                  }
                },
              ),
            ],
          ),
          Slider(
            value: _frequency,
            min: _frequencies.first,
            max: _frequencies.last,
            divisions: _frequencies.length - 1,
            onChanged: (double newValue) {
              setState(() {
                _frequency = newValue;
              });
            },
          ),
          const SizedBox(height: 200),
          Text('音量',
              style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () => setState(() => AudioConfig.leftVolume0_100--),
              ),
              Text('${AudioConfig.leftVolume0_100} dB',
                  style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () => setState(() => AudioConfig.leftVolume0_100++),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 您可以在主函数中这样使用它：

// void main() => runApp(MaterialApp(home: TinnitusTestWidget()));
// 这个widget包括左耳和右耳两个按钮，用于选择测试的耳朵。它还包括一个音调调节器，可以通过点击按钮或拖动滑块来更改频率。此外，还有一个音量调节器，可以通过点击按钮来增加或减少音量。

// 在这个例子中，我们使用了一个预定义的频率列表来控制音调调节器。您可以通过点击按钮或拖动滑块来在这些预定义的频率之间切换。

// 此外，我们还添加了一个弹窗，用于调整音调。您可以点击“调整音调”按钮来打开这个弹窗，在弹窗中选择更高或更低的音调。