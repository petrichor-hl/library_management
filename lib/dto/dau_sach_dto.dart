import 'package:library_management/models/tac_gia.dart';
import 'package:library_management/models/the_loai.dart';

class DauSachDto {
  int? maDauSach;
  String tenDauSach;
  List<TacGia> tacGias;
  List<TheLoai> theLoais;

  DauSachDto(
    this.maDauSach,
    this.tenDauSach,
    this.tacGias,
    this.theLoais,
  );

  String tacGiasToString() {
    if (tacGias.isEmpty) {
      return "Chưa có tác giả";
    }

    String str = "";
    for (var tacGia in tacGias) {
      str += '${tacGia.tenTacGia}, ';
    }
    return str.substring(0, str.length - 2);
  }

  String theLoaisToString() {
    if (theLoais.isEmpty) {
      return "Chưa có thể loại";
    }

    String str = "";
    for (var theLoai in theLoais) {
      str += '${theLoai.tenTheLoai}, ';
    }
    return str.substring(0, str.length - 2);
  }
}
