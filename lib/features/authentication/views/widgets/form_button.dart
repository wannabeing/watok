import 'package:flutter/material.dart';

import '../../../../common/widgets/darkTheme_config.dart';
import '../../../../constants/sizes.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
    required this.btnText,
  });

  final bool disabled;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(
          Sizes.size16,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              Sizes.size8,
            ),
          ),
          color: disabled
              ? darkThemeConfig.value
                  ? Colors.grey.shade600
                  : Colors.grey.shade300
              : Theme.of(context).primaryColor,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: Sizes.size16,
            color: disabled ? Colors.grey.shade400 : Colors.white,
          ),
          child: Text(
            btnText,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
