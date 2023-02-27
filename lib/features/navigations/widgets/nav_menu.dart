import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({
    super.key,
    required this.iconText,
    required this.isSelected,
    required this.icon,
    required this.onTap,
    required this.selectedIcon,
  });

  final String iconText;
  final bool isSelected;
  final IconData icon;
  final IconData selectedIcon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => {
          HapticFeedback.vibrate(), // 미세한 햅틱반응 넣기
          onTap(),
        },
        child: Container(
          color: Colors.black,
          child: AnimatedOpacity(
            duration: const Duration(
              milliseconds: 200,
            ),
            opacity: isSelected ? 1 : 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  isSelected ? selectedIcon : icon,
                  color: Colors.white,
                ),
                Gaps.v10,
                Text(
                  iconText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
