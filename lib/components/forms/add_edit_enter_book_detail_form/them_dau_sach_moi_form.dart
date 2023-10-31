import 'package:flutter/material.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/dau_sach.dart';

class ThemDauSachMoiForm extends StatefulWidget {
  const ThemDauSachMoiForm({
    super.key,
    required this.onClose,
  });

  final void Function() onClose;

  @override
  State<ThemDauSachMoiForm> createState() => _ThemDauSachMoiState();
}

class _ThemDauSachMoiState extends State<ThemDauSachMoiForm> {
  late final List<DauSach> _dauSachs;
  int _selectedIndex = -1;

  late final Future<void> _futureDauSachs = _getDauSachs();
  Future<void> _getDauSachs() async {
    _dauSachs = await dbProcess.queryDauSach();
  }

  /* Key này dùng để xác định vị trí của Inkwell Chọn Đầu sách */
  final _chonDauSachKey = GlobalKey();
  final _timTenDauSachController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: SizedBox(
        width: screenWidth * 0.3,
        height: 500,
        child: FutureBuilder(
            future: _futureDauSachs,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<DauSach> filteredDauSachs = List.of(_dauSachs);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'THÊM SÁCH MỚI',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.arrow_back_rounded),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Đầu sách',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Ink(
                      height: 44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 246, 250),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      /* 
                      Xài StatefulBuilder để chỉ mỗi InkWell được render lại khi 1 ListTile được chọn 
                      Không phải render toàn bộ Widget 
                      */
                      child: StatefulBuilder(builder: (ctx, setStateInkWell) {
                        return InkWell(
                          key: _chonDauSachKey,
                          onTap: () {
                            /* Lấy vị trí của InkWell Widget đã được render trên màn hình
                            để show menu đúng vị trị đó */
                            RenderObject? renderObject = _chonDauSachKey.currentContext!.findRenderObject();
                            Offset widgetPosition = (renderObject as RenderBox).localToGlobal(Offset.zero);

                            final themDauSachController = TextEditingController();
                            /* Hiện custom Menu của Lâm */
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                /*
                                Dùng Stack + Positioned để kiểm soát được vị trí xuất hiện của Menu (Card) 
                                */
                                return Stack(
                                  children: [
                                    Positioned(
                                      top: widgetPosition.dy + 46,
                                      left: widgetPosition.dx,
                                      child: Card(
                                        margin: const EdgeInsets.all(0),
                                        elevation: 4,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(6),
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Ink(
                                          width: screenWidth * 0.3 - 60,
                                          color: Colors.white,
                                          /* 
                                          Xài StatefulBuilder để chỉ mỗi Column được render lại khi Thêm 1 Đầu Sách hoặc Lọc Đầu Sách
                                          Không phải render toàn bộ Widget 
                                          */
                                          child: StatefulBuilder(
                                            builder: (ctx, setStateColumn) {
                                              String searchText = _timTenDauSachController.text;
                                              if (searchText.isEmpty) {
                                                filteredDauSachs = List.of(_dauSachs);
                                              } else {
                                                filteredDauSachs = _dauSachs.where((element) => element.tenDauSach.toLowerCase().contains(searchText.toLowerCase())).toList();
                                              }
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  /* Thêm Đầu Sách */
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: TextField(
                                                      controller: themDauSachController,
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
                                                        hintText: 'Thêm Đầu sách',
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide.none,
                                                        ),
                                                        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                                                      ),
                                                      onEditingComplete: () async {
                                                        // Thêm Đầu sách mới vào Database
                                                        DauSach newDauSach = DauSach(
                                                          null,
                                                          themDauSachController.text,
                                                        );
                                                        int returningId = await dbProcess.insertDauSach(newDauSach);
                                                        newDauSach.id = returningId;
                                                        setStateColumn(() {
                                                          _dauSachs.insert(0, newDauSach);
                                                          themDauSachController.text = "";
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  /* Tìm kiếm Đầu Sách */
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: TextField(
                                                      controller: _timTenDauSachController,
                                                      decoration: InputDecoration(
                                                        prefixIcon: const Padding(
                                                          padding: EdgeInsets.only(
                                                            right: 8,
                                                          ),
                                                          child: Icon(Icons.search),
                                                        ),
                                                        prefixIconConstraints: const BoxConstraints(
                                                          maxWidth: 32,
                                                        ),
                                                        hintText: 'Tìm tên Đầu sách',
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide.none,
                                                        ),
                                                        contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                                                      ),
                                                      onEditingComplete: () {
                                                        setStateColumn(() {});
                                                      },
                                                      onChanged: (value) async {
                                                        if (value.isEmpty) {
                                                          await Future.delayed(const Duration(milliseconds: 50));
                                                          setStateColumn(() {});
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  /* Danh sách các Đầu sách */
                                                  ConstrainedBox(
                                                    constraints: const BoxConstraints(maxHeight: 190),
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        children: List.generate(
                                                          filteredDauSachs.length,
                                                          (index) => ListTile(
                                                            onTap: () {
                                                              setStateInkWell(
                                                                () => _selectedIndex = index,
                                                              );
                                                              Navigator.of(context).pop();
                                                            },
                                                            title: Text(filteredDauSachs[index].tenDauSach),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              barrierColor: Colors.transparent,
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedIndex == -1 ? "" : filteredDauSachs[_selectedIndex].tenDauSach,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down)
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    LabelTextFormField(
                      labelText: 'Lần tái bản',
                    ),
                    const SizedBox(height: 14),
                    LabelTextFormField(
                      labelText: 'Nhà xuất bản',
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        ),
                        child: const Text('Thêm'),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
