class LichSuTimKiemCuonSach {
  int searchTimestamp;
  String tuKhoa;

  LichSuTimKiemCuonSach(
    this.searchTimestamp,
    this.tuKhoa,
  );

  Map<String, dynamic> toMap() {
    return {
      'SearchTimestamp': searchTimestamp,
      'TuKhoa': tuKhoa,
    };
  }
}
