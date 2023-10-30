import 'package:flutter/material.dart';
import 'package:library_management/models/dau_sach.dart';

class AddEditDauSach extends StatefulWidget {
  const AddEditDauSach({
    super.key,
    this.editDauSach,
  });

  final DauSach? editDauSach;

  @override
  State<AddEditDauSach> createState() => _AddEditDauSachState();
}

class _AddEditDauSachState extends State<AddEditDauSach> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Row(
          children: [
            Text(
              widget.editDauSach == null ? 'SỬA ĐẦU SÁCH' : 'THÊM ĐẦU SÁCH MỚI',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_back_rounded),
            )
          ],
        ),
      ),
    );
  }
}
