INSERT INTO DocGia(HoTen, NgaySinh, DiaChi, SoDienThoai, NgayLapThe, NgayHetHan, TongNo) 
VALUES
('trần lê hoàng lâm', '17/04/2003', 'S8.01 VGP, Quận 9, Thủ Đức', '0915203143', '27/10/2023', '27/04/2024', 0),
('tăng thị kim nguyên', '01/05/2003', '13 Nguyễn Thị Định, phường Thanh Hà, Thành phố Hội An', '0905746418', '24/08/2023', '24/02/2024', 0),
('bùi cường', '12/09/2003', 'A ma quang, phường Tự An, Thành phố Buôn Mê Thuộc', '0914119624', '15/09/2023', '15/03/2024', 14000),
('nguyễn viết hường', '17/09/2003', 'S5.01 VGP, Long Thạnh Mỹ, Quận 9, Tp HCM', '0975664494', '24/07/2023', '24/01/2024', 20000),
('trần văn sơn', '06/06/1975', '506 Hùng Vương, phường Thanh Hà, Thành phố Hội An', '0986780715', '31/08/2023', '02/03/2024', 0),
('đỗ mai minh quân', '02/09/2004', '624 Cẩm Đường, Long Thành, Đồng Nai', '0374936329', '19/08/2023', '19/02/2024', 0),
('đinh nhật thông', '26/07/2005', 'Phường Điện Ngọc, Thị xã Điện Bàn, Tỉnh Quảng Nam', '0399784005', '07/09/2023', '07/03/2024', 0),
('lê thị châu toàn', '30/09/1983', '326 Lý Thường Kiệt, Phường Minh An, Hội An, Quảng Nam', '0818055446', '21/10/2023', '21/4/2024', 0),
('nguyễn thị huyền trang', '30/11/2009', 'Hà bản, Điện Dương, Điện Bàn, Quảng Nam', '0767367435', '19/07/2023', '19/01/2024', 0),
('lê đăng thương', '07/05/2001', 'Thôn 2, Xã EaNam, Huyện EaH''leo, Tỉnh Đăk Lăk', '0397824107', '28/07/2023', '28/01/2024', 0),
('trần vũ bảo phúc', '14/04/2003', '102/44/49 Pháo Đài Láng, Láng Thượng, Đống Đa, Hà Nội', '0981787708', '02/08/2023', '02/02/2024', 0),
('nguyễn nguyên khương', '12/12/2008', 'I-01.04, Chung cư Sunrise Riverside, Phước Kiển, Nhà Bè, Thành phố Hồ Chí Min', '0865122487', '28/10/2023', '28/04/2024', 0),
('nguyễn ngọc tín', '08/09/2005', '1163/2d Lê Đức Thọ, Quận Gò Vấp', '0522669557', '19/05/2023', '19/11/2023', 0),
('lê duy thường', '16/07/2003', 'Đường số 16, Tân Phú, Quận 7, Thành phố Hồ Chí Minh', '0387992373', '01/02/2023', '01/08/2023', 0),
('văn minh triết', '20/12/2001', '3/8 Đ. Số 8, Tân Quy, Quận 7, Thành phố Hồ Chí Minh', '0938083882', '09/06/2023', '09/12/2023', 0),
('hoàng văn quy', '12/07/1998', 'Hẻm 233, Võ Thị Sáu, Quận 3, Thành phố Hồ Chí Minh', '0398724661', '27/07/2022', '27/01/2023', 0),
('nguyễn minh châu', '28/10/2023', '40 Bế Văn Đàn, Phường 14, Tân Bình, Thành phố Hồ Chí Minh', '0397116293', '19/10/2023', '19/04/2024', 0),
('trần thị thu hoài', '16/09/2003', '69/9 Đề Thám, phường Cô Giang, Quận 1, TP HCM', '0378034554', '08/08/2023', '08/02/2024', 0),
('phạm thị như ý', '05/11/2003', '20/16 Đường số 2, phường Tân Kiểng, Quận 7', '0941288835', '28/10/2023', '28/04/2024', 0),
('nguyễn hồ phúc my', '03/12/2003', '28 Mai Văn Ngọc, Phường 10, Phú Nhuận, Thành phố Hồ Chí Minh', '0905067490', '20/06/2023', '20/12/2023', 0);
-- ('', '', '', '', '', '', 0),

INSERT INTO DauSach(TenDauSach) 
VALUES 
('nhà giả kim'),
('bắt trẻ đồng xanh'),
('đi tìm lẽ sống'),
('ngày xưa có một chuyện tình'),
('cô gái năm ấy chúng ta cùng theo đuổi'),
('năm tháng vội vã'),       -- id: 6
('cố định một đám mây'),
('cha giàu cha nghèo'),     -- id: 8
('tôi thấy hoa vàng trên cỏ xanh');


