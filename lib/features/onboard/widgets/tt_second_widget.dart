import 'package:flutter/material.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class TutorialSecondWidget extends StatelessWidget {
  const TutorialSecondWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.v72,
        const Text(
          "튜토리얼 페이지2",
          style: TextStyle(
            fontSize: Sizes.size36,
            fontWeight: FontWeight.w900,
          ),
        ),
        Gaps.v16,
        Text(
          "상세 설명란입니다.상세 설명란입니다.상세 설명란입니다.상세 설명란입니다.상세 설명란입니다.",
          style: TextStyle(
            fontSize: Sizes.size20,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
