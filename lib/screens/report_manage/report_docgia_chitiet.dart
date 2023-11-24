import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BaoCaoChiTietDocGia extends StatelessWidget {
  const BaoCaoChiTietDocGia({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Các độc giả được thêm vào',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                )
              ],
            ),
            const Gap(10),
          ],
        ),
      ),
    ));
  }
}
