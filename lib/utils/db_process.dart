import 'dart:io';

import 'package:library_management/dto/chi_tiet_phieu_nhap_dto.dart';
import 'package:library_management/dto/dau_sach_dto.dart';
import 'package:library_management/models/chi_tiet_phieu_nhap.dart';
import 'package:library_management/models/dau_sach.dart';
import 'package:library_management/models/doc_gia.dart';
import 'package:library_management/models/phieu_nhap.dart';
import 'package:library_management/models/sach.dart';
import 'package:library_management/models/tac_gia.dart';
import 'package:library_management/models/the_loai.dart';
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
            -- NamXuatBan INTEGER,
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
            TongTien INTEGER
            -- MaNCC INTEGER

            -- FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC) ON DELETE RESTRICT
          );

          CREATE TABLE CT_PhieuNhap(
            MaCTPN INTEGER PRIMARY KEY AUTOINCREMENT, 
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
    List<Map<String, dynamic>> data = await _database.rawQuery('select * from TaiKhoan');
    return data.first;
  }

  // DocGia MODEL CODE
  Future<List<DocGia>> queryDocGia({
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

    List<DocGia> danhSachDocGia = [];

    for (var element in data) {
      danhSachDocGia.add(
        DocGia(
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

    return danhSachDocGia;
  }

  Future<List<DocGia>> queryDocGiaFullnameWithString({
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
    List<DocGia> docGias = [];

    for (var element in data) {
      docGias.add(
        DocGia(
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

    return docGias;
  }

  Future<int> queryCountDocGia() async {
    return firstIntValue(await _database.rawQuery('select count(MaDocGia) from DocGia'))!;
  }

  Future<int> queryCountDocGiaFullnameWithString(String str) async {
    return firstIntValue(
      await _database.rawQuery(
        '''
          select count(MaDocGia) from DocGia where Hoten like ?
          ''',
        ['%$str%'],
      ),
    )!;
  }

  Future<int> insertDocGia(DocGia newDocGia) async {
    return await _database.insert('DocGia', newDocGia.toMap());
  }

  Future<void> deleteDocGia(int maDocGia) async {
    await _database.rawDelete('delete from DocGia where MaDocGia  = ?', [maDocGia]);
  }

  Future<void> updateDocGia(DocGia updatedDocGia) async {
    await _database.rawUpdate(
      '''
      update DocGia 
      set HoTen = ?, NgaySinh = ?, DiaChi = ?, SoDienThoai = ?, 
      NgayLapThe = ?, NgayHetHan = ?, TongNo = ? 
      where MaDocGia  = ?
      ''',
      [
        updatedDocGia.hoTen,
        updatedDocGia.ngaySinh.toVnFormat(),
        updatedDocGia.diaChi,
        updatedDocGia.soDienThoai,
        updatedDocGia.ngayLapThe.toVnFormat(),
        updatedDocGia.ngayHetHan.toVnFormat(),
        updatedDocGia.tongNo,
        updatedDocGia.maDocGia,
      ],
    );
  }

  /* DAU SACH CODE */
  Future<List<DauSach>> queryDauSach() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DauSach 
      ''',
    );

    List<DauSach> dauSachs = [];

    for (var element in data) {
      dauSachs.add(
        DauSach(
          element['MaDauSach'],
          element['TenDauSach'],
        ),
      );
    }

    return dauSachs;
  }

  Future<List<DauSachDto>> queryDauSachDto() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DauSach 
      ''',
    );

    List<DauSachDto> dauSachs = [];

    for (var element in data) {
      final dauSach = DauSachDto(
        element['MaDauSach'],
        element['TenDauSach'],
        [],
        [],
      );

      List<Map<String, dynamic>> tacGiasData = await _database.rawQuery(
        '''
        select MaTacGia, TenTacGia from TacGia_DauSach join TacGia USING(MaTacGia)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      for (var tacGiaData in tacGiasData) {
        dauSach.tacGias.add(
          TacGia(
            tacGiaData['MaTacGia'],
            tacGiaData['TenTacGia'],
          ),
        );
      }

      List<Map<String, dynamic>> theLoaisData = await _database.rawQuery(
        '''
        select MaTheLoai, TenTheLoai from DauSach_TheLoai join TheLoai USING(MaTheLoai)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      for (var theLoaiData in theLoaisData) {
        dauSach.theLoais.add(
          TheLoai(
            theLoaiData['MaTheLoai'],
            theLoaiData['TenTheLoai'],
            "",
          ),
        );
      }

      dauSachs.add(dauSach);
    }

    return dauSachs;
  }

  Future<int> insertDauSach(DauSach newDauSach) async {
    return await _database.insert(
      'DauSach',
      {
        'TenDauSach': newDauSach.tenDauSach,
      },
    );
  }

  /* SACH CODE */
  Future<List<Sach>> querySach() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from Sach join DauSach using(MaDauSach)
      ''',
    );

    List<Sach> sachs = [];

    for (var element in data) {
      sachs.add(
        Sach(
          element['MaSach'],
          element['LanTaiBan'],
          element['NhaXuatBan'],
          element['MaDauSach'],
          element['TenDauSach'],
        ),
      );
    }

    return sachs;
  }

  Future<int> insertSach(Sach newSach) async {
    return await _database.insert(
      'Sach',
      newSach.toMap(),
    );
  }

  /* PHIEU NHAP CODE */
  Future<List<PhieuNhap>> queryPhieuNhap() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from PhieuNhap
      ''',
    );

    List<PhieuNhap> phieuNhaps = [];

    for (var element in data) {
      phieuNhaps.add(
        PhieuNhap(
          element['MaPhieuNhap'],
          vnDateFormat.parse(element['NgayLap']),
          element['TongTien'],
        ),
      );
    }

    return phieuNhaps;
  }

  Future<int> insertPhieuNhap(PhieuNhap newPhieuNhap) async {
    // print("INSERT INTO PhieuNhap(NgayLap, TongTien) VALUES ('${newPhieuNhap.ngayLap.toVnFormat()}', '${newPhieuNhap.tongTien}');");

    return await _database.insert(
      'PhieuNhap',
      newPhieuNhap.toMap(),
    );
  }

  /* CHI TIET PHIEU NHAP CODE */
  Future<List<ChiTietPhieuNhapDTO>> queryChiTietPhieuNhapDtoWithMaPhieuNhap(int maPhieuNhap) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCTPN, TenDauSach, SoLuong, DonGia from CT_PhieuNhap 
      join Sach using(MaSach) 
      join DauSach using(MaDauSach)
      where MaPhieuNhap = ?
      ''',
      [maPhieuNhap],
    );

    List<ChiTietPhieuNhapDTO> phieuNhaps = [];

    for (var element in data) {
      phieuNhaps.add(
        ChiTietPhieuNhapDTO(
          element['MaCTPN'],
          element['TenDauSach'],
          element['SoLuong'],
          element['DonGia'],
        ),
      );
    }

    return phieuNhaps;
  }

  Future<int> insertChiTietPhieuNhap(ChiTietPhieuNhap newChiTietPhieuNhap) async {
    // print('''
    //   INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia)
    //   VALUES ('${newChiTietPhieuNhap.maPhieuNhap}', '${newChiTietPhieuNhap.maSach}', '${newChiTietPhieuNhap.soLuong}', '${newChiTietPhieuNhap.donGia}');
    // ''');
    return await _database.insert(
      'CT_PhieuNhap',
      newChiTietPhieuNhap.toMap(),
    );
  }

  /* REPORT CODE */
}
