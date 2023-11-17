import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/main.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';

class TraSach extends StatefulWidget {
  const TraSach({super.key});

  @override
  State<TraSach> createState() => _TraSachState();
}

class _TraSachState extends State<TraSach> {
  final _searchMaDocGiaController = TextEditingController();

  String _errorText = '';
  String _maDocGia = '';
  String _hoTenDocGia = '';

  bool _isProcessingMaDocGia = false;

  Future<void> _searchMaDocGia() async {
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
      _isProcessingMaDocGia = true;
    });

    _hoTenDocGia = '';
    _maDocGia = '';

    int maDocGia = int.parse(_searchMaDocGiaController.text);

    String? hoTen = await dbProcess.queryHoTenDocGiaWithMaDocGia(maDocGia);
    await Future.delayed(const Duration(milliseconds: 200));

    if (hoTen == null) {
      _errorText = 'Không tìm thấy Độc giả.';
    } else {
      _maDocGia = maDocGia.toString();
      _hoTenDocGia = hoTen.capitalizeFirstLetterOfEachWord();
    }

    setState(() {
      _isProcessingMaDocGia = false;
    });
  }

  @override
  void dispose() {
    _searchMaDocGiaController.dispose();
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
                      'Tìm Độc giả',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                              hintText: 'Nhập Mã độc giả',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                              isCollapsed: true,
                              errorMaxLines: 2,
                            ),
                            onEditingComplete: _searchMaDocGia,
                          ),
                        ),
                        const Gap(10),
                        _isProcessingMaDocGia
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                onPressed: _searchMaDocGia,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                style: myIconButtonStyle,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(50),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mã Độc giả:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 44,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _maDocGia.isEmpty ? const Color(0xffEFEFEF) : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _maDocGia,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(50),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Họ tên:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 44,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _hoTenDocGia.isEmpty ? const Color(0xffEFEFEF) : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _hoTenDocGia,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(14),
          const Text(
            'DANH SÁCH PHIẾU MƯỢN CẦN TRẢ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
        ],
      ),
    );
  }
}
