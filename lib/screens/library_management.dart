import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management/screens/book_manage.dart';
import 'package:library_management/screens/reader_manage.dart';

class LibraryManagement extends StatefulWidget {
  const LibraryManagement({super.key});

  @override
  State<LibraryManagement> createState() => _LibraryManagementState();
}

class _LibraryManagementState extends State<LibraryManagement>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 175, 219, 208),
                  Color.fromARGB(255, 236, 237, 182)
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Image.asset(
                    'assets/library.png',
                    width: 50,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SvgPicture.asset('assets/LibraryBOOKS.svg'),
                  const SizedBox(
                    width: 80,
                  ),
                  Expanded(
                    child: TabBar.secondary(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          text: "Độc giả",
                          height: 70,
                        ),
                        Tab(
                          text: "Quản lý Sách",
                        ),
                        Tab(
                          text: "Mượn trả",
                        ),
                        Tab(
                          text: "Báo cáo",
                        ),
                        Tab(
                          text: "Quy định",
                        ),
                      ],
                      indicator: const BoxDecoration(color: Colors.white),
                      dividerColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/profile-user.png'),
                    backgroundColor: Colors.transparent,
                    radius: 18,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                BookManage(),
                ReaderManage(),
                BookManage(),
                ReaderManage(),
                BookManage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
