import 'package:flutter/material.dart';

import 'keyboard_key.dart';

class CustomKeyboardScreen extends StatefulWidget {
  const CustomKeyboardScreen({super.key});

  @override
  _CustomKeyboardScreenState createState() => _CustomKeyboardScreenState();
}

class _CustomKeyboardScreenState extends State<CustomKeyboardScreen> {
  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [
      '',
      '0',
      const Icon(
        Icons.keyboard_backspace,
      ),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: keys
            .map(
              (x) => Row(
                children: x.map((y) {
                  return Expanded(
                    child: KeyboardKey(
                      label: y,
                      onTap: (val) {},
                      value: y,
                    ),
                  );
                }).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
