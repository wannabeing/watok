import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/message/activity_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _onDmPressed() {}

    void _onActivityScreen(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ActivityScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("메시지"),
        actions: [
          IconButton(
            onPressed: _onDmPressed,
            icon: const FaIcon(
              FontAwesomeIcons.paperPlane,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => _onActivityScreen(context),
            title: const Text(
              "액티비티",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.size18,
              ),
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size16,
              color: Colors.black,
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          ListTile(
            leading: Container(
              width: Sizes.size52,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.users,
                  color: Colors.white,
                ),
              ),
            ),
            title: const Text(
              "팔로워",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.size18,
              ),
            ),
            subtitle: const Text(
              "서브 타이틀입니다.",
              style: TextStyle(fontSize: Sizes.size16),
            ),
            trailing: const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: Sizes.size16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
