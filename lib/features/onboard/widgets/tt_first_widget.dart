import 'package:flutter/material.dart';

import '../../../constants/gaps.dart';
import '../../../constants/sizes.dart';

class TutorialFirstWidget extends StatelessWidget {
  const TutorialFirstWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Gaps.v72,
        Text(
          "튜토리얼 페이지1",
          style: TextStyle(
            fontSize: Sizes.size36,
            fontWeight: FontWeight.w900,
          ),
        ),
        Gaps.v16,
        Opacity(
          opacity: 0.7,
          child: Text(
            "상세 설명란입니다.상세 설명란입니다.상세 설명란입니다.상세 설명란입니다.상세 설명란입니다.",
            style: TextStyle(
              fontSize: Sizes.size20,
            ),
          ),
        ),
      ],
    );
  }
}
