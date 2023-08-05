import 'package:flutter/material.dart';

import '../configs/media_QSize.dart';

class MyRadioButtonTemp extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String) onSelection;

  const MyRadioButtonTemp(
      {required this.title, required this.options, required this.onSelection});

  @override
  _MyRadioButtonTempState createState() => _MyRadioButtonTempState();
}

class _MyRadioButtonTempState extends State<MyRadioButtonTemp> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50 * MediaQSize.heightRefScale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.title,
              style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
          SizedBox(height: 40 * MediaQSize.heightRefScale),
          const Divider(),
          ...widget.options.map(
            (option) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 180 * MediaQSize.widthRefScale),
                  child: RadioListTile<String>(
                    title: Text(option,
                        style: TextStyle(
                            fontSize: (25 * MediaQSize.heightRefScale))),
                    value: option,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                        widget.onSelection(value!);
                      });
                    },
                  ),
                ),
                SizedBox(
                    height: 20 * MediaQSize.heightRefScale), // 您可以更改此值以调整间距
                const Divider(),
              ],
            ),
          ),

          // 您可以更改此值以调整间距
        ],
      ),
    );
  }
}
