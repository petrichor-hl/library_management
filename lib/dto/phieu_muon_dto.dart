class PhieuMuon {
  int? maPhieuMuon;
  String maCuonSach;
  int lanTaiBan;
  String nhaXuatBan;
  DateTime ngayMuon;
  DateTime hanTra;
  String tinhTrang;
  List<String> tacGias;

  PhieuMuon(
    this.maPhieuMuon,
    this.maCuonSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.ngayMuon,
    this.hanTra,
    this.tinhTrang,
    this.tacGias,
  );

  String tacGiasToString() {
    if (tacGias.isEmpty) {
      return "Chưa có tác giả";
    }

    String str = "";
    for (var tacGia in tacGias) {
      str += '$tacGia, ';
    }
    return str.substring(0, str.length - 2);
  }
}
