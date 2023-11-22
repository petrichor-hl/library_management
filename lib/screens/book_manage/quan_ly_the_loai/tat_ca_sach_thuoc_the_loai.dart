import 'package:flutter/material.dart';
import 'package:library_management/dto/the_loai_dto.dart';
import 'package:library_management/main.dart';

class TatCaSachThuocTheLoai extends StatefulWidget {
  const TatCaSachThuocTheLoai({
    super.key,
    required this.theLoai,
  });

  final TheLoaiDto theLoai;

  @override
  State<TatCaSachThuocTheLoai> createState() => _TatCaSachThuocTheLoaiState();
}

class _TatCaSachThuocTheLoaiState extends State<TatCaSachThuocTheLoai> {
  late final List<String> _dauSachs;

  late final Future<void> _futureDauSachTheLoais = _getDauSachTheLoais();
  Future<void> _getDauSachTheLoais() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _dauSachs = await dbProcess.queryDauSachWithMaTheLoai(widget.theLoai.maTheLoai);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
