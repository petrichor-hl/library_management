import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/label_text_form_field_datepicker.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/phieu_nhap.dart';
import 'package:library_management/screens/book_manage/book_manage.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';

extension QuanLyPhieuNhap on BookManageState {
  Widget buildQuanLyPhieuNhap() {
    late final List<PhieuNhap> phieuNhaps;
    late List<PhieuNhap> filteredPhieuNhaps;
    int selectedRow = -1;

    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    Future<void> getPhieuNhaps() async {
      /* Lấy dữ liệu Phiếu Nhập từ database */
      phieuNhaps = await dbProcess.queryPhieuNhap();
      /* Sắp xếp các Phiếu nhập theo thứ tặng Ngày Lập tăng dần */
      phieuNhaps.sort((a, b) => a.ngayLap.compareTo(b.ngayLap));
      // for (var phieuNhap in phieuNhaps) {
      //   print("('${phieuNhap.maPhieuNhap}', '${phieuNhap.ngayLap.toVnFormat()}', '${phieuNhap.tongTien}')");
      // }
    }

    late final Future<void> futurePhieuNhaps = getPhieuNhaps();

    return FutureBuilder(
        future: futurePhieuNhaps,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (phieuNhaps.isNotEmpty) {
            startDateController.text = phieuNhaps.first.ngayLap.toVnFormat();
            endDateController.text = phieuNhaps.last.ngayLap.toVnFormat();
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
            child: StatefulBuilder(builder: (ctx, setStateColumn) {
              if (startDateController.text.isNotEmpty) {
                DateTime startDate = vnDateFormat.parse(startDateController.text);
                DateTime endDate = vnDateFormat.parse(endDateController.text);

                filteredPhieuNhaps = phieuNhaps
                    .where(
                      (element) =>
                          (startDate.isBefore(element.ngayLap) || startDate.isAtSameMomentAs(element.ngayLap)) && (element.ngayLap.isBefore(endDate) || element.ngayLap.isAtSameMomentAs(endDate)),
                    )
                    .toList();
              } else {
                filteredPhieuNhaps = [];
              }

              // print('filteredPhieuNhaps.length = ${filteredPhieuNhaps.length}');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* Bộ Lọc */
                  Row(
                    children: [
                      Expanded(
                        child: LabelTextFieldDatePicker(
                          labelText: 'Từ ngày',
                          controller: startDateController,
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: LabelTextFieldDatePicker(
                          labelText: 'Đến ngày',
                          controller: endDateController,
                        ),
                      ),
                      const SizedBox(width: 50),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sắp xếp Tồng tiền: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField(
                              value: 0,
                              items: const [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('Không sắp xếp'),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Tăng dần'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('Giảm dần'),
                                )
                              ],
                              onChanged: (value) {},
                              borderRadius: BorderRadius.circular(8),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromARGB(255, 245, 246, 250),
                                hintStyle: const TextStyle(color: Color(0xFF888888)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                isCollapsed: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  phieuNhaps.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 590,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Danh sách Phiếu Nhập',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                                    width: 100,
                                                    child: Text(
                                                      'Mã phiếu',
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
                                                children: List.generate(filteredPhieuNhaps.length, (index) {
                                                  return Column(
                                                    children: [
                                                      Ink(
                                                        color: selectedRow == index ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setStateColumn(
                                                              () => selectedRow = index,
                                                            );
                                                          },
                                                          child: Row(
                                                            children: [
                                                              const Gap(30),
                                                              SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  filteredPhieuNhaps[index].maPhieuNhap.toString(),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    horizontal: 15,
                                                                    vertical: 15,
                                                                  ),
                                                                  child: Text(
                                                                    filteredPhieuNhaps[index].ngayLap.toVnFormat(),
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
                                                                          filteredPhieuNhaps[index].tongTien.toVnCurrencyWithoutSymbolFormat(),
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
                                                      if (index < filteredPhieuNhaps.length - 1)
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
                            ),
                            const Gap(40),
                            Expanded(
                              flex: 3,
                              child: SizedBox(
                                height: 590,
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
                                                children: [],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              );
            }),
          );
        });
  }
}