INSERT INTO Sach(LanTaiBan, NhaXuatBan, MaDauSach)
VALUES 
('5', 'NXB Trẻ', '4'),
('2', 'Ấn Tầm', '2'),
('2', 'Kim Đồng', '1'),
('1', 'NXB Thành phố HCM', '3'),
('6', 'Thanh niên', '8'),   -- id: 5
('3', 'NXB Đà Nẵng', '7'),
('1', 'NXB Trẻ', '9'),
('7', 'Thanh niên', '8');   -- id: 8

INSERT INTO PhieuNhap(NgayLap, TongTien) VALUES ('19/07/2023', '312000');
INSERT INTO PhieuNhap(NgayLap, TongTien) VALUES ('24/08/2023', '408000');
INSERT INTO PhieuNhap(NgayLap, TongTien) VALUES ('07/11/2023', '504000');

INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('1', '3', '2', '37000');
INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('1', '4', '2', '62000');
INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('1', '5', '2', '57000');

INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('2', '1', '5', '42000');
INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('2', '8', '3', '66000');

INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('3', '6', '5', '77600');
INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('3', '7', '2', '58000');

-- MaCuonSach = MaSach_MaCTPN_index 
-- (1 <= index <= ChiTietPhieuNhap.soLuong)
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('3_1_1', 'Có sẵn', 'B5.14 - Kệ sách 9 - Tầng 1 (dưới cùng)', '1', '3');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('3_1_2', 'Có sẵn', 'B5.14 - Kệ sách 9 - Tầng 1 (dưới cùng)', '1', '3');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('4_2_1', 'Có sẵn', 'C3.09 - Kệ sách 2 - Tầng 7', '2', '4');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('4_2_2', 'Có sẵn', 'C3.09 - Kệ sách 2 - Tầng 7', '2', '4');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('5_3_1', 'Có sẵn', 'B4.20 - Kệ sách 1 - Tầng 4', '3', '5');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('5_3_2', 'Có sẵn', 'B4.20 - Kệ sách 1 - Tầng 4', '3', '5');

INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('1_4_1', 'Có sẵn', '', '4', '1');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('1_4_2', 'Có sẵn', '', '4', '1');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('1_4_3', 'Có sẵn', '', '4', '1');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('1_4_4', 'Có sẵn', '', '4', '1');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('1_4_5', 'Có sẵn', '', '4', '1');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('8_5_1', 'Có sẵn', 'B4.20 - Kệ sách 1 - Tầng 5 (trên cùng)', '5', '8');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('8_5_2', 'Có sẵn', 'B4.20 - Kệ sách 1 - Tầng 5 (trên cùng)', '5', '8');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('8_5_3', 'Có sẵn', 'B4.20 - Kệ sách 1 - Tầng 5 (trên cùng)', '5', '8');


INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('6_6_1', 'Có sẵn', '', '6', '6');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('7_7_1', 'Có sẵn', '', '7', '7');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('6_6_2', 'Có sẵn', '', '6', '6');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('7_7_2', 'Có sẵn', '', '7', '7');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('6_6_3', 'Có sẵn', '', '6', '6');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('6_6_4', 'Có sẵn', '', '6', '6');
INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('6_6_5', 'Có sẵn', '', '6', '6');

INSERT INTO LichSuTimKiemCuonSach(SearchTimestamp, TuKhoa)
VALUES
('1699439023', 'cha giàu cha nghèo'),
('1699439024', 'cố định'),
('1699439025', 'paulo coe'),
('1699439026', 'cô gái năm ấy'),
('1699439027', 'thất tịch không mưa');

INSERT INTO TacGia(TenTacGia) 
VALUES
('Paulo Coelho'), -- id: 1
('J. D. Salinger'), -- id: 2
('Viktor Frankl'),
('Nguyễn Nhật Ánh'), -- id: 4
('Cửu Bả Đao'),
('Cửu Dạ Hồi'),
('Nguyễn Ngọc Tư'),
('Robert Kiyosaki'),
('Sharon L. Lechter');

INSERT INTO TacGia_DauSach(MaTacGia, MaDauSach) 
VALUES
('1', '1'),
('2', '2'),
('3', '3'),
('4', '4'),
('4', '9'),
('5', '5'),
('6', '6'),
('7', '7'),
('8', '8'),
('9', '8');

INSERT INTO TheLoai(TenTheLoai) 
VALUES
('Tiểu thuyết'),    -- id: 1
('Hư cấu kỳ ảo'),   -- id: 2
('Phiêu lưu'),
('Giáo dục'),
('Tuổi mới lớn'),
('Tự truyện'),      -- id: 6
('Tình yêu'),       -- id: 7
('Đời sống'),
('Buồn'),           -- id: 9
('Tài chính');

INSERT INTO DauSach_TheLoai(MaDauSach, MaTheLoai) 
VALUES
('1', '1'),
('1', '2'),
('1', '3'),
('2', '4'),
('2', '5'),
('3', '6'),
('4', '5'),
('5', '5'),
('5', '7'),
('6', '7'),
('7', '8'),
('8', '10');