import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/dto/cuon_sach_dto.dart';
import 'package:library_management/main.dart';
import 'package:library_management/utils/extension.dart';

class KetQuaTimKiem extends StatefulWidget {
  const KetQuaTimKiem({
    super.key,
    required this.keyword,
  });

  final String keyword;

  @override
  State<KetQuaTimKiem> createState() => _KetQuaTimKiemState();
}

class _KetQuaTimKiemState extends State<KetQuaTimKiem> {
  late List<CuonSachDto> _cuonSachs;

  // int _selectedRow = -1;

  Future<void> _getCuonSachs() async {
    /* 
    Delay 1 khoảng bằng thời gian
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(const Duration(milliseconds: 300));
    _cuonSachs = await dbProcess.queryCuonSachWithKeyword(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // TODO: Add note here
        future: _getCuonSachs(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_cuonSachs.isEmpty) {
            return Text(
              'Không tìm thấy cuốn sách khớp với từ khóa "${widget.keyword}"',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            );
          }

          return ClipRRect(
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
                        width: 50,
                        child: Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Text(
                            '#',
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
                            'Lần Tái Bản',
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
                            'NXB',
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
                            'Tình trạng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Vị trí',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Mã CTPN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Ink(
                            // color: _selectedRow == index ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   _selectedRow = index;
                                // });
                              },
                              // onLongPress: () {
                              //   setState(() {
                              //     _selectedRow = index;
                              //   });
                              //   // logicEditChiTietPhieuNhap(setStateNhapSach);
                              // },
                              child: Row(
                                children: [
                                  const Gap(30),
                                  SizedBox(
                                    width: 50,
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
                                        _cuonSachs[index].tenDauSach.capitalizeFirstLetter(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        _cuonSachs[index].lanTaiBan.toString(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        _cuonSachs[index].nhaXuatBan,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        _cuonSachs[index].tinhTrang,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 280,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        _cuonSachs[index].viTri,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 90,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        _cuonSachs[index].maCTPN.toString(),
                                      ),
                                    ),
                                  ),
                                  const Gap(30),
                                ],
                              ),
                            ),
                          ),
                          if (index < _cuonSachs.length - 1)
                            const Divider(
                              height: 0,
                            ),
                        ],
                      );
                    },
                    itemCount: _cuonSachs.length,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
