import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbProcess {
  late Database _database;

  Future<void> connect() async {
    final currentFolder = Directory.current.path;
    _database = await openDatabase(
      '$currentFolder/database/library.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE TaiKhoan(
            username TEXT,
            password TEXT
          );

          INSERT INTO TaiKhoan VALUES('admin','123456');

          CREATE TABLE TacGia(
            MaTacGia INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTacGia TEXT
          );
          
          CREATE TABLE TuaSach(
            MaTuaSach INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTuaSach TEXT
          );

          CREATE TABLE TacGia_TuaSach (
            MaTacGia INTEGER,
            MaTuaSach INTEGER,
            PRIMARY KEY (MaTacGia, MaTuaSach),

            FOREIGN KEY (MaTacGia) REFERENCES TacGia(MaTacGia) ON DELETE CASCADE,
            FOREIGN KEY (MaTuaSach) REFERENCES TuaSach(MaTuaSach) ON DELETE CASCADE
          );

          CREATE TABLE TheLoai(
            MaTheLoai INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTheLoai TEXT,
            MoTa TEXT
          );

          CREATE TABLE TuaSach_TheLoai(
            MaTuaSach INTEGER,
            MaTheLoai INTEGER,

            PRIMARY KEY (MaTuaSach, MaTheLoai),

            FOREIGN KEY (MaTuaSach) REFERENCES TuaSach(MaTuaSach) ON DELETE CASCADE,
            FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai) ON DELETE CASCADE
          );

          CREATE TABLE DauSach(
            MaDauSach INTEGER PRIMARY KEY AUTOINCREMENT, 
            LanTaiBan INTEGER,
            NhaXuatBan TEXT,
            NamXuatBan INTEGER,
            MaTuaSach INTEGER,

            FOREIGN KEY (MaTuaSach) REFERENCES TuaSach(MaTuaSach) ON DELETE RESTRICT
          );

          CREATE TABLE PhieuNhap(
            MaPhieuNhap INTEGER PRIMARY KEY AUTOINCREMENT, 
            NgayLap TEXT,
            TongTien INTEGER
          );

          CREATE TABLE CT_PhieuNhap(
            MaCTPN TEXT PRIMARY KEY, 
            MaPhieuNhap INTEGER,
            MaDauSach INTEGER,
            SoLuong INTEGER,
            DonGia INTEGER,

            FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhap(MaPhieuNhap) ON DELETE RESTRICT,
            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE RESTRICT
          );

          CREATE TABLE CuonSach(
            MaCuonSach TEXT PRIMARY KEY,
            TinhTrang INTEGER,
            ViTri TEXT,
            MaCTPN INTEGER,
            MaDauSach INTEGER,

            FOREIGN KEY (MaCTPN) REFERENCES CT_PhieuNhap(MaCTPN) ON DELETE RESTRICT,
            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE RESTRICT
          );
        ''',
        );
      },
    );
  }

  Future<Map<String, dynamic>> queryAccount() async {
    List<Map<String, dynamic>> data =
        await _database.rawQuery('select * from TaiKhoan');
    return data.first;
  }
}
