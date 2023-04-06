import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants/sizes.dart';

class MyPagePersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(
            width: 1,
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: TabBar(
        splashFactory: NoSplash.splashFactory,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.black,
        labelPadding: const EdgeInsets.symmetric(vertical: Sizes.size10),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.size44),
            child: Icon(Icons.grid_on_outlined),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.size44),
            child: FaIcon(FontAwesomeIcons.heart),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 46;

  @override
  double get minExtent => 46;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
