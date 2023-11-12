import 'package:library_management/utils/extension.dart';

class ThamSoQuyDinh {
  static int soNgayMuonToiDa = 0; // đơn vị ngày
  static int soSachMuonToiDa = 0; // đơn vị số nguyên
  static int mucThuTienPhat = 0; // đơn vị VND
  static int tuoiToiThieu = 0; // đơn vị tuổi
  static int phiTaoThe = 0; // đơn vị VND
  static int thoiHanThe = 0; // đơn vị tháng
  static String noiQuy = '';

  static void thietLapThamSo(Map<String, dynamic> thamSo) {
    soNgayMuonToiDa = thamSo['SoNgayMuonToiDa'];
    soSachMuonToiDa = thamSo['SoSachMuonToiDa'];
    mucThuTienPhat = thamSo['MucThuTienPhat'];
    tuoiToiThieu = thamSo['TuoiToiThieu'];
    phiTaoThe = thamSo['PhiTaoThe'];
    thoiHanThe = thamSo['ThoiHanThe'];
    noiQuy = thamSo['NoiQuy'];
  }

  static String getThamSo(String tenThamSo) {
    String value = '';

    switch (tenThamSo) {
      case 'SoNgayMuonToiDa':
        value = '$soNgayMuonToiDa ngày';
        break;
      case 'SoSachMuonToiDa':
        value = '$soSachMuonToiDa sách';
        break;
      case 'MucThuTienPhat':
        value = mucThuTienPhat.toVnCurrencyFormat();
        break;
      case 'TuoiToiThieu':
        value = '$tuoiToiThieu tuổi';
        break;
      case 'PhiTaoThe':
        value = phiTaoThe.toVnCurrencyFormat();
        break;
      case 'ThoiHanThe':
        value = '$thoiHanThe tháng';
        break;
    }

    return value;
  }
}
