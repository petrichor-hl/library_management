import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/the_loai.dart';

class TheLoaiForm extends StatefulWidget {
  const TheLoaiForm({super.key});

  @override
  State<TheLoaiForm> createState() => _TheLoaiFormState();
}

class _TheLoaiFormState extends State<TheLoaiForm> {
  late final List<TheLoai> _theLoais;
  late List<TheLoai> _filteredTheLoais;

  late final Future<void> _futureTacGias = _getTacGias();
  Future<void> _getTacGias() async {
    _theLoais = await dbProcess.queryTheLoais();
    _filteredTheLoais = List.of(_theLoais);
  }

  final _themTheLoaiController = TextEditingController();

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
                    'THỂ LOẠI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _themTheLoaiController,
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
                        hintText: 'Thêm Thể loại',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      ),
                      onEditingComplete: () async {
                        // Thêm Tác Giả mới vào Database
                        TheLoai newTheLoai = TheLoai(
                          null,
                          _themTheLoaiController.text,
                          "",
                        );
                        int returningId = await dbProcess.insertTheLoai(newTheLoai);
                        newTheLoai.maTheLoai = returningId;

                        /* Cập nhật lại danh sách Tác Giả */
                        setState(() {
                          _theLoais.insert(0, newTheLoai);
                          _themTheLoaiController.clear();
                        });
                      },
                    ),
                  ),
                  /* TODO: Tìm kiếm Thể loại */
                  /* Danh sách thể loại */
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        _filteredTheLoais.length,
                        (index) => ListTile(
                          onTap: () {},
                          title: Text(
                            _filteredTheLoais[index].tenTheLoai,
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
