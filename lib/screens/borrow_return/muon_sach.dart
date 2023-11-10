import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/label_text_form_field.dart';
import 'package:library_management/components/label_text_form_field_datepicker.dart';
import 'package:library_management/main.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';
import 'package:library_management/utils/parameters.dart';

class MuonSach extends StatefulWidget {
  const MuonSach({super.key});

  @override
  State<MuonSach> createState() => _MuonSachState();
}

class _MuonSachState extends State<MuonSach> {
  final _searchMaDocGiaController = TextEditingController();

  final _ngayMuonController = TextEditingController(
    text: DateTime.now().toVnFormat(),
  );

  bool _isProcessing = false;

  String _hoTenDocGia = '';
  String _errorText = '';

  void _onSearchMaDocGia() async {
    _errorText = '';
    if (_searchMaDocGiaController.text.isEmpty) {
      _errorText = 'Bạn chưa nhập Mã Độc giả.';
    } else {
      if (int.tryParse(_searchMaDocGiaController.text) == null) {
        _errorText = 'Mã Độc giả là một con số.';
      }
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    _hoTenDocGia = '';

    String? hoTen = await dbProcess.queryHoTenDocGiaWithMaDocGia(int.parse(_searchMaDocGiaController.text));
    await Future.delayed(const Duration(milliseconds: 300));
    if (hoTen == null) {
      _errorText = 'Không tìm thấy Độc giả.';
    } else {
      _hoTenDocGia = hoTen.capitalizeFirstLetterOfEachWord();
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _searchMaDocGiaController.dispose();
    _ngayMuonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mã Độc giả',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchMaDocGiaController,
                            autofocus: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromARGB(255, 245, 246, 250),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                              isCollapsed: true,
                              errorMaxLines: 2,
                            ),
                            onEditingComplete: _onSearchMaDocGia,
                          ),
                        ),
                        const Gap(10),
                        _isProcessing
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                height: 44,
                                width: 44,
                                padding: const EdgeInsets.all(12),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton.filled(
                                onPressed: _onSearchMaDocGia,
                                icon: const Icon(Icons.search_rounded),
                                style: myIconButtonStyle,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(30),
              Expanded(
                child: LabelTextFormField(
                  /* 
                  Thêm key vào để khi gọi setState cho giá trị mới cả _hoTenDocGia
                  Thì nó sẽ hoạt động, thử comment câu lệnh "key: ValueKey(_hoTenDocGia)" là hiểu
                  */
                  key: ValueKey(_hoTenDocGia),
                  labelText: 'Tên Độc giả',
                  initText: _hoTenDocGia,
                ),
              ),
              const Gap(30),
              NgayMuonHanTraComponent(ngayMuonController: _ngayMuonController)
            ],
          ),
          const Gap(4),
          if (_errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(_errorText, style: errorTextStyle(context)),
            ),
        ],
      ),
    );
  }
}

class NgayMuonHanTraComponent extends StatefulWidget {
  const NgayMuonHanTraComponent({super.key, required this.ngayMuonController});

  final TextEditingController ngayMuonController;

  @override
  State<NgayMuonHanTraComponent> createState() => _NgayMuonHanTraComponentState();
}

class _NgayMuonHanTraComponentState extends State<NgayMuonHanTraComponent> {
  @override
  void initState() {
    super.initState();
    widget.ngayMuonController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 595,
      child: Row(
        children: [
          Expanded(
            child: LabelTextFieldDatePicker(
              labelText: 'Ngày mượn',
              controller: widget.ngayMuonController,
            ),
          ),
          const Gap(30),
          Expanded(
            child: LabelTextFormField(
              labelText: 'Hạn trả',
              initText: vnDateFormat.parse(widget.ngayMuonController.text).addDays(ThamSoQuyDinh.soNgayMuonToiDa).toVnFormat(),
              isEnable: false,
            ),
          ),
        ],
      ),
    );
  }
}
