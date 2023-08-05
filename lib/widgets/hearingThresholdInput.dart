import 'package:flutter/material.dart';

import '../configs/media_QSize.dart';

class HearingThresholdInput extends StatefulWidget {
  @override
  _HearingThresholdInputState createState() => _HearingThresholdInputState();
}

class _HearingThresholdInputState extends State<HearingThresholdInput> {
  final List<int> frequencies = [125, 250, 500, 1000, 2000, 4000, 8000];
  final Map<String, List<int>> thresholds = {
    'left': [0, 0, 0, 0, 0, 0, 0],
    'right': [0, 0, 0, 0, 0, 0, 0],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Text('频率\n(Hz)',
                  style: TextStyle(fontSize: (23 * MediaQSize.heightRefScale))),
              ...frequencies.map((f) => Text(f.toString(),
                  style:
                      TextStyle(fontSize: (20 * MediaQSize.heightRefScale)))),
            ]),
            TableRow(children: [
              Text('左耳',
                  style: TextStyle(fontSize: (23 * MediaQSize.heightRefScale))),
              ...thresholds['left']!.asMap().entries.map((entry) {
                int index = entry.key;
                return TextField(
                  onChanged: (value) {
                    setState(() {
                      thresholds['left']![index] = int.parse(value);
                    });
                  },
                );
              }),
            ]),
            TableRow(children: [
              Text('右耳',
                  style: TextStyle(fontSize: (23 * MediaQSize.heightRefScale))),
              ...thresholds['right']!.asMap().entries.map((entry) {
                int index = entry.key;
                return TextField(
                  onChanged: (value) {
                    setState(() {
                      thresholds['right']![index] = int.parse(value);
                    });
                  },
                );
              }),
            ]),
          ],
        ),
        SizedBox(
          height: 100 * MediaQSize.heightRefScale,
        ),
        ElevatedButton(
          onPressed: () {
            print(thresholds);
          },
          child: Text('提交',
              style: TextStyle(fontSize: (23 * MediaQSize.heightRefScale))),
        ),
      ],
    );
  }
}
