class Sach {
  int? maSach;
  int lanTaiBan;
  String nhaXuatBan;
  int maDauSach;

  Sach(
    this.maSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.maDauSach,
  );

  Map<String, dynamic> toMap() {
    return {
      'LanTaiBan': lanTaiBan,
      'NhaXuatBan': nhaXuatBan,
      'MaDauSach': maDauSach,
    };
  }
}
