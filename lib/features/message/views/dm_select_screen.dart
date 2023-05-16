import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:watok/constants/sizes.dart';
import 'package:watok/features/authentication/repos/auth_repo.dart';
import 'package:watok/features/message/views/widgets/select_user_wdt.dart';
import 'package:watok/features/message/vms/chatroom_vm.dart';
import 'package:watok/features/message/vms/msg_select_vm.dart';

class DmSelectScreen extends ConsumerStatefulWidget {
  const DmSelectScreen({super.key});
  static const String route = "dmSelect";
  static const String name = "dmSelect";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DmSelectScreenState();
}

class _DmSelectScreenState extends ConsumerState<DmSelectScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0; // 스크롤 위치
  int _selectedIndex = -1; // 선택한 대화상대 index 번호
  String _selectedUid = '';

  // 선택한 대화상대와 채팅방 생성 함수
  Future<void> _startDM(String uid) async {
    final me = ref.read(authRepository).user!.uid;
    await ref.read(chatRoomProvider.notifier).createChatRoom(me: me, you: uid);
  }

  // 무한 스크롤 구현 함수
  Future<void> _onScroll() async {
    // 스크롤 위치 변수 선언
    _scrollPosition = _scrollController.position.pixels /
        _scrollController.position.maxScrollExtent;

    if (_scrollPosition >= 0.55) {
      await ref.read(msgSelectViewModel.notifier).getNextUsers();
    }
    setState(() {});
  }

  // 더보기 클릭 함수
  Future<void> _onAddedPeople() async {
    // 더 많은 대화상대유저 가져오기
    await ref.read(msgSelectViewModel.notifier).getNextUsers();
  }

  // 대화상대유저 선택 함수
  void _onSelect({required int index, required String uid}) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = -1; // 중복 선택시 인덱스값 초기화
        _selectedUid = ''; // 중복 선택시 선택UID값 초기화
      } else {
        _selectedIndex = index; // 선택한 인덱스값 저장
        _selectedUid = uid;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _onScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("대화상대 선택"),
        elevation: 1,
        actions: [
          GestureDetector(
            onTap: () => _selectedIndex == -1 ? null : _startDM(_selectedUid),
            child: Padding(
              padding: const EdgeInsets.only(right: Sizes.size18),
              child: Text(
                "확인",
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: _selectedIndex == -1
                      ? Colors.grey.shade400
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ref.watch(msgSelectViewModel).when(
            data: (userList) {
              return Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  addAutomaticKeepAlives: true, // true: 화면에 사라진 위젯을 유지되게 해준다.
                  controller: _scrollController,
                  itemCount: userList.length,
                  padding: const EdgeInsets.only(top: Sizes.size14),
                  itemBuilder: (BuildContext context, int index) {
                    // 유저정보
                    final user = userList[index];
                    // 마지막 SelectUserWdt 밑에 더보기 위젯 추가
                    if (index == userList.length - 1) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => _onSelect(index: index, uid: user.uid),
                            child: SelectUserWdt(
                              user: user,
                              isSelected: _selectedIndex == index,
                            ),
                          ),
                          GestureDetector(
                            onTap: _onAddedPeople,
                            child: Container(
                              padding: const EdgeInsets.only(top: Sizes.size10),
                              child: const Text(
                                "더보기",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    // 반복 빌드되는 위젯
                    else {
                      return GestureDetector(
                        onTap: () => _onSelect(index: index, uid: user.uid),
                        child: SelectUserWdt(
                          user: user,
                          isSelected: _selectedIndex == index,
                        ),
                      );
                    }
                  },
                ),
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Text(
                "$error",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
    );
  }
}
