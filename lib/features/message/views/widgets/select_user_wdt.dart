import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/mypage/models/user_model.dart';

class SelectUserWdt extends ConsumerStatefulWidget {
  final UserModel user;
  final bool isSelected;

  const SelectUserWdt({
    super.key,
    required this.user,
    required this.isSelected,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectUserWdtState();
}

class _SelectUserWdtState extends ConsumerState<SelectUserWdt> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final isSelcted = widget.isSelected;

    return Column(
      children: [
        ListTile(
          leading: Container(
            width: Sizes.size52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.user,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(
            "@${user.name}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Sizes.size18,
            ),
          ),
          subtitle: Text(
            user.bio,
            style: const TextStyle(fontSize: Sizes.size16),
          ),
          trailing: isSelcted
              ? FaIcon(
                  FontAwesomeIcons.circleCheck,
                  color: Theme.of(context).primaryColor,
                )
              : FaIcon(
                  FontAwesomeIcons.circle,
                  size: Sizes.size20,
                  color: Colors.grey.shade400,
                ),
        ),
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
