import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/forms/add_edit_enter_book_detail_form/add_edit_enter_book_detail_form.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/components/label_text_form_field_datepicker.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/cubit/tat_ca_sach_cubit.dart';
import 'package:library_management/main.dart';
import 'package:library_management/models/chi_tiet_phieu_nhap.dart';
import 'package:library_management/models/phieu_nhap.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';

class BookManage extends StatefulWidget {
  const BookManage({super.key});

  @override
  State<BookManage> createState() => _BookManageState();
}

class _BookManageState extends State<BookManage> with TickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
              width: 370,
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
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: "Kho sách",
                  ),
                  Tab(
                    text: "Nhập sách",
                  ),
                  Tab(
                    text: "Phiếu nhập",
                  ),
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
              controller: _tabController,
              children: [
                buildBookWarehouseSection(),
                buildEnterBook(),
                buildchiTietPhieuNhaps(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookWarehouseSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySearchBar(
            controller: _searchController,
            onSearch: () {},
          ),
          const SizedBox(height: 20),
          const Text(
            'Danh sách Sách',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(
            child: Row(
              children: [
                Expanded(child: Text('Đầu sách')),
                Expanded(
                  flex: 2,
                  child: Text('Sách'),
                ),
                Expanded(child: Text('Cuốn sách')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnterBook() {
    final dateAddedController = TextEditingController(
      text: DateTime.now().toVnFormat(),
    );

    int totalAmout = 0;
    final totalAmountController = TextEditingController(text: '0');

    List<ChiTietPhieuNhap> chiTietPhieuNhaps = [];

    bool isProcessing = false;

    void savePhieuNhap(Function(void Function()) setStateNhapSach) async {
      setStateNhapSach(() {
        isProcessing = true;
      });

      int maPhieuNhap = await dbProcess.insertPhieuNhap(
        PhieuNhap(
          null,
          vnDateFormat.parse(dateAddedController.text),
          totalAmout,
        ),
      );

      for (var chiTietPhieuNhap in chiTietPhieuNhaps) {
        chiTietPhieuNhap.maPhieuNhap = maPhieuNhap;
        dbProcess.insertChiTietPhieuNhap(chiTietPhieuNhap);
      }
      setStateNhapSach(() {
        totalAmout = 0;
        totalAmountController.text = '0';
        chiTietPhieuNhaps.clear();
        isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tạo Phiếu Nhập sách thành công.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 350,
            action: SnackBarAction(
              label: 'Xem',
              onPressed: () => _tabController.animateTo(2),
            ),
          ),
        );
      }
    }

    return StatefulBuilder(
      builder: (ctx, setStateNhapSach) => Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: LabelTextFieldDatePicker(
                      labelText: 'Ngày nhập',
                      controller: dateAddedController,
                    ),
                  ),
                  const SizedBox(width: 80),
                  /* Tổng tiền */
                  Expanded(
                    child: LabelTextFormField(
                      labelText: 'Tổng tiền:',
                      controller: totalAmountController,
                      isEnable: false,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton.filled(
                    onPressed: () async {
                      List<ChiTietPhieuNhap>? newChiTietPhieuNhaps = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AddEditEnterBookDetailForm();
                        },
                      );

                      if (newChiTietPhieuNhaps != null) {
                        setStateNhapSach(() {
                          for (var chiTietPhieuNhap in newChiTietPhieuNhaps) {
                            totalAmout += chiTietPhieuNhap.tongTien;
                            chiTietPhieuNhaps.add(chiTietPhieuNhap);
                          }
                          totalAmountController.text = totalAmout.toVnCurrencyFormat();
                        });
                      }
                    },
                    icon: const Icon(Icons.add_rounded),
                    style: myIconButtonStyle,
                  ),
                  const SizedBox(width: 12),
                  /* 
                  */
                  IconButton.filled(
                    onPressed: 0 == -1 ? null : () async {},
                    icon: const Icon(Icons.delete),
                    style: myIconButtonStyle,
                  ),
                  const SizedBox(width: 12),
                  /* 
                  Edit Chi tiết nhập sách
                  */
                  IconButton.filled(
                    onPressed: 0 == -1 ? null : () {},
                    icon: const Icon(Icons.edit),
                    style: myIconButtonStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                                  'Mã Sách',
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
                          children: List.generate(
                            chiTietPhieuNhaps.length,
                            (index) {
                              return Column(
                                children: [
                                  Row(
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
                                            context.read<TatCaSachCubit>().getTenDauSach(chiTietPhieuNhaps[index].maSach),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            chiTietPhieuNhaps[index].maSach.toString(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text(chiTietPhieuNhaps[index].soLuong.toString()),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 15,
                                          ),
                                          child: Text(chiTietPhieuNhaps[index].donGia.toVnCurrencyWithoutSymbolFormat()),
                                        ),
                                      ),
                                      const Gap(30),
                                    ],
                                  ),
                                  if (index < chiTietPhieuNhaps.length - 1)
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
              Align(
                alignment: Alignment.centerRight,
                child: isProcessing
                    ? const SizedBox(
                        width: 91,
                        child: Center(
                          child: SizedBox(
                            height: 44,
                            width: 44,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ),
                      )
                    : FilledButton(
                        onPressed: () => savePhieuNhap(setStateNhapSach),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 30,
                          ),
                        ),
                        child: const Text(
                          'Save',
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          )),
    );
  }

  Widget buildchiTietPhieuNhaps() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        children: [],
      ),
    );
  }
}
