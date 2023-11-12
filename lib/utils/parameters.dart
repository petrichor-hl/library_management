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
}
