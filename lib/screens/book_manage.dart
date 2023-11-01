import 'package:flutter/material.dart';
import 'package:library_management/components/forms/add_edit_enter_book_detail_form/add_edit_enter_book_detail_form.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/components/label_text_form_field_datepicker.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/models/chi_tiet_phieu_nhap.dart';
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
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
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
                buildEnterBookCards(),
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

    int _totalAmout = 0;
    final totalAmountController = TextEditingController(
      text: 0.toVnCurrencyFormat(),
    );

    List<ChiTietPhieuNhap> _enterbookCards = [
      ChiTietPhieuNhap(1, 1, 1, 4, 52000),
    ];

    bool _isProcessing = false;

    return StatefulBuilder(
      builder: (ctx, setState) => Padding(
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
                      ChiTietPhieuNhap? newEnterBpookDeital = await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AddEditEnterBookDetailForm();
                        },
                      );

                      if (newEnterBpookDeital != null) {
                        setState(() {
                          _enterbookCards.add(newEnterBpookDeital);
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
                    onPressed: 0 == -1
                        ? null
                        : () async {
                            // await showDialog(
                            //   context: context,
                            //   builder: (ctx) => AlertDialog(
                            //     title: const Text('Xác nhận'),
                            //     content: Text(
                            //         'Bạn có chắc xóa Độc giả ${_readerRows[_selectedRow].fullname}?'),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     actions: [
                            //       TextButton(
                            //         onPressed: () {
                            //           Navigator.of(context).pop();
                            //         },
                            //         child: const Text('Huỷ'),
                            //       ),
                            //       FilledButton(
                            //         onPressed: _logicDeleteReader,
                            //         child: const Text('Có'),
                            //       ),
                            //     ],
                            //   ),
                            // );

                            // if (_selectedRow >= _readerRows.length) {
                            //   _selectedRow = -1;
                            // }
                          },
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
                            Expanded(
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
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          children: List.generate(
                            _enterbookCards.length,
                            (index) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                      ),
                                      child: Text(_enterbookCards[index].maCTPN.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              _enterbookCards[index].maSach.toString(),
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.open_in_new_rounded)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: Text(_enterbookCards[index].soLuong.toString()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text(_enterbookCards[index].donGia.toVnCurrencyWithoutSymbolFormat()),
                                    ),
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
                alignment: Alignment.center,
                child: _isProcessing
                    ? const SizedBox(
                        height: 44,
                        width: 44,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : FilledButton(
                        onPressed: () {},
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

  Widget buildEnterBookCards() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        children: [],
      ),
    );
  }
}
