import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/lich_su_tim_kiem.dart';
import 'package:library_management/screens/borrow_return/quan_ly_muon_tra/danh_sach_muon_tra.dart';

class QuanLyMuonTra extends StatefulWidget {
  const QuanLyMuonTra({super.key});

  @override
  State<QuanLyMuonTra> createState() => _QuanLyMuonTraState();
}

class _QuanLyMuonTraState extends State<QuanLyMuonTra> {
  final _searchController = TextEditingController();

  late List<LichSuTimKiem> _lichSuTimKiemDocGia;

  late final Future<void> _futureLichSuTimKiemDocGias = _getLichSuTimKiemDocGias();
  Future<void> _getLichSuTimKiemDocGias() async {
    /*
    Delay 1 khoảng bằng thời gian animation của TabController
    Tạo chuyển động mượt mà
    */
    await Future.delayed(kTabScrollDuration);
    _lichSuTimKiemDocGia = await dbProcess.queryLichSuTimKiem(loaiTimKiem: 'DocGia');
  }

  void updateTuKhoaTimKiemGanDay(int index) {
    /* Cập nhật lại thời gian tìm kiếm cho LichSuTimKiemCuonSach này */
    _lichSuTimKiemDocGia[index].searchTimestamp = DateTime.now().millisecondsSinceEpoch;

    /* Update DB */
    dbProcess.updateSearchTimestampLichSuTimKiem(_lichSuTimKiemDocGia[index]);

    /* Cho Từ khóa vừa Click lên đầu mảng */
    final element = _lichSuTimKiemDocGia.removeAt(index);
    _lichSuTimKiemDocGia.insert(0, element);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MySearchBar(
          controller: _searchController,
          hintText: 'Tìm kiếm Mã hoặc Tên Độc giả',
          onSearch: (value) {
            /* 
              Phòng trường hợp gõ tiếng việt
              VD: o -> (rỗng) -> ỏ
              Lúc này, value sẽ bằng '' (rỗng) nhưng _searchController.text lại bằng "ỏ"
              */
            if (_searchController.text == value) {
              setState(() {});
              String searchText = _searchController.text.toLowerCase();
              if (searchText.isEmpty) {
                return;
              }
              int index = _lichSuTimKiemDocGia.indexWhere((element) => element.tuKhoa == searchText);
              // print('index = $index');
              if (index == -1) {
                /* 
                  Từ khóa không khớp với những từ khóa hiện tại
                  => Thêm mới từ khóa tìm kiếm gần đây 
                  */
                final newLichSuTimKiem = LichSuTimKiem(
                  DateTime.now().millisecondsSinceEpoch,
                  'DocGia',
                  searchText,
                );

                _lichSuTimKiemDocGia.insert(0, newLichSuTimKiem);
                dbProcess.insertLichSuTimKiem(newLichSuTimKiem);

                /* Giới hạn chỉ lưu 12 từ khóa tìm kiếm gần đây */
                if (_lichSuTimKiemDocGia.length > 12) {
                  /* Nếu quá 12 từ, tức là đang 13 từ khóa thì xóa từ khóa có timestamp nhỏ nhất */
                  int minTimestampIndex = 0;
                  for (int i = 1; i < _lichSuTimKiemDocGia.length; ++i) {
                    if (_lichSuTimKiemDocGia[i].searchTimestamp < _lichSuTimKiemDocGia[minTimestampIndex].searchTimestamp) {
                      minTimestampIndex = i;
                    }
                  }
                  // print(_lichSuTimKiemCuonSachs[minTimestampIndex].tuKhoa);
                  dbProcess.deleteLichSuTimKiem(_lichSuTimKiemDocGia[minTimestampIndex]);
                  _lichSuTimKiemDocGia.removeAt(minTimestampIndex);
                }
              } else {
                // updateTuKhoaTimKiemGanDay(index);
              }
            }
          },
        ),
        const Gap(20),
        if (_searchController.text.isEmpty)
          const Text(
            'Danh sách Tìm kiếm gần đây',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        const Gap(8),
        FutureBuilder(
          future: _futureLichSuTimKiemDocGias,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (_lichSuTimKiemDocGia.isEmpty) {
              return const Text(
                'Chưa có dữ liệu',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                ),
              );
            }

            return _searchController.text.isEmpty
                ? Expanded(
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 380,
                        mainAxisExtent: 54,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      children: List.generate(
                        _lichSuTimKiemDocGia.length,
                        (index) {
                          bool isHover = false;
                          return Ink(
                            /* 
                            Thêm key ở đây để khi xóa hàng loạt các Từ khóa Tìm kiếm Gần đây sẽ không gặp lỗi 
                            (lỗi này không gây ra crash hệ thống)
                            Thử comment dòng "key: ValueKey(...)" để thấy.
                            */
                            key: ValueKey(_lichSuTimKiemDocGia[index]),
                            color: Colors.grey.withOpacity(0.1),
                            child: StatefulBuilder(
                              builder: (ctx, setStateInkWell) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _searchController.text = _lichSuTimKiemDocGia[index].tuKhoa;
                                    });

                                    updateTuKhoaTimKiemGanDay(index);
                                  },
                                  onHover: (value) => setStateInkWell(() => isHover = value),
                                  hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          _lichSuTimKiemDocGia[index].tuKhoa,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isHover ? Colors.white : Colors.black,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const Spacer(),
                                        /* Nút Xóa lịch sử tìm kiếm Cuốn Sách */
                                        if (isHover)
                                          IconButton(
                                            onPressed: () {
                                              dbProcess.deleteLichSuTimKiem(_lichSuTimKiemDocGia[index]);
                                              setState(() {
                                                _lichSuTimKiemDocGia.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(Icons.close, color: Colors.white),
                                            style: IconButton.styleFrom(
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: DanhSachMuonTra(
                      keyword: _searchController.text,
                    ),
                  );
          },
        ),
      ],
    );
  }
}
