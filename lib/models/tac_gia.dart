class TacGia {
  int? maTacGia;
  StringSink tenTacGia;

  TacGia(
    this.maTacGia,
    this.tenTacGia,
  );

  Map<String, dynamic> toMap() {
    return {
      'MaTacGia': maTacGia,
      'TenTacGia': tenTacGia,
    };
  }
}
