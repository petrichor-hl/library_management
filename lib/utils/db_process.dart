import 'dart:io';

import 'package:library_management/dto/chi_tiet_phieu_nhap_dto.dart';
import 'package:library_management/dto/cuon_sach_dto.dart';
import 'package:library_management/dto/dau_sach_dto.dart';
import 'package:library_management/models/chi_tiet_phieu_nhap.dart';
import 'package:library_management/models/dau_sach.dart';
import 'package:library_management/models/doc_gia.dart';
import 'package:library_management/models/lich_su_tim_kiem.dart';
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

          CREATE TABLE ThamSoQuyDinh(
            SoNgayMuonToiDa INTEGER,    -- 30 ngay
            SoSachMuonToiDa INTEGER,    -- 5 cuon
            MucThuTienPhat INTEGER,     -- 10000
            TuoiToiThieu INTEGER,       -- 12 tuoi
            PhiTaoThe INTEGER,          -- 50000
            ThoiHanThe INTEGER          -- 3 thang
          );

          INSERT INTO ThamSoQuyDinh VALUES('30','5', '10000', '12', '50000', 3);

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
            TenTheLoai TEXT
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
            NgayLap TEXT
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

          CREATE TABLE PhieuMuon(
            MaPhieuMuon INTEGER PRIMARY KEY AUTOINCREMENT,
            MaCuonSach INTEGER,
            MaDocGia INTEGER,
            NgayMuon TEXT,
            HanTra TEXT,
            TinhTrang TEXT,

            FOREIGN KEY (MaCuonSach) REFERENCES CuonSach(MaCuonSach) ON DELETE RESTRICT,
            FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia) ON DELETE RESTRICT
          );

          CREATE TABLE LichSuTimKiem(
            SearchTimestamp INT PRIMARY KEY,
            LoaiTimKiem TEXT,
            TuKhoa TEXT
          );
        ''',
        );
      },
    );
  }

  /* ACCOUNT CODE */
  Future<Map<String, dynamic>> queryAccount() async {
    List<Map<String, dynamic>> data = await _database.rawQuery('select * from TaiKhoan');
    return data.first;
  }

  /* PARAMETER CODE */
  Future<Map<String, dynamic>> queryThamSoQuyDinh() async {
    List<Map<String, dynamic>> data = await _database.rawQuery('select * from ThamSoQuyDinh');
    return data.first;
  }

  // ĐỘC GIẢ CODE
  Future<List<DocGia>> queryDocGia({
    required int numberRowIgnore,
  }) async {
    /* Lấy 8 dòng dữ liệu Độc Giả được thêm gần đây */
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

  Future<String?> queryHoTenDocGiaWithMaDocGia(int maDocGia) async {
    final res = (await _database.rawQuery(
      '''
      select HoTen from DocGia 
      where MaDocGia = ?
      ''',
      [maDocGia],
    ));
    if (res.isEmpty) {
      return null;
    }
    return res.first['HoTen'] as String;
  }

  Future<List<DocGia>> queryDocGiaFullnameWithString({
    required String str,
    required int numberRowIgnore,
  }) async {
    /* Lấy 10 dòng dữ liệu Độc Giả được thêm gần đây */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DocGia 
      where HoTen like ?
      limit ?, 8
      ''',
      ['%${str.toLowerCase()}%', numberRowIgnore],
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
          select count(MaDocGia) from DocGia 
          where Hoten like ?
          ''',
        ['%${str.toLowerCase()}%'],
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
        0,
        [],
        [],
      );

      QueryCursor cur = await _database.rawQueryCursor(
        '''
        select sum(SoLuong) as SoLuong
        from DauSach join Sach using(MaDauSach)
        join CT_PhieuNhap using(MaSach)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      await cur.moveNext();
      int? soLuong = cur.current['SoLuong'] as int?;
      dauSach.soLuong = soLuong ?? 0;
      cur.moveNext();

      cur = await _database.rawQueryCursor(
        '''
        select MaTacGia, TenTacGia from TacGia_DauSach join TacGia USING(MaTacGia)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      while (await cur.moveNext()) {
        dauSach.tacGias.add(
          TacGia(
            cur.current['MaTacGia'] as int,
            cur.current['TenTacGia'] as String,
          ),
        );
      }

      cur = await _database.rawQueryCursor(
        '''
        select MaTheLoai, TenTheLoai from DauSach_TheLoai join TheLoai USING(MaTheLoai)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      while (await cur.moveNext()) {
        dauSach.theLoais.add(
          TheLoai(
            cur.current['MaTheLoai'] as int,
            cur.current['TenTheLoai'] as String,
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

  Future<int> insertDauSachDto(DauSachDto newDauSachDto) async {
    // Insert Đầu sách
    int returningId = await _database.insert(
      'DauSach',
      {
        'TenDauSach': newDauSachDto.tenDauSach,
      },
    );

    // Insert TacGia_DauSach
    for (var tacGia in newDauSachDto.tacGias) {
      await _database.insert(
        'TacGia_DauSach',
        {
          'MaTacGia': tacGia.maTacGia,
          'MaDauSach': returningId,
        },
      );
    }

    // Insert DauSach_TheLoai
    for (var theLoai in newDauSachDto.theLoais) {
      await _database.insert(
        'DauSach_TheLoai',
        {
          'MaTheLoai': theLoai.maTheLoai,
          'MaDauSach': returningId,
        },
      );
    }

    return returningId;
  }

  Future<void> updateDauSachDto(DauSachDto updatedDauSachDto) async {
    /* Delete các Tác giả cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from TacGia_DauSach
      where MaDauSach = ?
      ''',
      [updatedDauSachDto.maDauSach],
    );
    /* Delete các Thể loại cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from DauSach_TheLoai
      where MaDauSach = ?
      ''',
      [updatedDauSachDto.maDauSach],
    );
    /* Cập nhật tên Đầu Sách */
    await _database.rawUpdate(
      '''
      update DauSach
      set TenDauSach = ?
      where MaDauSach = ?
      ''',
      [
        updatedDauSachDto.tenDauSach,
        updatedDauSachDto.maDauSach,
      ],
    );
    /* Thêm mới các Tác giả */
    for (var tacGia in updatedDauSachDto.tacGias) {
      await _database.insert(
        'TacGia_DauSach',
        {
          'MaTacGia': tacGia.maTacGia,
          'MaDauSach': updatedDauSachDto.maDauSach,
        },
      );
    }
    /* Thêm mới các Thể loại */
    for (var theLoai in updatedDauSachDto.theLoais) {
      await _database.insert(
        'DauSach_TheLoai',
        {
          'MaTheLoai': theLoai.maTheLoai,
          'MaDauSach': updatedDauSachDto.maDauSach,
        },
      );
    }
    /* DONE */
  }

  Future<void> deleteDauSachWithId(int maDauSach) async {
    /* 
    Vì ON DELETE CASCADE không hoạt động trong flutter 

    Nhưng khi delete DauSach trong DB Brower for SQLite thì ON DELETE CASCADE lại hoạt động, 
    nó tự động xoát các dòng liên quan trong bảng TacGia_DauSach, DauSach_TheLoai )

    => Vậy nên, phải tự delete thủ công trong Flutter 
    */
    /* Delete các Tác giả cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from TacGia_DauSach
      where MaDauSach = ?
      ''',
      [maDauSach],
    );
    /* Delete các Thể loại cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from DauSach_TheLoai
      where MaDauSach = ?
      ''',
      [maDauSach],
    );
    /* Delete Đầu Sách */
    await _database.rawDelete(
      '''
      delete from DauSach
      where MaDauSach = ?
      ''',
      [maDauSach],
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
      select PhieuNhap.MaPhieuNhap, NgayLap, SUM(SoLuong * DonGia) as TongTien
      from PhieuNhap join CT_PhieuNhap using(MaPhieuNhap)
      group by MaPhieuNhap
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
    // print("INSERT INTO PhieuNhap(NgayLap) VALUES ('${newPhieuNhap.ngayLap.toVnFormat()}');");

    return await _database.insert(
      'PhieuNhap',
      newPhieuNhap.toMap(),
    );
  }

  Future<void> updateNgayLapPhieuNhap(PhieuNhap updatedPhieuNhap) async {
    await _database.rawUpdate('''
      update PhieuNhap
      set NgayLap = ?
      where MaPhieuNhap = ?
      ''', [
      updatedPhieuNhap.ngayLap.toVnFormat(),
      updatedPhieuNhap.maPhieuNhap,
    ]);
  }

  /* CHI TIET PHIEU NHAP CODE */
  Future<List<ChiTietPhieuNhapDto>> queryChiTietPhieuNhapDtoWithMaPhieuNhap(int maPhieuNhap) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCTPN, TenDauSach, MaSach, SoLuong, DonGia from CT_PhieuNhap 
      join Sach using(MaSach) 
      join DauSach using(MaDauSach)
      where MaPhieuNhap = ?
      ''',
      [maPhieuNhap],
    );

    List<ChiTietPhieuNhapDto> phieuNhaps = [];

    for (var element in data) {
      phieuNhaps.add(
        ChiTietPhieuNhapDto(
          element['MaCTPN'],
          element['TenDauSach'],
          element['MaSach'],
          element['SoLuong'],
          element['DonGia'],
        ),
      );
    }

    return phieuNhaps;
  }

  Future<int> insertChiTietPhieuNhap(ChiTietPhieuNhap newChiTietPhieuNhap) async {
    // print(
    //     "INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('${newChiTietPhieuNhap.maPhieuNhap}', '${newChiTietPhieuNhap.maSach}', '${newChiTietPhieuNhap.soLuong}', '${newChiTietPhieuNhap.donGia}');");

    int returningId = await _database.insert(
      'CT_PhieuNhap',
      newChiTietPhieuNhap.toMap(),
    );

    for (int i = 1; i <= newChiTietPhieuNhap.soLuong; ++i) {
      // print(
      //     "INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('${newChiTietPhieuNhap.maSach}_${returningId}_$i', 'Có sẵn', '', '$returningId', '${newChiTietPhieuNhap.maSach}');");

      await _database.insert(
        'CuonSach',
        {
          'MaCuonSach': '${newChiTietPhieuNhap.maSach}_${returningId}_$i',
          'TinhTrang': 'Có sẵn',
          'ViTri': 'Chưa có thông tin',
          'MaCTPN': returningId,
          'MaSach': newChiTietPhieuNhap.maSach,
        },
      );
    }

    return returningId;
  }

  Future<void> updateSoLuongChiTietPhieuNhap(ChiTietPhieuNhapDto updatedChiTietPhieuNhap) async {
    /* Xóa các cuốn sách có liên quan đến ChiTietPhieuNhap này */
    await _database.rawDelete(
      '''
      delete from CuonSach
      where MaCTPN = ?
      ''',
      [updatedChiTietPhieuNhap.maCTPN],
    );

    /* Cập nhật lại số lượng cho ChiTietPhieuNhap này */
    await _database.rawUpdate(
      '''
      update CT_PhieuNhap
      set SoLuong = ?
      where MaCTPN = ?
      ''',
      [
        updatedChiTietPhieuNhap.soLuong,
        updatedChiTietPhieuNhap.maCTPN,
      ],
    );

    /* Thêm lại các CuonSach với số lượng mới */
    for (int i = 1; i <= updatedChiTietPhieuNhap.soLuong; ++i) {
      await _database.insert(
        'CuonSach',
        {
          'MaCuonSach': '${updatedChiTietPhieuNhap.maSach}_${updatedChiTietPhieuNhap.maCTPN}_$i',
          'TinhTrang': 'Có sẵn',
          'ViTri': 'Chưa có thông tin',
          'MaCTPN': updatedChiTietPhieuNhap.maCTPN,
          'MaSach': updatedChiTietPhieuNhap.maSach,
        },
      );
    }
  }

  Future<void> updateDonGiaChiTietPhieuNhap(ChiTietPhieuNhapDto updatedChiTietPhieuNhap) async {
    /* Cập nhật lại Đơn Giá cho ChiTietPhieuNhap này */
    await _database.rawUpdate(
      '''
      update CT_PhieuNhap
      set DonGia = ?
      where MaCTPN = ?
      ''',
      [
        updatedChiTietPhieuNhap.donGia,
        updatedChiTietPhieuNhap.maCTPN,
      ],
    );
  }

  /* TAC GIA CODE */
  Future<List<TacGia>> queryTacGias() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from TacGia;
      ''',
    );

    List<TacGia> tacGias = [];

    for (var element in data) {
      tacGias.add(
        TacGia(
          element['MaTacGia'],
          element['TenTacGia'],
        ),
      );
    }

    return tacGias;
  }

  Future<int> insertTacGia(TacGia newTacGia) async {
    return await _database.insert(
      'TacGia',
      {
        'TenTacGia': newTacGia.tenTacGia,
      },
    );
  }

  /* THE LOAI CODE */

  Future<List<TheLoai>> queryTheLoais() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from TheLoai;
      ''',
    );

    List<TheLoai> theLoais = [];

    for (var element in data) {
      theLoais.add(
        TheLoai(
          element['MaTheLoai'],
          element['TenTheLoai'],
        ),
      );
    }

    return theLoais;
  }

  Future<int> insertTheLoai(TheLoai newTheLoai) async {
    return await _database.insert(
      'TheLoai',
      {
        'TenTheLoai': newTheLoai.tenTheLoai,
      },
    );
  }

  /* LỊCH SỬ TÌM KIẾM CUỐN SÁCH CODE */
  Future<List<LichSuTimKiem>> queryLichSuTimKiem({required String loaiTimKiem}) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from LichSuTimKiem
      where LoaiTimKiem = ?
      order by SearchTimestamp desc
      ''',
      [loaiTimKiem],
    );

    List<LichSuTimKiem> lichSuTimKiem = [];

    for (var element in data) {
      lichSuTimKiem.add(
        LichSuTimKiem(
          element['SearchTimestamp'],
          'CuonSach',
          element['TuKhoa'],
        ),
      );
    }

    return lichSuTimKiem;
  }

  Future<void> insertLichSuTimKiem(LichSuTimKiem lichSuTimKiemCuonSach) async {
    await _database.insert(
      'LichSuTimKiem',
      lichSuTimKiemCuonSach.toMap(),
    );
  }

  Future<void> updateSearchTimestampLichSuTimKiem(LichSuTimKiem updatedLichSuTimKiemCuonSach) async {
    await _database.rawUpdate(
      '''
      update LichSuTimKiem
      set SearchTimestamp = ?
      where TuKhoa = ?
      ''',
      [
        updatedLichSuTimKiemCuonSach.searchTimestamp,
        updatedLichSuTimKiemCuonSach.tuKhoa,
      ],
    );
  }

  Future<void> deleteLichSuTimKiem(LichSuTimKiem lichSuTimKiemCuonSach) async {
    await _database.rawDelete(
      '''
      delete from LichSuTimKiem
      where SearchTimestamp = ?
      ''',
      [lichSuTimKiemCuonSach.searchTimestamp],
    );
  }

  /* CUON SACH CODE */
  Future<List<CuonSachDto>> queryCuonSachWithKeyword(String keyword) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCuonSach, TenDauSach, LanTaiBan, NhaXuatBan, TinhTrang, ViTri, MaCTPN
      from DauSach join Sach using(MaDauSach) 
      join CT_PhieuNhap using(MaSach)
      join CuonSach using(MaSach, MaCTPN)
      where TenDauSach like ?
      ''',
      ['%${keyword.toLowerCase()}%'],
    );

    List<CuonSachDto> cuonSachs = [];

    for (var element in data) {
      cuonSachs.add(
        CuonSachDto(
          element['MaCuonSach'],
          element['TenDauSach'],
          element['LanTaiBan'],
          element['NhaXuatBan'],
          element['TinhTrang'],
          element['ViTri'],
          element['MaCTPN'],
        ),
      );
    }

    return cuonSachs;
  }

  Future<void> updateViTriCuonSach(CuonSachDto updatedCuonSachDto) async {
    await _database.rawUpdate(
      '''
      update CuonSach
      set ViTri = ?
      where MaCuonSach = ?
      ''',
      [
        updatedCuonSachDto.viTri,
        updatedCuonSachDto.maCuonSach,
      ],
    );
  }

  Future<Map<String, dynamic>> queryThongTinChiTietPhieuNhapCuonSach(int maCTPN) async {
    final data = await _database.rawQuery(
      '''
      select MaPhieuNhap, NgayLap, SoLuong, DonGia
      from PhieuNhap
      join CT_PhieuNhap using(MaPhieuNhap)
      where MaCTPN = ?
      ''',
      [maCTPN],
    );
    return data.first;
  }

  /* REPORT CODE */
}
