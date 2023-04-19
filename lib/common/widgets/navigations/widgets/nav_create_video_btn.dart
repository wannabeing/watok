import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants/sizes.dart';
import '../../darkTheme_config.dart';

class NavCreateVideoButton extends StatelessWidget {
  const NavCreateVideoButton({
    super.key,
    required this.isInverted,
  });

  final bool isInverted;

  @override
  Widget build(BuildContext context) {
    final isDark = darkThemeConfig.value;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: 17,
          child: Container(
            width: 25,
            height: 35,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff61D4F0),
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Positioned(
          left: 17,
          child: Container(
            width: 25,
            height: 35,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size8,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(
                Sizes.size8,
              ),
            ),
          ),
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size10,
          ),
          decoration: BoxDecoration(
            color: !isInverted || isDark ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(
              Sizes.size10,
            ),
          ),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: !isInverted || isDark ? Colors.black : Colors.white,
              size: Sizes.size20,
            ),
          ),
        ),
      ],
    );
  }
}
