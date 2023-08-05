// 这是一个简单的Flutter widget，它可以抽象封装成一个横向选择按钮。
// 您可以在主函数中调用它，并传入“题目”和“选项”作为参数，以显示所需的内容并获取所选选项。

import 'package:flutter/material.dart';

import '../configs/media_QSize.dart';

class HorizontalOptionSelector extends StatefulWidget {
  final String title;
  final List<String> options;

  const HorizontalOptionSelector(
      {Key? key, required this.title, required this.options})
      : super(key: key);

  @override
  _HorizontalOptionSelectorState createState() =>
      _HorizontalOptionSelectorState();
}

class _HorizontalOptionSelectorState extends State<HorizontalOptionSelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title,
            style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
        SizedBox(height: 50 * MediaQSize.heightRefScale),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.options
              .asMap()
              .entries
              .map(
                (entry) => ElevatedButton(
                  onPressed: () => setState(() => _selectedIndex = entry.key),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        _selectedIndex == entry.key
                            ? Colors.blue
                            : Colors.grey[300]),
                    foregroundColor: MaterialStateProperty.all(
                        _selectedIndex == entry.key
                            ? Colors.white
                            : Colors.black),
                  ),
                  child: Text(entry.value,
                      style: TextStyle(
                          fontSize: (20 * MediaQSize.heightRefScale))),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
