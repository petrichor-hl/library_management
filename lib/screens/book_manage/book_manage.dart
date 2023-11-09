import 'package:flutter/material.dart';
import 'package:library_management/screens/book_manage/kho_sach/kho_sach.dart';
import 'package:library_management/screens/book_manage/nhap_sach.dart';
import 'package:library_management/screens/book_manage/quan_ly_dau_sach.dart';
import 'package:library_management/screens/book_manage/quan_ly_phieu_nhap.dart';

class BookManage extends StatefulWidget {
  const BookManage({super.key});

  @override
  State<BookManage> createState() => BookManageState();
}

class BookManageState extends State<BookManage> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 25, 30, 20),
            child: Ink(
              width: 480,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 6,
                ),
                controller: tabController,
                tabs: const [
                  Tab(text: "Kho sách"),
                  Tab(text: 'Đầu Sách'),
                  Tab(text: "Nhập sách"),
                  Tab(text: "Phiếu nhập"),
                ],
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                splashBorderRadius: BorderRadius.circular(8),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
                unselectedLabelColor: Colors.white,
                overlayColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white.withOpacity(0.3);
                  }
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white.withOpacity(0.5);
                  }
                  return Colors.transparent;
                }),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                const KhoSach(),
                const QuanLyDauSach(),
                buildNhapSach(),
                const QuanLyPhieuNhap(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
