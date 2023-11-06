import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form/tac_gia_form.dart';
import 'package:library_management/components/forms/add_edit_dau_sach_form/the_loai_form.dart';
import 'package:library_management/models/dau_sach.dart';

class AddEditDauSachForm extends StatefulWidget {
  const AddEditDauSachForm({
    super.key,
    this.editDauSach,
  });

  final DauSach? editDauSach;

  @override
  State<AddEditDauSachForm> createState() => _AddEditDauSachFormState();
}

class _AddEditDauSachFormState extends State<AddEditDauSachForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 180),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.editDauSach == null ? 'THÊM ĐẦU SÁCH MỚI' : 'SỬA ĐẦU SÁCH',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close_rounded),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(12),
          const Expanded(
            child: Column(
              children: [
                Expanded(
                  child: TacGiaForm(),
                ),
                Gap(12),
                Expanded(
                  child: TheLoaiForm(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
