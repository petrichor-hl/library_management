import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/label_text_form_field_datepicker.dart';
import 'package:library_management/dto/chi_tiet_phieu_nhap_dto.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/phieu_nhap.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';

class QuanLyPhieuNhap extends StatefulWidget {
  const QuanLyPhieuNhap({super.key});

  @override
  State<QuanLyPhieuNhap> createState() => _QuanLyPhieuNhapState();
}

class _QuanLyPhieuNhapState extends State<QuanLyPhieuNhap> {
  late final List<PhieuNhap> _phieuNhaps;
  late List<PhieuNhap> _filteredPhieuNhaps;
  int selectedRow = -1;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  List<ChiTietPhieuNhapDTO> _chiTietPhieuNhap = [];

  late final Future<void> _futurePhieuNhaps = getPhieuNhaps();
  Future<void> getPhieuNhaps() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    /* Lấy dữ liệu Phiếu Nhập từ database */
    _phieuNhaps = await dbProcess.queryPhieuNhap();
    /* Sắp xếp các Phiếu nhập theo thứ tặng Ngày Lập tăng dần */
    _phieuNhaps.sort((a, b) => a.ngayLap.compareTo(b.ngayLap));
    // for (var phieuNhap in phieuNhaps) {
    //   print("('${phieuNhap.maPhieuNhap}', '${phieuNhap.ngayLap.toVnFormat()}', '${phieuNhap.tongTien}')");
    // }
    if (_phieuNhaps.isNotEmpty) {
      _startDateController.text = _phieuNhaps.first.ngayLap.toVnFormat();
      _endDateController.text = _phieuNhaps.last.ngayLap.toVnFormat();
    }
  }

  @override
  void initState() {
    super.initState();

    _startDateController.addListener(
      () => setState(() {
        _startDate = vnDateFormat.parse(_startDateController.text);
      }),
    );
    _endDateController.addListener(
      () => setState(() {
        _endDate = vnDateFormat.parse(_endDateController.text);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futurePhieuNhaps,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_phieuNhaps.isNotEmpty) {
            _filteredPhieuNhaps = _phieuNhaps
                .where(
                  (element) =>
                      (_startDate.isBefore(element.ngayLap) || _startDate.isAtSameMomentAs(element.ngayLap)) && (element.ngayLap.isBefore(_endDate) || element.ngayLap.isAtSameMomentAs(_endDate)),
                )
                .toList();
          } else {
            _filteredPhieuNhaps = [];
          }
          // print('filteredPhieuNhaps.length = ${filteredPhieuNhaps.length}');

          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Bộ Lọc */
                Row(
                  children: [
                    Expanded(
                      child: LabelTextFieldDatePicker(
                        labelText: 'Từ ngày',
                        controller: _startDateController,
                        initialDateInPicker: _startDate,
                        lastDate: _endDate,
                      ),
                    ),
                    const SizedBox(width: 50),
                    Expanded(
                      child: LabelTextFieldDatePicker(
                        labelText: 'Đến ngày',
                        controller: _endDateController,
                        firstDate: _startDate,
                        initialDateInPicker: _endDate,
                      ),
                    ),
                    // const SizedBox(width: 50),
                    /* Sắp xếp Tổng tiền */
                    // Expanded(
                    //   child: Column(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       const Text(
                    //         'Sắp xếp Tồng tiền: ',
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //       const SizedBox(height: 4),
                    //       DropdownButtonFormField(
                    //         value: 0,
                    //         items: const [
                    //           DropdownMenuItem(
                    //             value: 0,
                    //             child: Text('Không sắp xếp'),
                    //           ),
                    //           DropdownMenuItem(
                    //             value: 1,
                    //             child: Text('Tăng dần'),
                    //           ),
                    //           DropdownMenuItem(
                    //             value: 2,
                    //             child: Text('Giảm dần'),
                    //           )
                    //         ],
                    //         onChanged: (value) {},
                    //         borderRadius: BorderRadius.circular(8),
                    //         decoration: InputDecoration(
                    //           filled: true,
                    //           fillColor: const Color.fromARGB(255, 245, 246, 250),
                    //           hintStyle: const TextStyle(color: Color(0xFF888888)),
                    //           border: OutlineInputBorder(
                    //             borderSide: BorderSide.none,
                    //             borderRadius: BorderRadius.circular(8),
                    //           ),
                    //           contentPadding: const EdgeInsets.all(14),
                    //           isCollapsed: true,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                _phieuNhaps.isEmpty
                    ? const Expanded(
                        child: Center(
                          child: Text(
                            'Chưa có dữ liệu Phiếu nhập',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 583,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Danh sách Phiếu Nhập',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.edit_rounded),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                  const Gap(6),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      clipBehavior: Clip.antiAlias,
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
                                                  width: 70,
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
                                                      'Ngày lập',
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
                                                    padding: EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      'Tổng tiền',
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
                                            child: ListView(
                                              children: List.generate(_filteredPhieuNhaps.length, (index) {
                                                return Column(
                                                  children: [
                                                    Ink(
                                                      color: selectedRow == index ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          selectedRow = index;
                                                          _chiTietPhieuNhap = await dbProcess.queryChiTietPhieuNhapDtoWithMaPhieuNhap(_filteredPhieuNhaps[selectedRow].maPhieuNhap!);
                                                          setState(() {});
                                                        },
                                                        child: Row(
                                                          children: [
                                                            const Gap(30),
                                                            SizedBox(
                                                              width: 70,
                                                              child: Text(
                                                                _filteredPhieuNhaps[index].maPhieuNhap.toString(),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 15,
                                                                  vertical: 15,
                                                                ),
                                                                child: Text(
                                                                  _filteredPhieuNhaps[index].ngayLap.toVnFormat(),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(
                                                                  left: 15,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        _filteredPhieuNhaps[index].tongTien.toVnCurrencyWithoutSymbolFormat(),
                                                                      ),
                                                                    ),
                                                                    const Gap(10),
                                                                    if (selectedRow == index)
                                                                      Icon(
                                                                        Icons.check,
                                                                        color: Theme.of(context).colorScheme.primary,
                                                                      )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const Gap(30),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (index < _filteredPhieuNhaps.length - 1)
                                                      const Divider(
                                                        height: 0,
                                                      ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Gap(50),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Chi tiết Phiếu Nhập',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(6),
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
                                                  width: 60,
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
                                                  flex: 3,
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
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    child: Text(
                                                      'Số lượng',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 15),
                                                    child: Text(
                                                      'Đơn giá',
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
                                            child: ListView(
                                              children: List.generate(_chiTietPhieuNhap.length, (index) {
                                                return Column(
                                                  children: [
                                                    Ink(
                                                      // color: selectedRow == index ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Row(
                                                          children: [
                                                            const Gap(30),
                                                            SizedBox(
                                                              width: 60,
                                                              child: Text(
                                                                _chiTietPhieuNhap[index].maCTPN.toString(),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 15,
                                                                  vertical: 15,
                                                                ),
                                                                child: Text(
                                                                  _chiTietPhieuNhap[index].tenDauSach,
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                  horizontal: 15,
                                                                  vertical: 15,
                                                                ),
                                                                child: Text(
                                                                  _chiTietPhieuNhap[index].soLuong.toString(),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(
                                                                  left: 15,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Text(
                                                                        _chiTietPhieuNhap[index].donGia.toVnCurrencyWithoutSymbolFormat(),
                                                                      ),
                                                                    ),
                                                                    // const Gap(10),
                                                                    // if (selectedRow == index)
                                                                    //   Icon(
                                                                    //     Icons.check,
                                                                    //     color: Theme.of(context).colorScheme.primary,
                                                                    //   )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const Gap(30),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    if (index < _filteredPhieuNhaps.length - 1)
                                                      const Divider(
                                                        height: 0,
                                                      ),
                                                  ],
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          );
        });
  }
}
