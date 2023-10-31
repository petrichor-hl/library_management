import 'package:flutter/material.dart';
import 'package:library_management/components/forms/add_edit_enter_book_detail_form/them_dau_sach_moi_form.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/components/my_search_bar.dart';
import 'package:library_management/models/enter_book_detail.dart';
import 'package:library_management/utils/common_variables.dart';

class AddEditEnterBookDetailForm extends StatefulWidget {
  const AddEditEnterBookDetailForm({
    super.key,
    this.editEnterBookDetail,
  });

  final EnterBookDetail? editEnterBookDetail;

  @override
  State<AddEditEnterBookDetailForm> createState() => _AddEditEnterBookDetailState();
}

class _AddEditEnterBookDetailState extends State<AddEditEnterBookDetailForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _isOpen = false;
  bool _isQueryingDauSach = false;

  /* Controller cho những TextField nằm trong Dialog Thêm sách mới */

  final _lanTaiBanController = TextEditingController();
  final _nhaXuatBanController = TextEditingController();

  /* Controller cho những TextField nằm trong Dialog Thêm chi tiết nhập sách */
  final _maSachController = TextEditingController();
  final _soLuongController = TextEditingController();
  final _donGiaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _maSachController.dispose();
    _soLuongController.dispose();
    _donGiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return AnimatedPadding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * (_isOpen ? 0.05 : 0.2) - (_isOpen ? 6 : 0)),
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              AnimatedPadding(
                padding: EdgeInsets.only(right: _isOpen ? 12 + screenWidth * 0.3 : 0),
                duration: const Duration(milliseconds: 200),
                child: Dialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(0),
                  child: SizedBox(
                    height: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 30,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MySearchBar(
                            controller: TextEditingController(),
                            onSearch: () {},
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Tất cả Sách',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              FilledButton.icon(
                                onPressed: () => setState(() {
                                  _isOpen = true;
                                }),
                                icon: const Icon(Icons.add_rounded),
                                label: const Text('Thêm mới sách'),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              clipBehavior: Clip.antiAlias,
                              child: DataTable(
                                /* Set màu cho Heading */
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context).colorScheme.primary,
                                ),
                                /* The horizontal margin between the contents of each data column */
                                columnSpacing: 40,
                                dataRowColor: MaterialStateProperty.resolveWith(
                                  (states) => getDataRowColor(context, states),
                                ),
                                dataRowMaxHeight: 62,
                                border: TableBorder.symmetric(),
                                showCheckboxColumn: false,
                                columns: const [
                                  DataColumn(
                                    label: Text(
                                      'Mã Sách',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tên đầu Sách',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Lần Tái Bản',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'NXB',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: [],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              /*
              Thêm Sách mới
              */
              Positioned(
                right: 0,
                child: IgnorePointer(
                  ignoring: !_isOpen,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isOpen ? 1 : 0,
                    child: AnimatedSlide(
                      offset: _isOpen ? const Offset(0, 0) : const Offset(-0.15, 0),
                      duration: const Duration(milliseconds: 200),
                      child: ThemDauSachMoiForm(
                        onClose: () => setState(() {
                          _isOpen = false;
                        }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.editEnterBookDetail == null ? 'THÊM CHI TIẾT NHẬP SÁCH' : 'SỬA CHI TIẾT NHẬP SÁCH',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Mã Sách',
                              controller: _soLuongController,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Số lượng',
                              controller: _soLuongController,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Đơn Giá',
                              controller: _donGiaController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _isProcessing
                          ? const SizedBox(
                              height: 44,
                              width: 44,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton(
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
                                  child: const Text(
                                    'Thêm và Đóng',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                FilledButton(
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
                                  child: const Text(
                                    'Thêm tiếp',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
