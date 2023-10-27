import 'package:library_management/utils/extension.dart';

class Reader {
  Reader(
    this.id,
    this.fullname,
    this.dob,
    this.address,
    this.phoneNumber,
    this.creationDate,
    this.expirationDate,
    this.totalTiabilities,
  );

  int? id;
  String fullname;
  DateTime dob;
  String address;
  String phoneNumber;
  DateTime creationDate;
  DateTime expirationDate;
  int totalTiabilities;

  Map<String, dynamic> toMap() {
    return {
      'HoTen': fullname,
      'NgaySinh': dob.toVnFormat(),
      'DiaChi': address,
      'SoDienThoai': phoneNumber,
      'NgayLapThe': creationDate.toVnFormat(),
      'NgayHetHan': expirationDate.toVnFormat(),
      'TongNo': totalTiabilities,
    };
  }
}
