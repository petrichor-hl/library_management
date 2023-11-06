import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form/add_edit_dau_sach_form.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/dto/dau_sach_dto.dart';
import 'package:library_management/main.dart';
import 'package:library_management/utils/common_variables.dart';

class QuanLyDauSach extends StatefulWidget {
  const QuanLyDauSach({super.key});

  @override
  State<QuanLyDauSach> createState() => _QuanLyDauSachState();
}

class _QuanLyDauSachState extends State<QuanLyDauSach> {
  late final List<DauSachDto> _dauSachs;
  late List<DauSachDto> _filteredDauSachs;

  int _selectedRow = -1;

  final _searchController = TextEditingController();

  late final Future<void> _futureDauSachs = _getDauSachs();
  Future<void> _getDauSachs() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _dauSachs = await dbProcess.queryDauSachDto();
    _filteredDauSachs = List.of(_dauSachs);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureDauSachs,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MySearchBar(
                controller: _searchController,
                onSearch: () {
                  setState(() {
                    String searchText = _searchController.text.toLowerCase();

                    _filteredDauSachs = _dauSachs.where((element) {
                      if (element.tenDauSach.toLowerCase().contains(searchText)) {
                        return true;
                      }

                      if (element.tacGiasToString().toLowerCase().contains(searchText)) {
                        return true;
                      }

                      if (element.theLoaisToString().toLowerCase().contains(searchText)) {
                        return true;
                      }
                      return false;
                    }).toList();
                  });
                },
              ),
              const Gap(20),
              Row(
                children: [
                  const Text(
                    'Danh sách Đầu Sách',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () async {
                      // TODO: Xử lý Thêm Đầu Sách
                      await showDialog(
                        context: context,
                        builder: (ctx) => const AddEditDauSachForm(),
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm đầu sách'),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    ),
                  ),
                  const Gap(12),
                  IconButton.filled(
                    onPressed: _selectedRow == -1 ? null : () async {},
                    icon: const Icon(Icons.delete),
                    style: myIconButtonStyle,
                  ),
                  const Gap(12),
                  /* 
                    Nút "Sửa thông tin Độc Giả" 
                    Logic xử lý _logicEditReader xem ở phần khai báo bên trên
                    */
                  IconButton.filled(
                    onPressed: _selectedRow == -1 ? null : () {},
                    icon: const Icon(Icons.edit),
                    style: myIconButtonStyle,
                  ),
                ],
              ),
              const Gap(10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                '#',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Tên Đầu sách',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Tác giả',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Thể loại',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Số lượng',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: List.generate(
                            _filteredDauSachs.length,
                            (index) {
                              return Column(
                                children: [
                                  Ink(
                                    color: _selectedRow == index ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedRow = index;
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          _selectedRow = index;
                                        });
                                        // logicEditChiTietPhieuNhap(setStateNhapSach);
                                      },
                                      child: Row(
                                        children: [
                                          const Gap(30),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              (index + 1).toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _filteredDauSachs[index].tenDauSach,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _filteredDauSachs[index].tacGiasToString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _filteredDauSachs[index].theLoaisToString(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _filteredDauSachs[index].soLuong.toString(),
                                                  ),
                                                ),
                                                const Gap(10),
                                                if (_selectedRow == index)
                                                  Icon(
                                                    Icons.check,
                                                    color: Theme.of(context).colorScheme.primary,
                                                  )
                                              ],
                                            ),
                                          ),
                                          const Gap(30),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < _filteredDauSachs.length - 1)
                                    const Divider(
                                      height: 0,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
