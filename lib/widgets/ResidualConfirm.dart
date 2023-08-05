import 'package:flutter/material.dart';

import '../configs/media_QSize.dart';

class ResidualConfirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 100, left: 50, right: 50, bottom: 50) *
          MediaQSize.heightRefScale,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('请您试听以下治疗音\n10分钟后摘下耳机',
                style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
          ),
          SizedBox(height: 50 * MediaQSize.heightRefScale),
          Icon(
            Icons.play_circle_outline,
            size: (100 * MediaQSize.heightRefScale),
          ),
          SizedBox(height: 50 * MediaQSize.heightRefScale),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('确认',
                  style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
            ),
          ),
        ],
      ),
    );
  }
}
