import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/gaps.dart';
import 'package:watok/constants/sizes.dart';

class VideoIcon extends StatelessWidget {
  const VideoIcon({
    super.key,
    this.selectedColor,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;
  final selectedColor;

  @override
  Widget build(BuildContext context) {
    bool isNull = false;

    if (text == "null") {
      isNull = true;
    }
    return Column(
      children: [
        if (selectedColor != null) ...[
          FaIcon(
            icon,
            color: selectedColor,
            size: Sizes.size40,
          ),
        ] else ...[
          FaIcon(
            icon,
            color: Colors.white,
            size: Sizes.size40,
          ),
        ],
        Gaps.v5,
        if (!isNull)
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: <Shadow>[
                Shadow(
                  blurRadius: Sizes.size10,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
