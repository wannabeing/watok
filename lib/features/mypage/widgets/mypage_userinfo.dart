import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class MyPageUserInfo extends StatefulWidget {
  const MyPageUserInfo({
    super.key,
    required this.text,
    required this.num,
  });

  final String text; // 팔로워 || 팔로우 ||
  final int num;

  @override
  State<MyPageUserInfo> createState() => _MyPageUserInfoState();
}

class _MyPageUserInfoState extends State<MyPageUserInfo> {
  @override
  Widget build(BuildContext context) {
    var fNum = NumberFormat('###,###,###,###');
    String nums = fNum.format(widget.num);
    String text = widget.text;

    return Column(
      children: [
        Text(
          nums,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v5,
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Sizes.size16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
