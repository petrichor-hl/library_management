import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_management/screens/book_manage.dart';
import 'package:library_management/screens/reader_manage.dart';
import 'package:library_management/screens/regulations.dart';

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
    var windowButtonColors = WindowButtonColors(
      mouseOver: Theme.of(context).colorScheme.primary,
    );
    return Scaffold(
      body: Column(
        children: [
          Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 175, 219, 208),
                  Color.fromARGB(255, 236, 237, 182)
                ],
              ),
            ),
            child: Column(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: MoveWindow(),
                      ),
                      MinimizeWindowButton(colors: windowButtonColors),
                      MaximizeWindowButton(colors: windowButtonColors),
                      CloseWindowButton(),
                    ],
                  ),
                ),
                Padding(
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
                        child: TabBar(
                          controller: _tabController,
                          labelStyle: const TextStyle(fontSize: 16),
                          tabs: const [
                            Tab(
                              text: "Độc giả",
                              height: 70,
                            ),
                            Tab(
                              text: "Quản lý Sách",
                              height: 70,
                            ),
                            Tab(
                              text: "Mượn trả",
                              height: 70,
                            ),
                            Tab(
                              text: "Báo cáo",
                              height: 70,
                            ),
                            Tab(
                              text: "Quy định",
                              height: 70,
                            ),
                          ],
                          indicator: const BoxDecoration(color: Colors.white),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          overlayColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.white.withOpacity(0.5);
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white.withOpacity(0.5);
                            }
                            return Colors.transparent;
                          }),
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
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ReaderManage(),
                BookManage(),
                ReaderManage(),
                BookManage(),
                Regulations(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
