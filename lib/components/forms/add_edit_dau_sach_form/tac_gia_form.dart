import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/tac_gia.dart';

class TacGiaForm extends StatefulWidget {
  const TacGiaForm({super.key});

  @override
  State<TacGiaForm> createState() => _TacGiaFormState();
}

class _TacGiaFormState extends State<TacGiaForm> {
  late final List<TacGia> _tacGias;
  late List<TacGia> _filteredTacGias;

  late final Future<void> _futureTacGias = _getTacGias();
  Future<void> _getTacGias() async {
    _tacGias = await dbProcess.queryTacGias();
    _filteredTacGias = List.of(_tacGias);
  }

  final _themTacGiaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: FutureBuilder(
            future: _futureTacGias,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: [
                  const Text(
                    'TÁC GIẢ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _themTacGiaController,
                      decoration: InputDecoration(
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(
                            right: 8,
                          ),
                          child: Icon(Icons.add_rounded),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          maxWidth: 32,
                        ),
                        hintText: 'Thêm Tác giả',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      ),
                      onEditingComplete: () async {
                        // Thêm Tác Giả mới vào Database
                        TacGia newTacGia = TacGia(
                          null,
                          _themTacGiaController.text,
                        );
                        int returningId = await dbProcess.insertTacGia(newTacGia);
                        newTacGia.maTacGia = returningId;

                        /* Cập nhật lại danh sách Tác Giả */
                        setState(() {
                          _tacGias.insert(0, newTacGia);
                          _themTacGiaController.clear();
                        });
                      },
                    ),
                  ),
                  /* TODO: Tìm kiếm Tác Giả */
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   child: TextField(
                  //     controller: _timTenDauSachController,
                  //     decoration: InputDecoration(
                  //       prefixIcon: const Padding(
                  //         padding: EdgeInsets.only(
                  //           right: 8,
                  //         ),
                  //         child: Icon(Icons.search),
                  //       ),
                  //       prefixIconConstraints: const BoxConstraints(
                  //         maxWidth: 32,
                  //       ),
                  //       hintText: 'Tìm tên Đầu sách',
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  //     ),
                  //     onEditingComplete: () {
                  //       setStateColumn(() {});
                  //     },
                  //     onChanged: (value) async {
                  //       if (value.isEmpty) {
                  //         await Future.delayed(const Duration(milliseconds: 50));
                  //         setStateColumn(() {});
                  //       }
                  //     },
                  //   ),
                  // ),
                  /* Danh sách Tác Giả */
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        _filteredTacGias.length,
                        (index) => ListTile(
                          onTap: () {},
                          title: Text(
                            _filteredTacGias[index].tenTacGia,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
