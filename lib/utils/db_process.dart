import 'dart:io';

import 'package:library_management/models/reader.dart';
import 'package:library_management/utils/common_variables.dart';
import 'package:library_management/utils/extension.dart';
import 'package:sqflite/utils/utils.dart';
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

          CREATE TABLE PARAMETER(
            SoNgayMuonToiDa INTEGER,
            SoSachMuonToiDa INTEGER,
            MucThuTienPhat INTEGER,
            TuoiToiThieu INTEGER
          );

          CREATE TABLE TacGia(
            MaTacGia INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTacGia TEXT
          );
          
          CREATE TABLE DauSach(
            MaDauSach INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenDauSach TEXT
          );

          CREATE TABLE TacGia_DauSach (
            MaTacGia INTEGER,
            MaDauSach INTEGER,
            PRIMARY KEY (MaTacGia, MaDauSach),

            FOREIGN KEY (MaTacGia) REFERENCES TacGia(MaTacGia) ON DELETE CASCADE,
            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE CASCADE
          );

          CREATE TABLE TheLoai(
            MaTheLoai INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTheLoai TEXT,
            MoTa TEXT
          );

          CREATE TABLE DauSach_TheLoai(
            MaDauSach INTEGER,
            MaTheLoai INTEGER,

            PRIMARY KEY (MaDauSach, MaTheLoai),

            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE CASCADE,
            FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai) ON DELETE CASCADE
          );

          CREATE TABLE Sach(
            MaSach INTEGER PRIMARY KEY AUTOINCREMENT, 
            LanTaiBan INTEGER,
            NhaXuatBan TEXT,
            NamXuatBan INTEGER,
            MaDauSach INTEGER,

            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE RESTRICT
          );

          -- CREATE TABLE NhaCungCap(
          --   MaNCC INTEGER PRIMARY KEY AUTOINCREMENT, 
          --   TenNCC TEXT,
          --   SoDienThoai TEXT
          -- );

          CREATE TABLE PhieuNhap(
            MaPhieuNhap INTEGER PRIMARY KEY AUTOINCREMENT, 
            NgayLap TEXT,
            TongTien INTEGER,
            MaNCC INTEGER

            -- FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC) ON DELETE RESTRICT
          );

          CREATE TABLE CT_PhieuNhap(
            MaCTPN TEXT PRIMARY KEY, 
            MaPhieuNhap INTEGER,
            MaSach INTEGER,
            SoLuong INTEGER,
            DonGia INTEGER,

            FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhap(MaPhieuNhap) ON DELETE RESTRICT,
            FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE RESTRICT
          );

          CREATE TABLE CuonSach(
            MaCuonSach TEXT PRIMARY KEY,
            TinhTrang INTEGER,
            ViTri TEXT,
            MaCTPN INTEGER,
            MaSach INTEGER,

            FOREIGN KEY (MaCTPN) REFERENCES CT_PhieuNhap(MaCTPN) ON DELETE RESTRICT,
            FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE RESTRICT
          );

          CREATE TABLE DocGia(
            MaDocGia INTEGER PRIMARY KEY AUTOINCREMENT,
            HoTen TEXT,
            NgaySinh TEXT,
            DiaChi TEXT,
            SoDienThoai TEXT,
            NgayLapThe TEXT,
            NgayHetHan TEXT,
            TongNo INTEGER
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

  // READER MODEL CODE
  Future<List<Reader>> queryReader({
    required int numberRowIgnore,
  }) async {
    /* Lấy 10 dòng dữ liệu Độc Giả được thêm gần đây */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DocGia 
      limit ?, 8
      ''',
      [numberRowIgnore],
    );

    List<Reader> readers = [];

    for (var element in data) {
      readers.add(
        Reader(
          element['MaDocGia'],
          element['HoTen'],
          vnDateFormat.parse(element['NgaySinh'] as String),
          element['DiaChi'],
          element['SoDienThoai'],
          vnDateFormat.parse(element['NgayLapThe'] as String),
          vnDateFormat.parse(element['NgayHetHan'] as String),
          element['TongNo'],
        ),
      );
    }

    return readers;
  }

  Future<List<Reader>> queryReaderFullnameWithString({
    required String str,
    required int numberRowIgnore,
  }) async {
    /* Lấy 10 dòng dữ liệu Độc Giả được thêm gần đây */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DocGia where HoTen COLLATE NOCASE like ?
      limit ?, 8
      ''',
      ['%$str%', numberRowIgnore],
    );
    List<Reader> readers = [];

    for (var element in data) {
      readers.add(
        Reader(
          element['MaDocGia'],
          element['HoTen'],
          vnDateFormat.parse(element['NgaySinh'] as String),
          element['DiaChi'],
          element['SoDienThoai'],
          vnDateFormat.parse(element['NgayLapThe'] as String),
          vnDateFormat.parse(element['NgayHetHan'] as String),
          element['TongNo'],
        ),
      );
    }

    return readers;
  }

  Future<int> queryCountReader() async {
    return firstIntValue(
        await _database.rawQuery('select count(MaDocGia) from DocGia'))!;
  }

  Future<int> queryCountReaderFullnameWithString(String str) async {
    return firstIntValue(
      await _database.rawQuery(
        '''
          select count(MaDocGia) from DocGia where Hoten like ?
          ''',
        ['%$str%'],
      ),
    )!;
  }

  Future<int> insertReader(Reader newReader) async {
    return await _database.insert('DocGia', newReader.toMap());
  }

  Future<void> deleteReader(int readerId) async {
    await _database
        .rawDelete('delete from DocGia where MaDocGia  = ?', [readerId]);
  }

  Future<void> updateReader(Reader updatedReader) async {
    await _database.rawUpdate(
      '''
      update DocGia 
      set HoTen = ?, NgaySinh = ?, DiaChi = ?, SoDienThoai = ?, 
      NgayLapThe = ?, NgayHetHan = ?, TongNo = ? 
      where MaDocGia  = ?
      ''',
      [
        updatedReader.fullname,
        updatedReader.dob.toVnFormat(),
        updatedReader.address,
        updatedReader.phoneNumber,
        updatedReader.creationDate.toVnFormat(),
        updatedReader.expirationDate.toVnFormat(),
        updatedReader.totalTiabilities,
        updatedReader.id,
      ],
    );
  }
}
