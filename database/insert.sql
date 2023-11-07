INSERT INTO DocGia(HoTen, NgaySinh, DiaChi, SoDienThoai, NgayLapThe, NgayHetHan, TongNo) 
VALUES
('Trần Lê Hoàng Lâm', '17/04/2003', 'S8.01 VGP, Quận 9, Thủ Đức', '0915203143', '27/10/2023', '27/04/2024', 0),
('Tăng Thị Kim Nguyên', '01/05/2003', '13 Nguyễn Thị Định, phường Thanh Hà, Thành phố Hội An', '0905746418', '24/08/2023', '24/02/2024', 0),
('Bùi Cường', '12/09/2003', 'A ma quang, phường Tự An, Thành phố Buôn Mê Thuộc', '0914119624', '15/09/2023', '15/03/2024', 14000),
('Nguyễn Viết Hường', '17/09/2003', 'S5.01 VGP, Long Thạnh Mỹ, Quận 9, Tp HCM', '0975664494', '24/07/2022', '24/01/2023', 20000),
('Trần Văn Sơn', '06/06/1975', '506 Hùng Vương, phường Thanh Hà, Thành phố Hội An', '0986780715', '31/08/2023', '02/03/2024', 0),
('Đỗ Mai Minh Quân', '02/09/2004', '624 Cẩm Đường, Long Thành, Đồng Nai', '0374936329', '19/08/2023', '19/02/2024', 0),
('Đinh Nhật Thông', '26/07/2005', 'Phường Điện Ngọc, Thị xã Điện Bàn, Tỉnh Quảng Nam', '0399784005', '07/09/2023', '07/03/2024', 0),
('Lê Thị Châu Toàn', '30/09/1983', '326 Lý Thường Kiệt, Phường Minh An, Hội An, Quảng Nam', '0818055446', '21/10/2023', '21/4/2024', 0),
('Nguyễn Thị Huyền Trang', '30/11/2009', 'Hà bản, Điện Dương, Điện Bàn, Quảng Nam', '0767367435', '19/07/2023', '19/01/2024', 0),
('Lê Đăng Thương', '07/05/2001', 'Thôn 2, Xã EaNam, Huyện EaH''leo, Tỉnh Đăk Lăk', '0397824107', '28/07/2023', '28/01/2024', 0),
('Trần Vũ Bảo Phúc', '14/04/2003', '102/44/49 Pháo Đài Láng, Láng Thượng, Đống Đa, Hà Nội', '0981787708', '02/08/2023', '02/02/2024', 0),
('Nguyễn Nguyên Khương', '12/12/2008', 'I-01.04, Chung cư Sunrise Riverside, Phước Kiển, Nhà Bè, Thành phố Hồ Chí Min', '0865122487', '28/10/2023', '28/04/2024', 0),
('Nguyễn Ngọc Tín', '08/09/2005', '1163/2d Lê Đức Thọ, Quận Gò Vấp', '0522669557', '19/05/2023', '19/11/2023', 0),
('Lê Duy Thường', '16/07/2003', 'Đường số 16, Tân Phú, Quận 7, Thành phố Hồ Chí Minh', '0387992373', '01/02/2023', '01/08/2023', 0),
('Văn Minh Triết', '20/12/2001', '3/8 Đ. Số 8, Tân Quy, Quận 7, Thành phố Hồ Chí Minh', '0938083882', '09/06/2023', '09/12/2023', 0),
('Hoàng Văn Quy', '12/07/1998', 'Hẻm 233, Võ Thị Sáu, Quận 3, Thành phố Hồ Chí Minh', '0398724661', '27/07/2023', '27/01/2024', 0),
('Nguyễn Minh Châu', '28/10/2023', '40 Bế Văn Đàn, Phường 14, Tân Bình, Thành phố Hồ Chí Minh', '0397116293', '19/10/2023', '19/04/2024', 0),
('Trần Thị Thu Hoài', '16/09/2003', '69/9 Đề Thám, phường Cô Giang, Quận 1, TP HCM', '0378034554', '08/08/2023', '08/02/2024', 0),
('Phạm Thị Như Ý', '05/11/2003', '20/16 Đường số 2, phường Tân Kiểng, Quận 7', '0941288835', '28/10/2023', '28/04/2024', 0),
('Nguyễn Hồ Phúc My', '03/12/2003', '28 Mai Văn Ngọc, Phường 10, Phú Nhuận, Thành phố Hồ Chí Minh', '0905067490', '20/06/2023', '20/12/2023', 0);
-- ('', '', '', '', '', '', 0),

INSERT INTO DauSach(TenDauSach) 
VALUES 
('Nhà Giả Kim'),
('Bắt trẻ đồng xanh'),
('Đi tìm lẽ sống'),
('Ngày xưa có một chuyện tình'),
('Cô gái năm ấy chúng ta cùng theo đuổi'),
('Năm tháng vội vã'),
('Cố định một đám mây'),
('Cha giàu cha nghèo'),
('Tôi thấy hoa vàng trên cỏ xanh');


INSERT INTO Sach(LanTaiBan, NhaXuatBan, MaDauSach)
VALUES 
('5', 'NXB Trẻ', '4'),
('2', 'Ấn Tầm', '2'),
('2', 'Kim Đồng', '1'),
('1', 'NXB Thành phố HCM', '3'),
('7', 'Thanh niên', '8'),
('3', 'NXB Đà Nẵng', '7'),
('1', 'NXB Trẻ', '9');

INSERT INTO PhieuNhap(NgayLap, TongTien) 
VALUES 
('19/07/2023', '556000'),
('02/11/2023', '255000'),
('24/08/2023', '504000');

INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) 
VALUES 
('1', '3', '2', '37000'),
('1', '4', '2', '37000'),
('1', '5', '5', '62000'),
('2', '1', '2', '42000'),
('2', '5', '3', '57000'),
('3', '6', '5', '77600'),
('3', '7', '2', '58000');

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
('Tự truyện');      -- id: 6

INSERT INTO DauSach_TheLoai(MaDauSach, MaTheLoai) 
VALUES
('1', '1'),
('1', '2'),
('1', '3'),
('2', '4'),
('2', '5'),
('3', '6');