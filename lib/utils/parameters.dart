import 'package:library_management/utils/extension.dart';

class ThamSoQuyDinh {
  static int soNgayMuonToiDa = 0; // đơn vị ngày
  static int soSachMuonToiDa = 0; // đơn vị số nguyên
  static int mucThuTienPhat = 0; // đơn vị VND
  static int tuoiToiThieu = 0; // đơn vị tuổi
  static int phiTaoThe = 0; // đơn vị VND
  static int thoiHanThe = 0; // đơn vị tháng

  static void thietLapThamSo(Map<String, dynamic> thamSo) {
    soNgayMuonToiDa = thamSo['SoNgayMuonToiDa'];
    soSachMuonToiDa = thamSo['SoSachMuonToiDa'];
    mucThuTienPhat = thamSo['MucThuTienPhat'];
    tuoiToiThieu = thamSo['TuoiToiThieu'];
    phiTaoThe = thamSo['PhiTaoThe'];
    thoiHanThe = thamSo['ThoiHanThe'];
  }

  static String getThamSo(String tenThamSo) {
    String value = '';

    switch (tenThamSo) {
      case 'SoNgayMuonToiDa':
        value = soNgayMuonToiDa.toString();
        break;
      case 'SoSachMuonToiDa':
        value = soSachMuonToiDa.toString();
        break;
      case 'MucThuTienPhat':
        value = mucThuTienPhat.toVnCurrencyWithoutSymbolFormat();
        break;
      case 'TuoiToiThieu':
        value = tuoiToiThieu.toString();
        break;
      case 'PhiTaoThe':
        value = phiTaoThe.toVnCurrencyWithoutSymbolFormat();
        break;
      case 'ThoiHanThe':
        value = thoiHanThe.toString();
        break;
    }

    return value;
  }

  static String setThamSo(String tenThamSo, String giaTri) {
    String value = '';

    switch (tenThamSo) {
      case 'SoNgayMuonToiDa':
        soNgayMuonToiDa = int.parse(giaTri);
        break;
      case 'SoSachMuonToiDa':
        soSachMuonToiDa = int.parse(giaTri);
        break;
      case 'MucThuTienPhat':
        mucThuTienPhat = int.parse(giaTri);
        break;
      case 'TuoiToiThieu':
        tuoiToiThieu = int.parse(giaTri);
        break;
      case 'PhiTaoThe':
        phiTaoThe = int.parse(giaTri);
        break;
      case 'ThoiHanThe':
        thoiHanThe = int.parse(giaTri);
        break;
    }

    return value;
  }

  static String getDonVi(String tenThamSo) {
    String value = '';

    switch (tenThamSo) {
      case 'SoNgayMuonToiDa':
        value = 'ngày';
        break;
      case 'SoSachMuonToiDa':
        value = 'cuốn';
        break;
      case 'MucThuTienPhat':
        value = 'VND';
        break;
      case 'TuoiToiThieu':
        value = 'tuổi';
        break;
      case 'PhiTaoThe':
        value = 'VND';
        break;
      case 'ThoiHanThe':
        value = 'tháng';
        break;
    }

    return value;
  }
}
