import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/audio_set.dart';

import '../configs/media_QSize.dart';

class MyMusicDropdown extends StatefulWidget {
  final String labelTitle;

  final List<String> options;
  final Function(String) onSelection;
  final Function(double left, double right) onChangedRefresh;

  const MyMusicDropdown({
    required this.labelTitle,
    required this.options,
    required this.onSelection,
    required this.onChangedRefresh,
  });

  @override
  _MyMusicDropdownState createState() => _MyMusicDropdownState();
}

class _MyMusicDropdownState extends State<MyMusicDropdown> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0 * MediaQSize.widthRefScale, // 定义宽度
      child: DropdownButtonFormField<String>(
        value: _selectedOption,
        onChanged: (value) {
          widget.onSelection(value!);
          widget.onChangedRefresh(
              AudioConfig.leftVolume0_100, AudioConfig.rightVolume0_100);
        },
        decoration: InputDecoration(
          labelText: widget.labelTitle,
          border: const OutlineInputBorder(),
        ),
        items: widget.options.map((option) {
          return DropdownMenuItem<String>(
            value: option,
            // onTap: AudioConfig.refreshVolBar(),
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }
}
